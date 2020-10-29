Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40AAC4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F8B20790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fE7mOZ4W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgJ2Q31 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 12:29:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgJ2Q31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 12:29:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TG94Nu148685;
        Thu, 29 Oct 2020 16:29:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6n/Qhv/8dvgJL1UYEmihO9wnUFV3XFgWnbsiSR35Dng=;
 b=fE7mOZ4WqKvmn7yxqD7aD4qOHFi9Wtc4IJyhPTEyOAeWu9371cbV+N7+X3+ki4X48Jjz
 eucJTZ/Znpf/yAeKN9ZAxSyGI03b7kuseX1RsUaF4LLvNlG6WEDpywo4f/ZU9sfXkRz1
 +VbrAGxXRBUYvVddCqDd7LhPCmH6avoip7uR3aiXy2lPW45J8mbzadkh/5f3wfh7bLsE
 xEsVOzh1EsjyaJ2ZyEpTojkjE8kLv4KlIKZw0EMau/PKS70w4ki+bNwMhBlx6LKTpuQl
 IIh8U8Pa8Xzh2rl8dDIHsPPSEOokzh40Yw/RKQpN5n2WZeVFercMmki82emrB6vmh8Wm uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm4bee8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 16:29:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TGATcQ008819;
        Thu, 29 Oct 2020 16:29:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1tdrnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 16:29:24 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TGTNe5021045;
        Thu, 29 Oct 2020 16:29:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 09:29:23 -0700
Date:   Thu, 29 Oct 2020 09:29:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] repair: scale duplicate name checking in phase 6.
Message-ID: <20201029162922.GM1061252@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-8-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=7 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=7 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290113
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 04:15:37PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> phase 6 on large directories is cpu bound on duplicate name checking
> due to the algorithm having effectively O(n^2) scalability. Hence
> when the duplicate name hash table  size is far smaller than the
> number of directory entries, we end up with long hash chains that
> are searched linearly on every new entry that is found in the
> directory to do duplicate detection.
> 
> The in-memory hash table size is limited to 64k entries. Hence when
> we have millions of entries in a directory, duplicate entry lookups
> on the hash table have substantial overhead. Scale this table out to
> larger sizes so that we keep the chain lengths short and hence the
> O(n^2) scalability impact is limited because N is always small.
> 
> For a 10M entry directoryi consuming 400MB of directory data, the
> hash table now sizes at 6.4 million entries instead of ~64k - it is
> ~100x larger. While the hash table now consumes ~50MB of RAM, the
> xfs_repair footprint barely changes at it's using already consuming
> ~9GB of RAM at this point in time. IOWs, the incremental memory
> usage change is noise, but the directory checking time:
> 
> Unpatched:
> 
>   97.11%  xfs_repair          [.] dir_hash_add
>    0.38%  xfs_repair          [.] longform_dir2_entry_check_data
>    0.34%  libc-2.31.so        [.] __libc_calloc
>    0.32%  xfs_repair          [.] avl_ino_start
> 
> Phase 6:        10/22 12:11:40  10/22 12:14:28  2 minutes, 48 seconds
> 
> Patched:
> 
>   46.74%  xfs_repair          [.] radix_tree_lookup
>   32.13%  xfs_repair          [.] dir_hash_see_all
>    7.70%  xfs_repair          [.] radix_tree_tag_get
>    3.92%  xfs_repair          [.] dir_hash_add
>    3.52%  xfs_repair          [.] radix_tree_tag_clear
>    2.43%  xfs_repair          [.] crc32c_le
> 
> Phase 6:        10/22 13:11:01  10/22 13:11:18  17 seconds
> 
> has been reduced by an order of magnitude.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/phase6.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 21f49dd748e1..7dd6130056ee 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -288,19 +288,37 @@ dir_hash_done(
>  	free(hashtab);
>  }
>  
> +/*
> + * Create a directory hash index structure based on the size of the directory we
> + * are about to try to repair. The size passed in is the size of the data
> + * segment of the directory in bytes, so we don't really know exactly how many
> + * entries are in it. Hence assume an entry size of around 64 bytes - that's a
> + * name length of 40+ bytes so should cover a most situations with large
> + * really directories.

"...with really large directories." ?

> + */
>  static struct dir_hash_tab *
>  dir_hash_init(
>  	xfs_fsize_t		size)
>  {
> -	struct dir_hash_tab	*hashtab;
> +	struct dir_hash_tab	*hashtab = NULL;
>  	int			hsize;
>  
> -	hsize = size / (16 * 4);
> -	if (hsize > 65536)
> -		hsize = 63336;
> -	else if (hsize < 16)
> +	hsize = size / 64;
> +	if (hsize < 16)
>  		hsize = 16;

Since I'm not that familiar with the directory hash table, I'm curious
about our choice of hash table size (which is hsize, right?).  IIRC most
CS textbooks tell you to pick a "clever" hash table size that's a prime
number just in case the values are unevenly distributed.

I don't know if that's the case here because I haven't studied the
directory name hash in detail, but I wonder, do we have a way to measure
the length of the hash chains?  Or at least the evenness of them?

I'm vaguely wondering if there's more gains to be had here.  Mmm science
projects...

(The rest of the code here looks reasonable to me, fwiw.)

--D

> -	if ((hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1)) == NULL)
> +
> +	/*
> +	 * Try to allocate as large a hash table as possible. Failure to
> +	 * allocate isn't fatal, it will just result in slower performance as we
> +	 * reduce the size of the table.
> +	 */
> +	while (hsize >= 16) {
> +		hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1);
> +		if (hashtab)
> +			break;
> +		hsize /= 2;
> +	}
> +	if (!hashtab)
>  		do_error(_("calloc failed in dir_hash_init\n"));
>  	hashtab->size = hsize;
>  	hashtab->byhash = (struct dir_hash_ent **)((char *)hashtab +
> -- 
> 2.28.0
> 
