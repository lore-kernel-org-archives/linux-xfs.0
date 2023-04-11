Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFAEC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjDKX5K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKX5I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:57:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F11272B
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:57:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e18-20020a17090ac21200b00246952d917fso8223105pjt.4
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681257427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tKgAR69M+UoVeOOH6Jj+2t028ivjhEiYQWepBqZfQzg=;
        b=R9FOKloaqkcallcrhiKI2QKXKM4anXoliWjEQKUZkIrRr+b0UIRFJ6gzNwWXeyoSyV
         QnU1uoNlFCRb/RWdJKcMEPchJO+QqNLxnx3bJtuOn3OdYl5hFIQo6jCWLfxSybMV/GYO
         rZrHUvcNiQ9QyUvkg7EEcabdaR1VNgvyR4Hqx/g3l03+OnXpVvxRA45VPiO8oVN6fJqZ
         bZkPpyQKMtSnHMZjsMC4AIZGDzSF63QM6ybVDYepxF6TTH/SY4E+dw2/PyJpKK9IQPul
         /zN4nAg4W3IPz47pPR9Q6ctVtQcdlbP2+7Jy5OXTsAnbdrIfpCWKiNDe7eMnklvKAEWA
         x5cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681257427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKgAR69M+UoVeOOH6Jj+2t028ivjhEiYQWepBqZfQzg=;
        b=NdKMCWckTxWWOtrsKSuXqt6Zbopz7esqATCA/sVdX7c6kFaXfnlD3l1RiotP1OYeoO
         Ck5Gj33Wf+JNLlz4zPtD01U0iJuwabXoyD862nOHpt3cQP4Cpf/HTU4jE3XMLbnRlYl+
         HN6e8wPuhLLDmQL5aZqg/elWehwykYC1NBcJhogwcJ/dx5qM/CDD26E+kG4OLpwZ20Vs
         FKxty7OiecVXG3vfDiY9jU2bX2pxDQrLU/Ui00aTrwp/KxSnmA/Hw86LFv0+unlXrcXg
         YNhPQuBt7LDfah0pHrHT2i4QuQtpWJnM9dUREFQ6JsOlQ99lmpHteq6o5K54EbXpGOjc
         aS0g==
X-Gm-Message-State: AAQBX9c+y0nuyvhNTuw7lb0MT1J9DDnjiRzL8tV3xn4mGHzilxbN3oes
        p5edsdBsGt2hdE5hxYHzJJ7Sbw==
X-Google-Smtp-Source: AKy350bai4Tu3/CKlY0iWUhw91Rgyswu4q7xhf09qWOKk6Qz56wJeBHgBWqz2KfCf991+0g//+qXIA==
X-Received: by 2002:a17:903:1c3:b0:1a5:167e:f482 with SMTP id e3-20020a17090301c300b001a5167ef482mr19492964plh.20.1681257427051;
        Tue, 11 Apr 2023 16:57:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id 3-20020a170902c20300b001a647709864sm3838965pll.155.2023.04.11.16.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:57:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmNrD-002HqU-Gd; Wed, 12 Apr 2023 09:57:03 +1000
Date:   Wed, 12 Apr 2023 09:57:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsprogs: _{attr,data}_map_shared should take
 ILOCK_EXCL until iread_extents is completely done
Message-ID: <20230411235703.GE3223426@dread.disaster.area>
References: <20230411184934.GK360889@frogsfrogsfrogs>
 <20230411225338.GL360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411225338.GL360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 03:53:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While fuzzing the data fork extent count on a btree-format directory
