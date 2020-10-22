Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A84C388F2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 06:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A712245F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 06:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rw9jKs98"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503266AbgJVGFC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 02:05:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36204 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503296AbgJVGFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 02:05:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M5wwAD034715;
        Thu, 22 Oct 2020 06:04:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nWcKeRkxgaSHho6jVQk8uuW0O5LTjwdyj9yUKrD/p6I=;
 b=rw9jKs98THTTQj2TpgvEqNBjEbwFzjLVxKVtmtKuEkJR0WsW5+gH/SDFv5bl1MsFRPHi
 9bydTGSz2UetlqBVX9fgWK8OzM3ZqaOpl7AEUMu2jweO5y3YJ45ZqYE6dVdN54nvOmad
 LQJvfzl/dbbQQtCBMpjzHpGTIzMnIuINxGeSsNXynE9YsoU5pXIiX0dAdjslsOvNk5hM
 RiEWdpNr1EYgTEZu0W8Khvc7LNpDcp0THzAUUm7frIMyM+K+tLXzspZWQzqBW4anHCLq
 pHhfIVGemrGDHkxMAyyMP9j+Aih4am5UqAfQNYkntngiwsSjZLKuC98OXKkGtxr4kZvT 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 347p4b43f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 06:04:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M60AxO110910;
        Thu, 22 Oct 2020 06:02:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 348a6q7h4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 06:02:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M62vAr009862;
        Thu, 22 Oct 2020 06:02:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 23:02:57 -0700
Date:   Wed, 21 Oct 2020 23:02:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] repair: protect inode chunk tree records with a mutex
Message-ID: <20201022060256.GO9832@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-4-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=5 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 04:15:33PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Phase 6 accesses inode chunk records mostly in an isolated manner.
> However, when it finds a corruption in a directory or there are
> multiple hardlinks to an inode, there can be concurrent access
> to the inode chunk record to update state.
> 
> Hence the inode record itself needs a mutex. This protects all state
> changes within the inode chunk record, as well as inode link counts
> and chunk references. That allows us to process multiple chunks at
> once, providing concurrency within an AG as well as across AGs.
> 
> The inode chunk tree itself is not modified in phase 6 - it's built

Well, that's not 100% true -- mk_orphanage can do that, but AFAICT
that's outside the scope of the parallel processing (and I don't see
much point in parallelizing that part) so I guess that's fine?

> in phases 3 and 4  - and so we do not need to worry about locking
> for AVL tree lookups to find the inode chunk records themselves.
> hence internal locking is all we need here.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

TBH I wonder if all the phase6.c code to recreate the root dir, the
orphanage, and the realtime inodes ought to get moved to another file,
particularly since the metadata directory patches add quite a bit more
stuff here?  But that's a topic for another patch...

I /think/ this looks ok, but I guess I'll go look at the rest of the
series.

--D

