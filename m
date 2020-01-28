Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E888C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A941206A4
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgA1Xxf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 18:53:35 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58201 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbgA1Xxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 18:53:35 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BDA537E9CD2;
        Wed, 29 Jan 2020 10:53:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iwafi-0005U5-D9; Wed, 29 Jan 2020 10:53:30 +1100
Date:   Wed, 29 Jan 2020 10:53:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: mkfs: don't default to the physical sector
 size if it's bigger than XFS_MAX_SECTORSIZE
Message-ID: <20200128235330.GG18610@dread.disaster.area>
References: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
 <20200128161423.GO3447196@magnolia>
 <x49zhe7serq.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zhe7serq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=DPlXw0DKg_gyqOym5DQA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 11:54:17AM -0500, Jeff Moyer wrote:
> "Darrick J. Wong" <darrick.wong@oracle.com> writes:
> 
> > Do we need to check that ft->lsectorsize <= XFS_MAX_SECTORSIZE too?
> 
> We can.  What would be the correct response to such a situation?

Fail. The device is outside of the bounds of the validated on-disk
format at that point.

Historically speaking, the on-disk format only supports up to 32kB
sector sizes and the limitation is a journal format limitation. That
is, the journal implementation is based around 32kB buffers and
journal writes requiring atomic sector writes. Even though v2 logs
can support up to 256kB buffers, the format is still based around
32kB "segments" within the larger buffer.

IIRC, this limitation is due to the built-in sector-based "whole
buffer written" validation mechanism built into the log headers.
The v1 format has an array that can store 64 individual sector
indexes, so for 512 byte sectors the max log buffer size is 32kB.
As long as that first sector of the log buffer is written
atomically, it doesn't matter what the sector size actually is.

However, we cannot do 32kB writes to a 64kB physical sector device,
and hence the v1 format icannot support log records larger than
32kB, so the format is limited to 32kB sector sizes.

The v2 log format does increase the size of the log buffer, but it
does so by adding extension header sectors that contain the index
mapping for each 32kB sector. It works under the same principle as
the v1 log - as long as the first sector write is atomic, we can
validate the extension headers are intact and so validate all 32kB
segments of the larger buffer.

The v2 log format also allows for stripe unit padding of writes,
such that it will always write entire stripe units even when the log
buffer is not full. Hence it supports writing aligned sizes larger
than 32kB, even up to 256kB. However, it still relies on atomic
sector writes for validation.

When we moved to the v5 on-disk format, we also turned on CRC
checking of the log records. THis means we are no longer dependent
on atomic sector writes to detect torn log writes - if the first
512 byte sector is not written atomically, we can detect that in
recovery on v5 filesystems. That means we don't really care what the
sector size used by the log is anymore. We can do aligned log writes
up to 256kB, and we can detect torn single sector writes.

Hence I suspect XFS_MAX_SECTORSIZE is no longer relevant to v5
filesystems and we may be able to increase it to 64kB without any
issues. We'd need to do quite a bit more code spelunking than I've
just done, not to mention validation testing, before we can do such
a thing, though....

> > (Not that I really expect disks with 64k LBA units...)
> 
> It looks like you can tell loop to do that, but I wasn't able to make
> that happen in practice.  I'm not quite sure why, though.

IIRC, it depends on what IO alignment capability the underlying
filesystem provides via it's sector/block sizes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
