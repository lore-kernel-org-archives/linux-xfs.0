Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46813C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04306206D3
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rrkrCS8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfLXQh5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 11:37:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfLXQh5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 11:37:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGYMWV084142;
        Tue, 24 Dec 2019 16:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=MzsBhShTM7Zk8VxDkdQiF6KPW+0ztc2BUMM95giDn7c=;
 b=rrkrCS8+QiFYdLb4wXGOvVHgU30mvjRPx6GCmPoRpP6Y/ZpnUhpgR6bgIHjGZLcvbq4D
 CcxVQ5zso8lqX7SMMp5VV7MRbjh6GSmnDITE5yKU3b+vkIJjCk+tdRWQOZrvAfKkBh0T
 gbQMEdehwgfw+LdhPYdVqe4UXkjQxLjHJzw8EDNdzvhSRju+DYIlvgOPQPYGDMIOvJnT
 AbgUs/9+87Lw1LyfwBFBPk7pSG9rj2ozHP9HHpUjsZk7bZyzBc24GoQIU2M2bHDjmcKt
 fz6LuQk/zIxyERE401UaLOGJFQOqwPUtbIQD0US+2+knvjhOQS8OckB680W4fF8X7rJU 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x1c1qv9xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:37:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGYVOM163798;
        Tue, 24 Dec 2019 16:37:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x3amrh0fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:37:50 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBOGbnqZ012219;
        Tue, 24 Dec 2019 16:37:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 08:37:48 -0800
Date:   Tue, 24 Dec 2019 08:37:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix s_maxbytes computation on 32-bit kernels
Message-ID: <20191224163749.GY7489@magnolia>
References: <20191222163711.GT7489@magnolia>
 <20191224082500.GB26649@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224082500.GB26649@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 12:25:00AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 22, 2019 at 08:37:11AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > I observed a hang in generic/308 while running fstests on a i686 kernel.
> > The hang occurred when trying to purge the pagecache on a large sparse
> > file that had a page created past MAX_LFS_FILESIZE, which caused an
> > integer overflow in the pagecache xarray and resulted in an infinite
> > loop.
> > 
> > I then noticed that Linus changed the definition of MAX_LFS_FILESIZE in
> > commit 0cc3b0ec23ce ("Clarify (and fix) MAX_LFS_FILESIZE macros") so
> > that it is now one page short of the maximum page index on 32-bit
> > kernels.  Because the XFS function to compute max offset open-codes the
> > 2005-era MAX_LFS_FILESIZE computation and neither the vfs nor mm perform
> > any sanity checking of s_maxbytes, the code in generic/308 can create a
> > page above the pagecache's limit and kaboom.
> > 
> > So, fix the function to return MAX_LFS_FILESIZE, but check that bmbt
> > record offsets have enough space to handle that many bytes.  I have no
> > answer for why this seems to have been broken for years and nobody
> > noticed.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_super.c |   37 ++++++++++++++++---------------------
> >  1 file changed, 16 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d9ae27ddf253..30a17e5ffa67 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -193,30 +193,25 @@ xfs_fs_show_options(
> >  	return 0;
> >  }
> >  
> > -static uint64_t
> > +static loff_t
> >  xfs_max_file_offset(
> > -	unsigned int		blockshift)
> > +	struct xfs_mount	*mp)
> >  {
> > -	unsigned int		pagefactor = 1;
> > -	unsigned int		bitshift = BITS_PER_LONG - 1;
> > -
> > -	/* Figure out maximum filesize, on Linux this can depend on
> > -	 * the filesystem blocksize (on 32 bit platforms).
> > -	 * __block_write_begin does this in an [unsigned] long long...
> > -	 *      page->index << (PAGE_SHIFT - bbits)
> > -	 * So, for page sized blocks (4K on 32 bit platforms),
> > -	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
> > -	 *      (((u64)PAGE_SIZE << (BITS_PER_LONG-1))-1)
> > -	 * but for smaller blocksizes it is less (bbits = log2 bsize).
> > +	/*
> > +	 * XFS block mappings use 54 bits to store the logical block offset.
> > +	 * This should suffice to handle the maximum file size that the VFS
> > +	 * supports (currently 2^63 bytes on 64-bit and ULONG_MAX << PAGE_SHIFT
> > +	 * bytes on 32-bit), but as XFS and VFS have gotten the s_maxbytes
> > +	 * calculation wrong on 32-bit kernels in the past, we'll add a WARN_ON
> > +	 * to check this assertion before returning MAX_LFS_FILESIZE.
> > +	 *
> > +	 * Avoid integer overflow by comparing the maximum bmbt offset to the
> > +	 * maximum pagecache offset in units of fs blocks.
> >  	 */
> > +	WARN_ON(((1ULL << BMBT_STARTOFF_BITLEN) - 1) <
> > +		XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE));
> >  
> > -#if BITS_PER_LONG == 32
> > -	ASSERT(sizeof(sector_t) == 8);
> > -	pagefactor = PAGE_SIZE;
> > -	bitshift = BITS_PER_LONG;
> > -#endif
> > -
> > -	return (((uint64_t)pagefactor) << bitshift) - 1;
> > +	return MAX_LFS_FILESIZE;
> >  }
> >  
> >  /*
> > @@ -1435,7 +1430,7 @@ xfs_fc_fill_super(
> >  	sb->s_magic = XFS_SUPER_MAGIC;
> >  	sb->s_blocksize = mp->m_sb.sb_blocksize;
> >  	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
> > -	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
> > +	sb->s_maxbytes = xfs_max_file_offset(mp);
> 
> The code organization is really weird now.  Just assign MAX_LFS_FILESIZE
> to s_maxbytes directly here, and move the WARN_ON right next to it -
> preferably as a WARN_ON_ONCE with an actual error return instead of
> just warning.

Ok.

--D
