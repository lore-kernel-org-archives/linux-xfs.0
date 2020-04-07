Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AEBC2BA80
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 15:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0AC32078C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 15:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n/5E2sgu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgDGPRp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 11:17:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729251AbgDGPRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 11:17:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037FBY1o079334;
        Tue, 7 Apr 2020 15:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aZZDy6uUhf3EwgPpI9e9Bbsx90CFB+REKjMwDc/LZMc=;
 b=n/5E2sguxAKUULWywom+vXpWRs5LJuSWM4lxW97sx4r0OktP5OhSwjA/zA7qWoUY2jrY
 i0SrnyAtXF0j670AHaxs+mAVpNJPthUPsGOAWLqZ81RYz6SiAwLYy1f5yiuxGqrLrxDJ
 W+96WoPDOWah+GTNIHgXPYwZpDiUYTJ30xuhnVMAi5dy1NMJh6O6lrKuqOVMmn+dBrL0
 hhhCwsYrbiqzReA38U03QDVue7tqww8rkA1udDnCXGgszFkI6CKmOZA4ERaR6sRMTYC9
 o8u022XG8qo07iOsMysAfsuNBanqwmIEuES0Wpe9FXe6wizlqvZzYKlZSe46yIFEJZRT fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 306jvn5ktv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 15:17:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037F8ZwD132736;
        Tue, 7 Apr 2020 15:17:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30839tmvwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 15:17:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 037FHdfQ014573;
        Tue, 7 Apr 2020 15:17:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 08:17:39 -0700
Date:   Tue, 7 Apr 2020 08:17:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 207053] fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Message-ID: <20200407151738.GF6742@magnolia>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
 <bug-207053-201763-xyUAU29Yyq@https.bugzilla.kernel.org/>
 <20200407131812.GB27866@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407131812.GB27866@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 09:18:12AM -0400, Brian Foster wrote:
> On Tue, Apr 07, 2020 at 06:41:31AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=207053
> > 
> > --- Comment #2 from Paul Furtado (paulfurtado91@gmail.com) ---
> > Hi Dave,
> > 
> > Just had another case of this crop up and I was able to get the blocked tasks
> > output before automation killed the server. Because the log was too large to
> > attach, I've pasted the output into a github gist here:
> > https://gist.githubusercontent.com/PaulFurtado/c9bade038b8a5c7ddb53a6e10def058f/raw/ee43926c96c0d6a9ec81a648754c1af599ef0bdd/sysrq_w.log
> > 
> 
> Hm, so it looks like this is stuck between freeze:
> 
> [377279.630957] fsfreeze        D    0 46819  46337 0x00004084
> [377279.634910] Call Trace:
> [377279.637594]  ? __schedule+0x292/0x6f0
> [377279.640833]  ? xfs_xattr_get+0x51/0x80 [xfs]
> [377279.644287]  schedule+0x2f/0xa0
> [377279.647286]  schedule_timeout+0x1dd/0x300
> [377279.650661]  wait_for_completion+0x126/0x190
> [377279.654154]  ? wake_up_q+0x80/0x80
> [377279.657277]  ? work_busy+0x80/0x80
> [377279.660375]  __flush_work+0x177/0x1b0
> [377279.663604]  ? worker_attach_to_pool+0x90/0x90
> [377279.667121]  __cancel_work_timer+0x12b/0x1b0
> [377279.670571]  ? rcu_sync_enter+0x8b/0xd0
> [377279.673864]  xfs_stop_block_reaping+0x15/0x30 [xfs]
> [377279.677585]  xfs_fs_freeze+0x15/0x40 [xfs]
> [377279.680950]  freeze_super+0xc8/0x190
> [377279.684086]  do_vfs_ioctl+0x510/0x630
> ...
> 
> ... and the eofblocks scanner:
> 
> [377279.422496] Workqueue: xfs-eofblocks/nvme13n1 xfs_eofblocks_worker [xfs]
> [377279.426971] Call Trace:
> [377279.429662]  ? __schedule+0x292/0x6f0
> [377279.432839]  schedule+0x2f/0xa0
> [377279.435794]  rwsem_down_read_slowpath+0x196/0x530
> [377279.439435]  ? kmem_cache_alloc+0x152/0x1f0
> [377279.442834]  ? __percpu_down_read+0x49/0x60
> [377279.446242]  __percpu_down_read+0x49/0x60
> [377279.449586]  __sb_start_write+0x5b/0x60
> [377279.452869]  xfs_trans_alloc+0x152/0x160 [xfs]
> [377279.456372]  xfs_free_eofblocks+0x12d/0x1f0 [xfs]
> [377279.460014]  xfs_inode_free_eofblocks+0x128/0x1a0 [xfs]
> [377279.463903]  ? xfs_inode_ag_walk_grab+0x5f/0x90 [xfs]
> [377279.467680]  xfs_inode_ag_walk.isra.17+0x1a7/0x410 [xfs]
> [377279.471567]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> [377279.475620]  ? kvm_sched_clock_read+0xd/0x20
> [377279.479059]  ? sched_clock+0x5/0x10
> [377279.482184]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> [377279.486234]  ? radix_tree_gang_lookup_tag+0xa8/0x100
> [377279.489974]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> [377279.494041]  xfs_inode_ag_iterator_tag+0x73/0xb0 [xfs]
> [377279.497859]  xfs_eofblocks_worker+0x29/0x40 [xfs]
> [377279.501484]  process_one_work+0x195/0x380
> ...
> 
> The immediate issue is likely that the eofblocks transaction is not
> NOWRITECOUNT (same for the cowblocks scanner, btw), but the problem with
> doing that is these helpers are called from other contexts outside of
> the background scanners.
> 
> Perhaps what we need to do here is let these background scanners acquire
> a superblock write reference, similar to what Darrick recently added to
> scrub..? We'd have to do that from the scanner workqueue task, so it
> would probably need to be a trylock so we don't end up in a similar
> situation as above. I.e., we'd either get the reference and cause freeze
> to wait until it's dropped or bail out if freeze has already stopped the
> transaction subsystem. Thoughts?

Hmm, I had a whole gigantic series to refactor all the speculative
preallocation gc work into a single thread + radix tree tag; I'll see if
that series actually fixed this problem too.

But yes, all background threads that run transactions need to have
freezer protection.

--D

> Brian
> 
> > 
> > Thanks,
> > Paul
> > 
> > -- 
> > You are receiving this mail because:
> > You are watching the assignee of the bug.
> > 
> 