> ---
>  repair/incore.h     | 23 +++++++++++++++++++++++
>  repair/incore_ino.c | 15 +++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/repair/incore.h b/repair/incore.h
> index 5b29d5d1efd8..6564e0d38963 100644
> --- a/repair/incore.h
> +++ b/repair/incore.h
> @@ -282,6 +282,7 @@ typedef struct ino_tree_node  {
>  		parent_list_t	*plist;		/* phases 2-5 */
>  	} ino_un;
>  	uint8_t			*ftypes;	/* phases 3,6 */
> +	pthread_mutex_t		lock;
>  } ino_tree_node_t;
>  
>  #define INOS_PER_IREC	(sizeof(uint64_t) * NBBY)
> @@ -412,7 +413,9 @@ next_free_ino_rec(ino_tree_node_t *ino_rec)
>   */
>  static inline void add_inode_refchecked(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_un.ex_data->ino_processed |= IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline int is_inode_refchecked(struct ino_tree_node *irec, int offset)
> @@ -438,12 +441,16 @@ static inline int is_inode_confirmed(struct ino_tree_node *irec, int offset)
>   */
>  static inline void set_inode_isadir(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_isa_dir |= IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline void clear_inode_isadir(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_isa_dir &= ~IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline int inode_isadir(struct ino_tree_node *irec, int offset)
> @@ -456,15 +463,19 @@ static inline int inode_isadir(struct ino_tree_node *irec, int offset)
>   */
>  static inline void set_inode_free(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	set_inode_confirmed(irec, offset);
>  	irec->ir_free |= XFS_INOBT_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  
>  }
>  
>  static inline void set_inode_used(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	set_inode_confirmed(irec, offset);
>  	irec->ir_free &= ~XFS_INOBT_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline int is_inode_free(struct ino_tree_node *irec, int offset)
> @@ -477,7 +488,9 @@ static inline int is_inode_free(struct ino_tree_node *irec, int offset)
>   */
>  static inline void set_inode_sparse(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ir_sparse |= XFS_INOBT_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
> @@ -490,12 +503,16 @@ static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
>   */
>  static inline void set_inode_was_rl(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_was_rl |= IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline void clear_inode_was_rl(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_was_rl &= ~IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline int inode_was_rl(struct ino_tree_node *irec, int offset)
> @@ -508,12 +525,16 @@ static inline int inode_was_rl(struct ino_tree_node *irec, int offset)
>   */
>  static inline void set_inode_is_rl(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_is_rl |= IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline void clear_inode_is_rl(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_is_rl &= ~IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline int inode_is_rl(struct ino_tree_node *irec, int offset)
> @@ -546,7 +567,9 @@ static inline int is_inode_reached(struct ino_tree_node *irec, int offset)
>  static inline void add_inode_reached(struct ino_tree_node *irec, int offset)
>  {
>  	add_inode_ref(irec, offset);
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_un.ex_data->ino_reached |= IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  /*
> diff --git a/repair/incore_ino.c b/repair/incore_ino.c
> index 82956ae93005..299e4f949e5e 100644
> --- a/repair/incore_ino.c
> +++ b/repair/incore_ino.c
> @@ -91,6 +91,7 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
>  {
>  	ASSERT(irec->ino_un.ex_data != NULL);
>  
> +	pthread_mutex_lock(&irec->lock);
>  	switch (irec->nlink_size) {
>  	case sizeof(uint8_t):
>  		if (irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] < 0xff) {
> @@ -112,6 +113,7 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
>  	default:
>  		ASSERT(0);
>  	}
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
> @@ -120,6 +122,7 @@ void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
>  
>  	ASSERT(irec->ino_un.ex_data != NULL);
>  
> +	pthread_mutex_lock(&irec->lock);
>  	switch (irec->nlink_size) {
>  	case sizeof(uint8_t):
>  		ASSERT(irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] > 0);
> @@ -139,6 +142,7 @@ void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
>  
>  	if (refs == 0)
>  		irec->ino_un.ex_data->ino_reached &= ~IREC_MASK(ino_offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
> @@ -161,6 +165,7 @@ uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
>  void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
>  		uint32_t nlinks)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	switch (irec->nlink_size) {
>  	case sizeof(uint8_t):
>  		if (nlinks < 0xff) {
> @@ -182,6 +187,7 @@ void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
>  	default:
>  		ASSERT(0);
>  	}
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
> @@ -253,6 +259,7 @@ alloc_ino_node(
>  	irec->nlink_size = sizeof(uint8_t);
>  	irec->disk_nlinks.un8 = alloc_nlink_array(irec->nlink_size);
>  	irec->ftypes = alloc_ftypes_array(mp);
> +	pthread_mutex_init(&irec->lock, NULL);
>  	return irec;
>  }
>  
> @@ -294,6 +301,7 @@ free_ino_tree_node(
>  	}
>  
>  	free(irec->ftypes);
> +	pthread_mutex_destroy(&irec->lock);
>  	free(irec);
>  }
>  
> @@ -600,6 +608,7 @@ set_inode_parent(
>  	uint64_t		bitmask;
>  	parent_entry_t		*tmp;
>  
> +	pthread_mutex_lock(&irec->lock);
>  	if (full_ino_ex_data)
>  		ptbl = irec->ino_un.ex_data->parents;
>  	else
> @@ -625,6 +634,7 @@ set_inode_parent(
>  #endif
>  		ptbl->pentries[0] = parent;
>  
> +		pthread_mutex_unlock(&irec->lock);
>  		return;
>  	}
>  
> @@ -642,6 +652,7 @@ set_inode_parent(
>  #endif
>  		ptbl->pentries[target] = parent;
>  
> +		pthread_mutex_unlock(&irec->lock);
>  		return;
>  	}
>  
> @@ -682,6 +693,7 @@ set_inode_parent(
>  #endif
>  	ptbl->pentries[target] = parent;
>  	ptbl->pmask |= (1ULL << offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  xfs_ino_t
> @@ -692,6 +704,7 @@ get_inode_parent(ino_tree_node_t *irec, int offset)
>  	int		i;
>  	int		target;
>  
> +	pthread_mutex_lock(&irec->lock);
>  	if (full_ino_ex_data)
>  		ptbl = irec->ino_un.ex_data->parents;
>  	else
> @@ -709,9 +722,11 @@ get_inode_parent(ino_tree_node_t *irec, int offset)
>  #ifdef DEBUG
>  		ASSERT(target < ptbl->cnt);
>  #endif
> +		pthread_mutex_unlock(&irec->lock);
>  		return(ptbl->pentries[target]);
>  	}
>  
> +	pthread_mutex_unlock(&irec->lock);
>  	return(0LL);
>  }
>  
> -- 
> 2.28.0
> 
