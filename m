Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFADC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 20:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 436C464F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 20:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCRU4J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 16:56:09 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49180 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhCRUzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 16:55:38 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 756F71AE2EB;
        Fri, 19 Mar 2021 07:55:37 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lMzg8-0044IM-CQ; Fri, 19 Mar 2021 07:55:36 +1100
Date:   Fri, 19 Mar 2021 07:55:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210318205536.GO63242@dread.disaster.area>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318161707.723742-2-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=mohPDZ9nqkE5NQtdNsAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 12:17:06PM -0400, Brian Foster wrote:
> perag reservation is enabled at mount time on a per AG basis. The
> upcoming in-core allocation btree accounting mechanism needs to know
> when reservation is enabled and that all perag AGF contexts are
> initialized. As a preparation step, set a flag in the mount
> structure and unconditionally initialize the pagf on all mounts
> where at least one reservation is active.

I'm not sure this is a good idea. AFAICT, this means just about any
filesystem with finobt, reflink and/or rmap will now typically read
every AGF header in the filesystem at mount time. That means pretty
much every v5 filesystem in production...

We've always tried to avoid needing to reading all AG headers at
mount time because that does not scale when we have really large
filesystems (I'm talking petabytes here). We should only read AG
headers if there is something not fully recovered during the mount
(i.e. slow path) and not on every mount.

Needing to do a few thousand synchonous read IOs during mount makes
mount very slow, and as such we always try to do dynamic
instantiation of AG headers...  Testing I've done with exabyte scale
filesystems (>10^6 AGs) show that it can take minutes for mount to
run when each AG header needs to be read, and that's on SSDs where
the individual read latency is only a couple of hundred
microseconds. On spinning disks that can do 200 IOPS, we're
potentially talking hours just to mount really large filesystems...

Hence I don't think that any algorithm that requires reading every
AGF header in the filesystem at mount time on every v5 filesystem
already out there in production (because finobt triggers this) is a
particularly good idea...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
