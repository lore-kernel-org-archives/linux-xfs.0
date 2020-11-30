Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740AFC63777
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 19:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A98207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 19:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I9EhvNsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgK3T2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 14:28:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgK3T2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 14:28:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJGGL3010949;
        Mon, 30 Nov 2020 19:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OeDQJ6+wuwu5S7/Bc2BW28L35EMmcCXgiO4xlPiDNIs=;
 b=I9EhvNsGv87RXAvc4xZiVs7o+4dzuFoKmutfDfxJKKLpCujyCrJddx+v9TFV06hlpZPx
 76OPhi1oA+4DzdE0OeJxxkr2KB+eh825HPlB7SQAUwS1lgzgaELv0UyM8+SDXRnqFAjk
 p20u0PdAm3agS44BYo9GA1xPHRqy/J7ybvVgGKoiZ+rSXMQJeVVa5F1fsMJk/8tWTKrd
 QdRHIYuHTavrgUgb/XlSOzufKlRaxak6QNjVaq9t9St871KYKUFj3UhQ1ZrpoUwZGgiV
 rInwVHO0oRKclJl0U/yQ/Rqrs1162ZZlWu8/fnwA9ejL++scO/Ez5nEdSr8z4ZoDK9OY 3A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqex0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 19:28:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJQ2V4109708;
        Mon, 30 Nov 2020 19:26:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540ewydme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:26:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUJQ6Ri029690;
        Mon, 30 Nov 2020 19:26:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 11:26:06 -0800
