Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139B7C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Oct 2021 00:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEF1B60E05
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Oct 2021 00:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhJZAuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Oct 2021 20:50:40 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57779 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235810AbhJZAuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Oct 2021 20:50:40 -0400
Received: from dread.disaster.area (pa49-180-20-157.pa.nsw.optusnet.com.au [49.180.20.157])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7524C1058176;
        Tue, 26 Oct 2021 11:48:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mfAdS-0012Mt-AW; Tue, 26 Oct 2021 11:48:14 +1100
Date:   Tue, 26 Oct 2021 11:48:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     L A Walsh <xfs@tlinx.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfsrestore'ing from file backups don't restore...why not?
Message-ID: <20211026004814.GA5111@dread.disaster.area>
References: <617721E0.5000009@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617721E0.5000009@tlinx.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6177504f
        a=t5ERiztT/VoIE8AqcczM6g==:117 a=t5ERiztT/VoIE8AqcczM6g==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=JCTX7NPAPA7iAXPk7zYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 25, 2021 at 02:30:08PM -0700, L A Walsh wrote:
> I'm trying to do a cumulative restore a directory from a multi-file backup
> w/names:
> -rw-rw-r-- 1 1578485336160 Oct  1 06:51 home-211001-0-0437.dump
> -rw-rw-r-- 1  262411348256 Oct 23 04:53 home-211023-1-0431.dump
> -rw-rw-r-- 1    1881207032 Oct 25 04:31 home-211025-2-0430.dump
> 

Have you ever successfully restored a directory from a multi-file
backup?

Note that restore errors are often caused by something going wrong
during the dump and it not being noticed until restore is run and
the error found. And at that point, there's nothing that can be done
to "fix" the dump image so it can be restored.

What was the xfs_dump commands that created these dump files?

Did you take the dumps from a frozen filesystem or a read-only
snapshot of the filesystem, or just take it straight from a running
system?

What happens if you try to restore one dump at a time? i.e. is the
problem in the level 0 dump, or in one of the incrementals that are
based on the level 0 dump?

> So I tried restoring the full thing:
> 
> I'm getting 1000's of messages like where it doesn't seem to be able
> to restore the file and instead places it in the orphanage:
> 
> xfsrestore: NOTE: ino 1879669758 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/coherent_tail_mean.html
> xfsrestore: NOTE: ino 1879669759 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/count.html
> xfsrestore: NOTE: ino 1879669760 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/covariance.html
> xfsrestore: NOTE: ino 1879669761 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/density.html
> xfsrestore: NOTE: ino 1879669762 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/extended_p_square.html

IIUC, this means an ancestor directory in the path doesn't exist in
the inventory and so the path for restore cannot be resolved
correctly.  Hence the inode gets placed in the orphanage under the
path name that is stored with the inode.

I /think/ this error implies that the backups (dumps) were taken from
an active filesystem. i.e between the time the dump was started
and when the inventory was finally updated, the directory structure
had changed and so the dump is internally inconsistent. Hence some of
the files that were recorded in the dump image were removed before
the inventory was updated, hence there's no directories present in
the inventory that reference those files and so they get salvaged
into the orphanage for admin cleanup.

It would be interesting to know what part of the above path is
actually missing from the dump inventory, because that might help
explain what went/is going wrong...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
