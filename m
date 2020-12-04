Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C87DC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 23:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B3022D01
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 23:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgLDXFS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:05:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDXFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 18:05:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4MtCIT104477;
        Fri, 4 Dec 2020 23:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Rs2Qm0RlXz2ve0KJ4UXf9klqOqk+PVx5YuBdME6nsgo=;
 b=sOGoUxBHHoL8otlrqy74PqcpMN2oZuScgsYQc66fuRgBy6g5SBogMwc7dCndcKa9N5vD
 6XXH5uRU5E9mt1RSc9LsSn6HLs3fX9Wqyqj4k+ekb2dmKlZPvx4LL3LwOeMtbDfXwY46
 gTmPZz7g+cQZ85xIvNwVBw6dn8sC3vSBeVaxK2LnPMQ0HgXYfHriAMUlsbaZ70jX6rF9
 WCgjoGe3oe3P9NIL9tAiLWLJWjUR1Z19kalWbTUCvgcLrIBaxi/40CqmuLtAZ5mBsqTr
 f4psiflo2SG0ZLZmbb+fuTLnrklhBr8rgARwKGsm3v1Ryn4ZjKqOzXTBEZD0Z4YqWynt 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egm5dt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 23:04:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4MtWa3007285;
        Fri, 4 Dec 2020 23:02:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g4dvq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 23:02:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B4N2V1C024892;
        Fri, 4 Dec 2020 23:02:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 15:02:31 -0800
Date:   Fri, 4 Dec 2020 15:02:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <20201204230230.GH629293@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679384513.447856.3675245763779550446.stgit@magnolia>
 <d54542e0-728f-52b4-3762-c9353fcae8de@sandeen.net>
 <20201204211206.GE106271@magnolia>
 <3123a8c7-9afe-fd73-ae6d-d8c9cd2188ad@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3123a8c7-9afe-fd73-ae6d-d8c9cd2188ad@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040131
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

Fixed.

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

Aha, yes, I missed that.

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
> 	/*
> 	 * Don't touch the filesystem if a user tool thinks it owns the primary
> 	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> 	 * we don't check them at all.
> 	 */
> 	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
> 		xfs_warn(mp, "Offline file system operation in progress!");
> 		return -EFSCORRUPTED;
> 	}
> 
> 	/* Filesystem claims it needs repair, so refuse the mount. */
> 	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> 		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
> 		return -EFSCORRUPTED;
> 	}
> 
> 	/*
> 	 * Until this is fixed only page-sized or smaller data blocks work.
> 	 */
> 	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
> 		xfs_warn(mp,
> 		"File system with blocksize %d bytes. "
> 		"Only pagesize (%ld) or less will currently work.",
> 				sbp->sb_blocksize, PAGE_SIZE);
> 		return -ENOSYS;
> 	}
> 
> 	/* Ensure this filesystem fits in the page cache limits */
>         if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
>             xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
>                 xfs_warn(mp,
>                 "file system too large to be mounted on this system.");
>                 return -EFBIG;

Sounds good to me.

--D

>         }
> 
> 	return 0;
> }
> 
> >> Maybe just fess up in the comment, and say "these checks are different 
> >> for kernel vs. userspace so we keep them over here" - and as for the
> >> function name, *shrug* not sure I have anything better...
> > 
> > _validate_implementation?  I don't have a better suggestion either.
> > 
> > --D
> > 
> >> -Eric
> >>
> > 