Date:   Mon, 30 Nov 2020 11:26:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: Maximum height of rmapbt when reflink feature is enabled
Message-ID: <20201130192605.GB143049@magnolia>
References: <3275346.ciGmp8L3Sz@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3275346.ciGmp8L3Sz@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 02:35:21PM +0530, Chandan Babu R wrote:
> The comment in xfs_rmapbt_compute_maxlevels() mentions that with
> reflink enabled, XFS will run out of AG blocks before reaching maximum
> levels of XFS_BTREE_MAXLEVELS (i.e. 9).  This is easy to prove for 4k
> block size case:
> 
> Considering theoretical limits, maximum height of rmapbt can be,
> max btree height = Log_(min_recs)(total recs)
> max_rmapbt_height = Log_45(2^64) = 12.
> 
> Detailed calculation:
> nr-levels = 1; nr-leaf-blks = 2^64 / 84 = 2e17;
> nr-levels = 2; nr-blks = 2e17 / 45 = 5e15;
> nr-levels = 3; nr-blks = 5e15 / 45 = 1e14;
> nr-levels = 4; nr-blks = 1e14 / 45 = 2e12;
> nr-levels = 5; nr-blks = 2e12 / 45 = 5e10;
> nr-levels = 6; nr-blks = 5e10 / 45 = 1e9;
> nr-levels = 7; nr-blks = 1e9 / 45 = 3e7;
> nr-levels = 8; nr-blks = 3e7 / 45 = 6e5;
> nr-levels = 9; nr-blks = 6e5 / 45 = 1e4;
> nr-levels = 10; nr-blks = 1e4 / 45 = 3e2;
> nr-levels = 11; nr-blks = 3e2 / 45 = 6;
> nr-levels = 12; nr-blks = 1;
> 
> Total number of blocks = 2e17
> 
> Here, 84 is the minimum number of leaf records and 45 is the minimum
> number of node records in the rmapbt when using 4k block size. 2^64 is
> the maximum possible rmapbt records
> (i.e. max_rmap_entries_per_disk_block (2^32) * max_nr_agblocks
> (2^32)).
> 
> i.e. theoretically rmapbt height can go upto 12.
> 
> But as the comment in xfs_rmapbt_compute_maxlevels() suggests, we will
> run out of per-ag blocks trying to build an rmapbt of height
> XFS_BTREE_MAXLEVELS (i.e. 9).
> 
> Since number of nodes grows as a geometric series,
> nr_nodes (roughly) = (45^9 - 1) / (45 - 1) = 10e12
> 
> i.e. 10e12 blocks > max ag blocks (2^32 == 4e9)
> 
> 
> However, with 1k block size we are not close to consuming all of 2^32
> AG blocks as shown by the below calculations,
> 
>  - rmapbt with maximum of 9 levels will have roughly (11^9 - 1) / (11 -
>    1) = 2e8 blocks.
>    - 11 is the minimum number of recs in a non-leaf node with 1k block size.
>    - Also, Total number of records (roughly) = (nr_leaves * 11) = 11^8 * 11
>      = 2e9 (this value will be used later).
>  
>  - refcountbt
>    - Maximum number of records theoretically = maximum number of blocks
>      in an AG = 2^32
>    - Total (leaves and non-leaf nodes) blocks required to hold 2^32 records
>      Leaf min recs = 20;  Node min recs = 60 (with 1k as the block size).
>      - Detailed calculation:
>  	    nr-levels = 1; nr-leaf-blks = 2^32 / 20 = 2e8;
>  	    nr-levels = 2; nr-blks = 2e8 / 60 = 4e6
>  	    nr-levels = 3; nr-blks = 4e6 / 60 = 6e4
>  	    nr-levels = 4; nr-blks = 6e4 / 60 = 1.0e3
>  	    nr-levels = 5; nr-blks = 1.0e3 / 60 = 2e1
>  	    nr-levels = 6; nr-blks = 1
>  
>      - Total block count = 2e8
>  
>  - Bmbt (assuming all the rmapbt records have the same inode as owner)
>    - Total (leaves and non-leaf nodes) blocks required to hold 2e9 records
>      Leaf min recs = 29;  Node min recs = 29 (with 1k as the block size).
>      (2e9 is the maximum rmapbt records with rmapbt height 9 and 1k block size).
>        nr-levels = 1; nr-leaf-blks = 2e9 / 29 = 7e7
>        nr-levels = 2; nr-blks = 7e7 / 29 = 2e6
>        nr-levels = 3; nr-blks = 2e6 / 29 = 8e4
>        nr-levels = 4; nr-blks = 8e4 / 29 = 3e3
>        nr-levels = 5; nr-blks = 3e3 / 29 = 1e2
>        nr-levels = 6; nr-blks = 1e2 / 29 = 3
>        nr-levels = 7; nr-blks = 1
>  
>    - Total block count = 7e7
>  
>  Total blocks used across rmapbt, refcountbt and bmbt = 2e8 + 2e8 + 7e7 = 5e8.
>  
> Since 5e8 < 4e9(i.e. 2^32), we have not run out of blocks trying to
> build a rmapbt with XFS_BTREE_MAXLEVELS (i.e 9) levels.
> 
> Please let me know if my understanding is incorrect.

I have no idea what is the real upper limit on the number of rmap
records on a reflink filesystem -- as the rmap btree gets bigger, the
maximum number of records that one could need to store in that btree
gets smaller because rmap btree blocks cannot be shared and all have the
same owner (_OWN_AG).

But your reasoning seems correct.

> I have come across a "log reservation" calculation issue when
> increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for

Hmm.  That will increase the size of the btree cursor structure even
farther.  It's already gotten pretty bad with the realtime rmap and
reflink patchsets since the realtime volume can have 2^63 blocks, which
implies a theoretical maximum rtrmapbt height of 21 levels and a maximum
rtrefcountbt height of 13 levels.

(These heights are absurd, since they imply a data device of 2^63
blocks...)

I suspect that we need to split MAXLEVELS into two values -- one for
per-AG btrees, and one for per-file btrees, and then refactor the btree
cursor so that the level data are a single VLA at the end.  I started a
patchset to do all that[1], but it's incomplete.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=btree-dynamic-depth&id=692f761838dd821cd8cc5b3d1c66d6b1ac8ec05b

> extending data fork extent count to 48 bits. To proceed further, I
> need to have a correct understanding of problem I have described w.r.t
> 1k filesystem block size.

<nod>

--D

> 
> -- 
> chandan
> 
> 
> 