> with xfs/375, I observed the following (excerpted) splat:
> 
> XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> Call Trace:
>  <TASK>
>  xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  __x64_sys_ioctl+0x82/0xa0
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> The cause of this is a race condition in xfs_ilock_data_map_shared,
> which performs an unlocked access to the data fork to guess which lock
> mode it needs:
> 
> Thread 0                          Thread 1
> 
> xfs_need_iread_extents
> <observe no iext tree>
> xfs_ilock(..., ILOCK_EXCL)
> xfs_iread_extents
> <observe no iext tree>
> <check ILOCK_EXCL>
> <load bmbt extents into iext>
> <notice iext size doesn't
>  match nextents>
>                                   xfs_need_iread_extents
>                                   <observe iext tree>
>                                   xfs_ilock(..., ILOCK_SHARED)
> <tear down iext tree>
> xfs_iunlock(..., ILOCK_EXCL)
>                                   xfs_iread_extents
>                                   <observe no iext tree>
>                                   <check ILOCK_EXCL>
>                                   *BOOM*
> 
> Fix this race by adding a flag to the xfs_ifork structure to indicate
> that we have not yet read in the extent records and changing the
> predicate to look at the flag state, not if_height.  The memory barrier
> ensures that the flag will not be set until the very end of the
> function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> Here's the userspace version, which steals heavily from the kernel but
> otherwise uses liburcu underneath.
> ---
>  include/atomic.h        |  100 +++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_priv.h    |    3 -
>  libxfs/xfs_bmap.c       |    6 +++
>  libxfs/xfs_inode_fork.c |   16 +++++++-
>  libxfs/xfs_inode_fork.h |    6 ++-
>  5 files changed, 125 insertions(+), 6 deletions(-)
> 
> diff --git a/include/atomic.h b/include/atomic.h
> index 9c4aa5849ae..98889190bb0 100644
> --- a/include/atomic.h
> +++ b/include/atomic.h
> @@ -118,4 +118,104 @@ atomic64_set(atomic64_t *a, int64_t v)
>  
>  #endif /* HAVE_URCU_ATOMIC64 */
>  
> +#define __smp_mb()		cmm_smp_mb()
> +
> +/* from compiler_types.h */
> +/*
> + * __unqual_scalar_typeof(x) - Declare an unqualified scalar type, leaving
> + *			       non-scalar types unchanged.
> + */
> +/*
> + * Prefer C11 _Generic for better compile-times and simpler code. Note: 'char'
> + * is not type-compatible with 'signed char', and we define a separate case.
> + */
> +#define __scalar_type_to_expr_cases(type)				\
> +		unsigned type:	(unsigned type)0,			\
> +		signed type:	(signed type)0
> +
> +#define __unqual_scalar_typeof(x) typeof(				\
> +		_Generic((x),						\
> +			 char:	(char)0,				\
> +			 __scalar_type_to_expr_cases(char),		\
> +			 __scalar_type_to_expr_cases(short),		\
> +			 __scalar_type_to_expr_cases(int),		\
> +			 __scalar_type_to_expr_cases(long),		\
> +			 __scalar_type_to_expr_cases(long long),	\
> +			 default: (x)))
> +
> +/* Is this type a native word size -- useful for atomic operations */
> +#define __native_word(t) \
> +	(sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
> +	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
> +
> +#define compiletime_assert(foo, str)	BUILD_BUG_ON(!(foo))
> +
> +#define compiletime_assert_atomic_type(t)				\
> +	compiletime_assert(__native_word(t),				\
> +		"Need native word sized stores/loads for atomicity.")
> +
> +/* from barrier.h */
> +#ifndef __smp_store_release
> +#define __smp_store_release(p, v)					\
> +do {									\
> +	compiletime_assert_atomic_type(*p);				\
> +	__smp_mb();							\
> +	WRITE_ONCE(*p, v);						\
> +} while (0)
> +#endif
> +
> +#ifndef __smp_load_acquire
> +#define __smp_load_acquire(p)						\
> +({									\
> +	__unqual_scalar_typeof(*p) ___p1 = READ_ONCE(*p);		\
> +	compiletime_assert_atomic_type(*p);				\
> +	__smp_mb();							\
> +	(typeof(*p))___p1;						\
> +})
> +#endif
> +
> +#ifndef smp_store_release
> +#define smp_store_release(p, v) __smp_store_release((p), (v))
> +#endif
> +
> +#ifndef smp_load_acquire
> +#define smp_load_acquire(p) __smp_load_acquire(p)
> +#endif
> +
> +/* from rwonce.h */
> +/*
> + * Yes, this permits 64-bit accesses on 32-bit architectures. These will
> + * actually be atomic in some cases (namely Armv7 + LPAE), but for others we
> + * rely on the access being split into 2x32-bit accesses for a 32-bit quantity
> + * (e.g. a virtual address) and a strong prevailing wind.
> + */
> +#define compiletime_assert_rwonce_type(t)					\
> +	compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),	\
> +		"Unsupported access size for {READ,WRITE}_ONCE().")
> +
> +/*
> + * Use __READ_ONCE() instead of READ_ONCE() if you do not require any
> + * atomicity. Note that this may result in tears!
> + */
> +#ifndef __READ_ONCE
> +#define __READ_ONCE(x)	(*(const volatile __unqual_scalar_typeof(x) *)&(x))
> +#endif
> +
> +#define READ_ONCE(x)							\
> +({									\
> +	compiletime_assert_rwonce_type(x);				\
> +	__READ_ONCE(x);							\
> +})
> +
> +#define __WRITE_ONCE(x, val)						\
> +do {									\
> +	*(volatile typeof(x) *)&(x) = (val);				\
> +} while (0)
> +
> +#define WRITE_ONCE(x, val)						\
> +do {									\
> +	compiletime_assert_rwonce_type(x);				\
> +	__WRITE_ONCE(x, val);						\
> +} while (0)
> +
>  #endif /* __ATOMIC_H__ */

I'd put READ/WRITE_ONCE above the barrier stuff as
__smp_store_release/__smp_load_acquire use it, but other than that
it looks OK.

> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index e5f37df28c0..5fdfeeea060 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -222,9 +222,6 @@ static inline bool WARN_ON(bool expr) {
>  #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
>  #define percpu_counter_sum(x)		(*x)
>  
> -#define READ_ONCE(x)			(x)
> -#define WRITE_ONCE(x, val)		((x) = (val))

Yay! One less nasty hack for the userspace wrappers.

Overall looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
