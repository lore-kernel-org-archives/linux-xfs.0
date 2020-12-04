Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBE2C4167B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 23:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B2E922D3E
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 23:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgLDX36 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:29:58 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34945 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgLDX36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 18:29:58 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 53AEE1AE002;
        Sat,  5 Dec 2020 10:29:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1klKVt-000ZGZ-0t; Sat, 05 Dec 2020 10:29:21 +1100
Date:   Sat, 5 Dec 2020 10:29:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <20201204232921.GH3913616@dread.disaster.area>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679384513.447856.3675245763779550446.stgit@magnolia>
 <d54542e0-728f-52b4-3762-c9353fcae8de@sandeen.net>
 <20201204211206.GE106271@magnolia>
 <3123a8c7-9afe-fd73-ae6d-d8c9cd2188ad@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3123a8c7-9afe-fd73-ae6d-d8c9cd2188ad@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=rgEY-LVCiogrsf675ugA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 03:46:19PM -0600, Eric Sandeen wrote:
> On 12/4/20 3:12 PM, Darrick J. Wong wrote:
> > On Fri, Dec 04, 2020 at 02:35:45PM -0600, Eric Sandeen wrote:
> >> On 11/30/20 9:37 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> A couple of the superblock validation checks apply only to the kernel,
> >>> so move them to xfs_mount.c before we start changing sb_inprogress.
> 
> oh also, you're not changing sb_inprogress anymore, right? ;)
> 
> >>> This also reduces the diff between kernel and userspace libxfs.
> >>
> >> My only complaint is that "xfs_sb_validate_mount" isn't really descriptive
> >> at all, and nobody reading the code or comments will know why we've chosen
> >> to move just these two checks out of the common validator...
> >>
> >> What does "compatible with this mount" mean?
> > 
> > Compatible with this implementation?
> 
> Hm.
> 
> So most of xfs_validate_sb_common is doing internal consistency checking
> that has nothing at all to do with the host's core capabilities or filesystem
> "state" (other than version/features I guess).
> 
> You've moved out the PAGE_SIZE check, which depends on the host.
> 
> You've also moved the inprogress check, which depends on state.
> (and that's not really "kernel-specific" is it?)
> 
> You'll later move the NEEDSREPAIR check, which I guess is state.
> 
> But you haven't moved the fsb_count-vs-host check, which depends on the host.
> 
> (and ... I think that one may actually be kernel-specific,
> because it depends on pagecache limitations in the kernel, so maybe it
> should be moved out as well?)
> 
> So maybe the distinction is internal consistency checks, vs
> host-compatibility-and-filesystem-state checks.
> 
> How about ultimately:
> 
> /*
>  * Do host compatibility and filesystem state checks here; these are unique
>  * to the kernel, and may differ in userspace.
>  */
> xfs_validate_sb_host(
> 	struct xfs_mount	*mp,
> 	struct xfs_buf		*bp,
> 	struct xfs_sb		*sbp)
> {

THis host stuff should be checked in xfs_fs_fill_super(), right?

i.e. it's not really part of the superblock validation, but checking
if the host can actually run this filesystem. That's what we do in
xfs_fc_fill_super(), such as the max file size support, whether
mount options are valid for the superblock config (e.g. reflink vs
rt) and so on. IOWs, these aren't corruption verifiers, just config
checks, so we should put them with all the other config checks we do
at mount time...

i.e. call it something like xfs_fs_validate_sb_config() and move all
the config and experimental function checks into it, call it only
from xfs_fs_fill_super() once we've already read in and validated
the superblock is within the bounds defined by the on-disk format.

Oh, and just another thing: can we rename all the "xfs_fc_*"
functions in xfs_super.c back to xfs_fs_*? I'm getting tired of not
being about to find the superblock init functions in xfs_super.c
(e.g. xfs_fs_fill_super()) with grep or cscope because they have a
whacky, one-off namespace now...

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
