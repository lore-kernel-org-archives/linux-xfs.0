Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB53EC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C066D22B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZNuv43AI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgGUAwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:52:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60454 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGUAwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:52:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0pNHF057432;
        Tue, 21 Jul 2020 00:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rI1HcSfnUVf5RMk7sgnEOofmzka6HDCkBpZLuH6oWnI=;
 b=ZNuv43AIGkC8xnJmtMmnS/OyzmyeoYzAxVnCntE7RJAS7984qLQMKwY9eDIojFhWqIcR
 By7HAGK8nPDWvK0uDFNSZ2byYbKZOCH88Ue6/w2vblRjiGdGztixbwIkc3nkZZlpMNgh
 qItYEia8Fmqzxk1AJ0mVF7uL0WUF2OvvwXZUcgTVUX8F0P1HRg6f597ITRWdkXBed9Ic
 lajeac8eFK8t4KG5VFHL+HtWKpgwdW2REc50Yb7g3ar03rL4b1t9ifn3Uewh13o15BhR
 m7GaYMDipDfZtosAxcdwap04Kji/D492yQmAIekiJZZ2l85DF/b3QU9vkEKvzxrtaalt Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1ma0r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 00:52:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0gxox069130;
        Tue, 21 Jul 2020 00:52:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32dnmq90v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 00:52:18 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L0lHDG018268;
        Tue, 21 Jul 2020 00:47:17 GMT
Received: from localhost (/10.159.141.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 00:47:17 +0000
Date:   Mon, 20 Jul 2020 17:47:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] repair: use fs rootino for dummy parent value instead
 of zero
Message-ID: <20200721004716.GV3151642@magnolia>
References: <20200715140836.10197-4-bfoster@redhat.com>
 <20200717115920.59986-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717115920.59986-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=1 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 07:59:20AM -0400, Brian Foster wrote:
> If a directory inode has an invalid parent ino on disk, repair
> replaces the invalid value with a dummy value of zero in the buffer
> and NULLFSINO in the in-core parent tracking. The zero value serves
> no functional purpose as it is still an invalid value and the parent
> must be repaired by phase 6 based on the in-core state before the
> buffer can be written out. A consequence of using an invalid dummy
> value is that phase 6 requires custom verifier infrastructure to
> detect the invalid parent inode and temporarily replace it while the
> core fork verifier runs. If we use a valid inode number as a dummy
> value earlier in repair, this workaround can be removed.
> 
> An obvious choice for a valid dummy parent inode value is the
> orphanage inode. However, the orphanage inode is not allocated until
> much later in repair when the filesystem structure is established as
> sound and placement of orphaned inodes is imminent. In this case, it
> is too early to know for sure whether the associated inodes are
> orphaned because a directory traversal later in repair can locate
> references to the inode and repair the parent value based on the
> structure of the directory tree.
> 
> Given all of this, escalate the preexisting workaround from the
> custom verifier in phase 6 and set the root inode value as a dummy
> parent for shortform directories with an invalid on-disk parent. The
> in-core parent is still tracked as NULLFSINO and so forces repair to
> either update the parent or orphan the inode before repair
> completes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Finally this stupid dragon dies!

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2:
> - Update patch subject and commit log.
> 
>  repair/dir2.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index caf6963d..9c789b4a 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -165,7 +165,6 @@ process_sf_dir2(
>  	int			tmp_elen;
>  	int			tmp_len;
>  	xfs_dir2_sf_entry_t	*tmp_sfep;
> -	xfs_ino_t		zero = 0;
>  
>  	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
>  	max_size = XFS_DFORK_DSIZE(dip, mp);
> @@ -497,7 +496,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
>  		if (!no_modify)  {
>  			do_warn(_("clearing inode number\n"));
>  
> -			libxfs_dir2_sf_put_parent_ino(sfp, zero);
> +			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
>  			*dino_dirty = 1;
>  			*repair = 1;
>  		} else  {
> @@ -532,7 +531,7 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
>  		if (!no_modify)  {
>  			do_warn(_("clearing inode number\n"));
>  
> -			libxfs_dir2_sf_put_parent_ino(sfp, zero);
> +			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
>  			*dino_dirty = 1;
>  			*repair = 1;
>  		} else  {
> -- 
> 2.21.3
> 
