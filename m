Return-Path: <SRS0=pdRq=4R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BE2C3F2CD
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 17:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03E3222C4
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 17:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sXRswj3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgB2RDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Feb 2020 12:03:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgB2RDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Feb 2020 12:03:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01TGvp1w194538;
        Sat, 29 Feb 2020 17:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7wf/PiSxpCX1xbAzQCEe3CKVB6NjLpxqfIOPCLFCfY0=;
 b=sXRswj3bgdNrxGU/AwRA6DiaMxInF8QmhEAdrLcI5HtVjN/TG084iggpec6qjNjPucs2
 oMxjLIdkQ52ZekPVcZKskhyZUYuhs1TyV5A/GGct4et74Cn4j4h5iRBl+U45wGKwt3pC
 RPvMWIYQ9RJFzgWqgfJT1b3dIGMG/MWmUhGW/BcfdavsiAW0YHe1Lb3GFHZmHkdqSvfw
 1nWm53UhPSlNcoqgO93KaP62FMJvdgm5S5YoDCnY6LLSXGGVcdWrUfrdXY3D0xLVylVY
 D5WWrAsYsTOGJfcTyo1Lat4H/Am76SR4uTr+aBgnL5rAJ5GLb4G/uAARfBjP7h+EgMHB yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yffwq9f15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 17:02:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01TGuQrD091601;
        Sat, 29 Feb 2020 17:00:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yffs6xq9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 17:00:56 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01TH0rj8014067;
        Sat, 29 Feb 2020 17:00:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 29 Feb 2020 09:00:53 -0800
Date:   Sat, 29 Feb 2020 09:00:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, renxudong1@huawei.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH v3] xfs: add agf freeblocks verify in xfs_agf_verify
Message-ID: <20200229170051.GW8045@magnolia>
References: <1582260435-20939-1-git-send-email-zhengbin13@huawei.com>
 <20200221153803.GP9506@magnolia>
 <7c1a5d5c-9af0-1682-38d7-25ebe016c3c3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1a5d5c-9af0-1682-38d7-25ebe016c3c3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9546 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9546 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 29, 2020 at 07:21:17PM +0800, zhengbin (A) wrote:
> Hi, is this ok?

Yes.  I'll update for-next next week once my prepared branch finishes
running through torture testing.

--D

> On 2020/2/21 23:38, Darrick J. Wong wrote:
> > On Fri, Feb 21, 2020 at 12:47:15PM +0800, Zheng Bin wrote:
> >> We recently used fuzz(hydra) to test XFS and automatically generate
> >> tmp.img(XFS v5 format, but some metadata is wrong)
> >>
> >> xfs_repair information(just one AG):
> >> agf_freeblks 0, counted 3224 in ag 0
> >> agf_longest 536874136, counted 3224 in ag 0
> >> sb_fdblocks 613, counted 3228
> >>
> >> Test as follows:
> >> mount tmp.img tmpdir
> >> cp file1M tmpdir
> >> sync
> >>
> >> In 4.19-stable, sync will stuck, the reason is:
> >> xfs_mountfs
> >>   xfs_check_summary_counts
> >>     if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> >>        XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
> >>        !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
> >> 	return 0;  -->just return, incore sb_fdblocks still be 613
> >>     xfs_initialize_perag_data
> >>
> >> cp file1M tmpdir -->ok(write file to pagecache)
> >> sync -->stuck(write pagecache to disk)
> >> xfs_map_blocks
> >>   xfs_iomap_write_allocate
> >>     while (count_fsb != 0) {
> >>       nimaps = 0;
> >>       while (nimaps == 0) { --> endless loop
> >>          nimaps = 1;
> >>          xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again
> >> xfs_bmapi_write
> >>   xfs_bmap_alloc
> >>     xfs_bmap_btalloc
> >>       xfs_alloc_vextent
> >>         xfs_alloc_fix_freelist
> >>           xfs_alloc_space_available -->fail(agf_freeblks is 0)
> >>
> >> In linux-next, sync not stuck, cause commit c2b3164320b5 ("xfs:
> >> use the latest extent at writeback delalloc conversion time") remove
> >> the above while, dmesg is as follows:
> >> [   55.250114] XFS (loop0): page discard on page ffffea0008bc7380, inode 0x1b0c, offset 0.
> >>
> >> Users do not know why this page is discard, the better soultion is:
> >> 1. Like xfs_repair, make sure sb_fdblocks is equal to counted
> >> (xfs_initialize_perag_data did this, who is not called at this mount)
> >> 2. Add agf verify, if fail, will tell users to repair
> >>
> >> This patch use the second soultion.
> >>
> >> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> >> Signed-off-by: Ren Xudong <renxudong1@huawei.com>
> > Looks ok, will give this a run through fuzz testing...
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > --D
> >
> >> ---
> >>
> >> v1->v2: modify comment, add more agf verify
> >> v2->v3: modify code which is suggested by hellwig & darrick
> >> besides, remove the agf_freeblks < sb_fdblocks check, sb_fdblocks may not be true,
> >> if we have lazysbcount or not umount clean. If we check this, we need to add
> >> if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> >>     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
> >>     !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
> >> like function xfs_check_summary_counts does.
> >>
> >>  fs/xfs/libxfs/xfs_alloc.c | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> >> index d8053bc..183dc25 100644
> >> --- a/fs/xfs/libxfs/xfs_alloc.c
> >> +++ b/fs/xfs/libxfs/xfs_alloc.c
> >> @@ -2858,6 +2858,13 @@ xfs_agf_verify(
> >>  	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
> >>  		return __this_address;
> >>
> >> +	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
> >> +		return __this_address;
> >> +
> >> +	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
> >> +	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
> >> +		return __this_address;
> >> +
> >>  	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
> >>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
> >>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
> >> @@ -2869,6 +2876,10 @@ xfs_agf_verify(
> >>  	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
> >>  		return __this_address;
> >>
> >> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> >> +	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
> >> +		return __this_address;
> >> +
> >>  	/*
> >>  	 * during growfs operations, the perag is not fully initialised,
> >>  	 * so we can't use it for any useful checking. growfs ensures we can't
> >> @@ -2883,6 +2894,11 @@ xfs_agf_verify(
> >>  		return __this_address;
> >>
> >>  	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
> >> +	    be32_to_cpu(agf->agf_refcount_blocks) >
> >> +	    be32_to_cpu(agf->agf_length))
> >> +		return __this_address;
> >> +
> >> +	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
> >>  	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
> >>  	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
> >>  		return __this_address;
> >> --
> >> 2.7.4
> >>
> > .
> >
> 
