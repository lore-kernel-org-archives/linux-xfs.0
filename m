Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B239C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D6361953
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhCSSMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 14:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230379AbhCSSLj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 14:11:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DECD361953;
        Fri, 19 Mar 2021 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616177499;
        bh=E0b0RQfahtol5eLh4wIMF0sZ3T144F8dKpEvd8+cWso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hKoSujUM88gB6zngSDtqXVZil6SMV7hmwv+4ZOO1+pu13sQitQ9kdq3tRWeIApfDN
         vMqg6jKYE1wRx2e9IwQc+dVYJiKYQ9UF6IKDF/lgrRPyOH1WgNl5j1mIil9rJInq0L
         vV7LubRJoZmYQHaeQ9I0/VwPMmtHD4MPE8hCNP5Ran5SF5UZWnufY5cselehU6Rg42
         mE4IF6FyD+8K5ymNUKju6BBT/Df56xu2CtzLFlgpBpNUXSRQNuhHtcN5oMMqvDyYf5
         KvX46/CteiZ1V9nmqQI+nE9mZ8gPVl78USp0AmHDoUpCDM/qH861jJCqOY7rGg07eC
         AI79w+rT2xVFA==
Date:   Fri, 19 Mar 2021 11:11:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@redhat.com
Subject: Re: [PATCH 3/7] repair: protect inode chunk tree records with a mutex
Message-ID: <20210319181138.GS22100@magnolia>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013355.776008-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319013355.776008-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:33:51PM +1100, Dave Chinner wrote:
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
> The inode chunk tree itself is not modified in the directory
> scanning and rebuilding part of phase 6 which we are making
> concurrent, hence we do not need to worry about locking for AVL tree
> lookups to find the inode chunk records themselves. Therefore
> internal locking is all we need here.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Hmm, didn't I review this last time? ;)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/incore.h     | 23 +++++++++++++++++++++++
>  repair/incore_ino.c | 15 +++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/repair/incore.h b/repair/incore.h
> index 977e5dd04336..d64315fd2585 100644
> --- a/repair/incore.h
> +++ b/repair/incore.h
> @@ -281,6 +281,7 @@ typedef struct ino_tree_node  {
>  		parent_list_t	*plist;		/* phases 2-5 */
>  	} ino_un;
>  	uint8_t			*ftypes;	/* phases 3,6 */
> +	pthread_mutex_t		lock;
>  } ino_tree_node_t;
>  
>  #define INOS_PER_IREC	(sizeof(uint64_t) * NBBY)
> @@ -411,7 +412,9 @@ next_free_ino_rec(ino_tree_node_t *ino_rec)
>   */
>  static inline void add_inode_refchecked(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ino_un.ex_data->ino_processed |= IREC_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline int is_inode_refchecked(struct ino_tree_node *irec, int offset)
> @@ -437,12 +440,16 @@ static inline int is_inode_confirmed(struct ino_tree_node *irec, int offset)
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
> @@ -455,15 +462,19 @@ static inline int inode_isadir(struct ino_tree_node *irec, int offset)
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
> @@ -476,7 +487,9 @@ static inline int is_inode_free(struct ino_tree_node *irec, int offset)
>   */
>  static inline void set_inode_sparse(struct ino_tree_node *irec, int offset)
>  {
> +	pthread_mutex_lock(&irec->lock);
>  	irec->ir_sparse |= XFS_INOBT_MASK(offset);
> +	pthread_mutex_unlock(&irec->lock);
>  }
>  
>  static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
> @@ -489,12 +502,16 @@ static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
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
> @@ -507,12 +524,16 @@ static inline int inode_was_rl(struct ino_tree_node *irec, int offset)
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
> @@ -545,7 +566,9 @@ static inline int is_inode_reached(struct ino_tree_node *irec, int offset)
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
> 2.30.1
> 
