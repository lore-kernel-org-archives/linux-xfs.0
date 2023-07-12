Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BB6EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 05:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjGLFhm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 01:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjGLFhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 01:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAC11712;
        Tue, 11 Jul 2023 22:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C06616DA;
        Wed, 12 Jul 2023 05:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6121C433C8;
        Wed, 12 Jul 2023 05:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689140258;
        bh=KGtje1pyWXRDWdO+qAczfdmye9VPR0fGEXAemVoRtU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnEmwzJecU/uprrumV60UroADRl9PFQRRM2B7SYadMb3f3Lkj5Y2wOMpP5CzValsp
         dJ9XV/ihfga3NJacetnwl6C4kpPmbD8cvTckVdBTFqXoHWHbem7Zd+upgz+JC5yznW
         pVeRvlSlNoA7s1B61YSNmkMc1wDuhJ1yAj+tl2SKiyNhAfdNvB5YNjJn/r0sBZwIZ7
         qgDLpm9xvt82/N4RoP434wdse+1Fq/xIIWfy+KOWxtHiQK5oUH4cykPtSPVAPnqAH9
         7KYUR5323plyOwb9BA7dlunokTRyYL/9hTvHdswj+4orq0QH4NhXjJjp4I+CmII8Xy
         4wqbwjlswQ/1g==
Date:   Tue, 11 Jul 2023 22:37:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] libxfs: Redefine 1-element arrays as flexible arrays
Message-ID: <20230712053738.GD108251@frogsfrogsfrogs>
References: <20230711222025.never.220-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711222025.never.220-kees@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 03:20:28PM -0700, Kees Cook wrote:
> To allow for code bases that include libxfs (e.g. the Linux kernel) and
> build with strict flexible array handling (-fstrict-flex-arrays=3),
> FORTIFY_SOURCE, and/or UBSAN bounds checking, redefine the remaining
> 1-element trailing arrays as true flexible arrays, but without changing
> their structure sizes. This is done via a union to retain a single element
> (named "legacy_padding"). As not all distro headers may yet have the
> UAPI stddef.h __DECLARE_FLEX_ARRAY macro, include it explicitly in
> platform_defs.h.in.
> 
> Addresses the warnings being seen under Linux:
> https://lore.kernel.org/all/20230710170243.GF11456@frogsfrogsfrogs
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/platform_defs.h.in | 18 ++++++++++++++++++
>  libxfs/xfs_da_format.h     | 38 ++++++++++++++++++++++++++++----------
>  libxfs/xfs_fs.h            | 12 ++++++++++--
>  3 files changed, 56 insertions(+), 12 deletions(-)
> 
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> index 315ad77cfb78..a55965ce050d 100644
> --- a/include/platform_defs.h.in
> +++ b/include/platform_defs.h.in
> @@ -134,6 +134,24 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
>  #    define fallthrough                    do {} while (0)  /* fallthrough */
>  #endif
>  
> +#ifndef __DECLARE_FLEX_ARRAY
> +/**
> + * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
> + *
> + * @type: The type of each flexible array element
> + * @name: The name of the flexible array member
> + *
> + * In order to have a flexible array member in a union or alone in a
> + * struct, it needs to be wrapped in an anonymous struct with at least 1
> + * named member, but that member can be empty.
> + */
> +#define __DECLARE_FLEX_ARRAY(type, name)	\
> +	struct { \
> +		struct { } __empty_ ## name; \
> +		type name[]; \
> +	}
> +#endif

Hmm.  This is tempting, since the struct sizes stay the same, which
avoids all the potential sizeof breakage problems and whatnot.  I think
the downside of doing it this way is that xfs_fs.h ships in xfslibs-dev
but platform_defs.h does not, which means that random user programs can
pick up a *user* of __DECLARE_FLEX_ARRAY from /usr/include/xfs/xfs_fs.h.

I guess this could be a problem for anyone who might (a) compile against
xfs_fs.h from a newer xfslibs-dev package on a system with (b) old
kernel headers that don't define __DECLARE_FLEX_ARRAY.

More on this at the bottom.

> +
>  /* Only needed for the kernel. */
>  #define __init
>  
> diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
> index 25e2841084e1..4af92f16d5cd 100644
> --- a/libxfs/xfs_da_format.h
> +++ b/libxfs/xfs_da_format.h
> @@ -580,18 +580,23 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
>  /*
>   * Entries are packed toward the top as tight as possible.
>   */
> +struct xfs_attr_sf_entry {
> +	uint8_t namelen;	/* actual length of name (no NULL) */
> +	uint8_t valuelen;	/* actual length of value (no NULL) */
> +	uint8_t flags;		/* flags bits (see xfs_attr_leaf.h) */
> +	uint8_t nameval[];	/* name & value bytes concatenated */
> +};

(Yeah, these ought to be broken out...)

> +
>  struct xfs_attr_shortform {
>  	struct xfs_attr_sf_hdr {	/* constant-structure header block */
>  		__be16	totsize;	/* total bytes in shortform list */
>  		__u8	count;	/* count of active entries */
>  		__u8	padding;
>  	} hdr;
> -	struct xfs_attr_sf_entry {
> -		uint8_t namelen;	/* actual length of name (no NULL) */
> -		uint8_t valuelen;	/* actual length of value (no NULL) */
> -		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> -		uint8_t nameval[];	/* name & value bytes concatenated */
> -	} list[1];			/* variable sized array */
> +	union {
> +		struct xfs_attr_sf_entry legacy_padding;
> +		__DECLARE_FLEX_ARRAY(struct xfs_attr_sf_entry, list);
> +	};
>  };
>  
>  typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
> @@ -620,19 +625,29 @@ typedef struct xfs_attr_leaf_entry {	/* sorted on key, not name */
>  typedef struct xfs_attr_leaf_name_local {
>  	__be16	valuelen;		/* number of bytes in value */
>  	__u8	namelen;		/* length of name bytes */
> -	__u8	nameval[1];		/* name/value bytes */
> +	union {
> +		__u8	legacy_padding;
> +		__DECLARE_FLEX_ARRAY(__u8, nameval);	/* name/value bytes */
> +	};
>  } xfs_attr_leaf_name_local_t;
>  
>  typedef struct xfs_attr_leaf_name_remote {
>  	__be32	valueblk;		/* block number of value bytes */
>  	__be32	valuelen;		/* number of bytes in value */
>  	__u8	namelen;		/* length of name bytes */
> -	__u8	name[1];		/* name bytes */
> +	union {
> +		__u8	legacy_padding;
> +		__DECLARE_FLEX_ARRAY(__u8, name);	/* name bytes */
> +	};
>  } xfs_attr_leaf_name_remote_t;
>  
>  typedef struct xfs_attr_leafblock {
>  	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
> -	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
> +	union {
> +		xfs_attr_leaf_entry_t	legacy_padding;
> +		/* sorted on key, not name */
> +		__DECLARE_FLEX_ARRAY(xfs_attr_leaf_entry_t, entries);
> +	};
>  	/*
>  	 * The rest of the block contains the following structures after the
>  	 * leaf entries, growing from the bottom up. The variables are never
> @@ -664,7 +679,10 @@ struct xfs_attr3_leaf_hdr {
>  
>  struct xfs_attr3_leafblock {
>  	struct xfs_attr3_leaf_hdr	hdr;
> -	struct xfs_attr_leaf_entry	entries[1];
> +	union {
> +		struct xfs_attr_leaf_entry	legacy_padding;
> +		__DECLARE_FLEX_ARRAY(struct xfs_attr_leaf_entry, entries);
> +	};
>  
>  	/*
>  	 * The rest of the block contains the following structures after the
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 1cfd5bc6520a..d6ec66ef0194 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -590,12 +590,20 @@ typedef struct xfs_attrlist_cursor {
>  struct xfs_attrlist {
>  	__s32	al_count;	/* number of entries in attrlist */
>  	__s32	al_more;	/* T/F: more attrs (do call again) */
> -	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
> +	union {
> +		__s32	legacy_padding;
> +		/* byte offsets of attrs [var-sized] */
> +		__DECLARE_FLEX_ARRAY(__s32, al_offset);
> +	};
>  };
>  
>  struct xfs_attrlist_ent {	/* data from attr_list() */
>  	__u32	a_valuelen;	/* number bytes in value of attr */
> -	char	a_name[1];	/* attr name (NULL terminated) */
> +	union {
> +		char	legacy_padding;
> +		/* attr name (NULL terminated) */
> +		__DECLARE_FLEX_ARRAY(char, a_name);
> +	};
>  };
>  
>  typedef struct xfs_fsop_attrlist_handlereq {
> -- 
> 2.34.1

Here's my version, where I go for a straight a[1] -> a[] conversion and
let downstream attrlist ioctl users eat their lumps.  What do you think
of the excess-documentation approach?

--D

diff --git a/db/metadump.c b/db/metadump.c
index d9a616a9..3545124f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1475,7 +1475,7 @@ process_attr_block(
 			nlen = local->namelen;
 			vlen = be16_to_cpu(local->valuelen);
 			zlen = xfs_attr_leaf_entsize_local(nlen, vlen) -
-				(sizeof(xfs_attr_leaf_name_local_t) - 1 +
+				(offsetof(struct xfs_attr_leaf_name_local, nameval) +
 				 nlen + vlen);
 			if (zero_stale_data)
 				memset(&local->nameval[nlen + vlen], 0, zlen);
@@ -1497,7 +1497,7 @@ process_attr_block(
 			/* zero from end of name[] to next name start */
 			nlen = remote->namelen;
 			zlen = xfs_attr_leaf_entsize_remote(nlen) -
-				(sizeof(xfs_attr_leaf_name_remote_t) - 1 +
+				(offsetof(struct xfs_attr_leaf_name_remote, name) +
 				 nlen);
 			if (zero_stale_data)
 				memset(&remote->name[nlen], 0, zlen);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 25e28410..17a6d8be 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -586,12 +586,14 @@ struct xfs_attr_shortform {
 		__u8	count;	/* count of active entries */
 		__u8	padding;
 	} hdr;
+
+	/* In Linux 6.5 this flex array was changed from list[1] to list[]. */
 	struct xfs_attr_sf_entry {
 		uint8_t namelen;	/* actual length of name (no NULL) */
 		uint8_t valuelen;	/* actual length of value (no NULL) */
 		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
 		uint8_t nameval[];	/* name & value bytes concatenated */
-	} list[1];			/* variable sized array */
+	} list[];			/* variable sized array */
 };
 
 typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
@@ -620,19 +622,29 @@ typedef struct xfs_attr_leaf_entry {	/* sorted on key, not name */
 typedef struct xfs_attr_leaf_name_local {
 	__be16	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	nameval[1];		/* name/value bytes */
+	/*
+	 * In Linux 6.5 this flex array was converted from nameval[1] to
+	 * nameval[].  Be very careful here about extra padding at the end;
+	 * see xfs_attr_leaf_entsize_local() for details.
+	 */
+	__u8	nameval[];		/* name/value bytes */
 } xfs_attr_leaf_name_local_t;
 
 typedef struct xfs_attr_leaf_name_remote {
 	__be32	valueblk;		/* block number of value bytes */
 	__be32	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	name[1];		/* name bytes */
+	/*
+	 * In Linux 6.5 this flex array was converted from name[1] to name[].
+	 * Be very careful here about extra padding at the end; see
+	 * xfs_attr_leaf_entsize_remote() for details.
+	 */
+	__u8	name[];			/* name bytes */
 } xfs_attr_leaf_name_remote_t;
 
 typedef struct xfs_attr_leafblock {
 	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
-	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
+	xfs_attr_leaf_entry_t	entries[];	/* sorted on key, not name */
 	/*
 	 * The rest of the block contains the following structures after the
 	 * leaf entries, growing from the bottom up. The variables are never
@@ -641,6 +653,9 @@ typedef struct xfs_attr_leafblock {
 	 *
 	 * xfs_attr_leaf_name_local_t namelist;
 	 * xfs_attr_leaf_name_remote_t valuelist;
+	 *
+	 * In Linux 6.5 this flex array was converted from entries[1] to
+	 * entries[].
 	 */
 } xfs_attr_leafblock_t;
 
@@ -664,7 +679,7 @@ struct xfs_attr3_leaf_hdr {
 
 struct xfs_attr3_leafblock {
 	struct xfs_attr3_leaf_hdr	hdr;
-	struct xfs_attr_leaf_entry	entries[1];
+	struct xfs_attr_leaf_entry	entries[];
 
 	/*
 	 * The rest of the block contains the following structures after the
@@ -673,6 +688,9 @@ struct xfs_attr3_leafblock {
 	 *
 	 * struct xfs_attr_leaf_name_local
 	 * struct xfs_attr_leaf_name_remote
+	 *
+	 * In Linux 6.5 this flex array was converted from entries[1] to
+	 * entries[].
 	 */
 };
 
@@ -747,14 +765,61 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 +
-			nlen, XFS_ATTR_LEAF_NAME_ALIGN);
+	/*
+	 * Prior to Linux 6.5, struct xfs_attr_leaf_name_remote ended with
+	 * name[1], which was used as a flexarray.  The layout of this struct
+	 * is 9 bytes of fixed-length fields followed by a __u8 flex array at
+	 * offset 9.
+	 *
+	 * On most architectures, struct xfs_attr_leaf_name_remote had two
+	 * bytes of implicit padding at the end of the struct to make the
+	 * struct length 12.  After converting name[1] to name[], there are
+	 * three implicit padding bytes and the struct size remains 12.
+	 * However, there are compiler configurations that do not add implicit
+	 * padding at all (m68k) and have been broken for years.
+	 *
+	 * This entsize computation historically added (the xattr name length)
+	 * to (the padded struct length - 1) and rounded that sum up to the
+	 * nearest multiple of 4 (NAME_ALIGN).  IOWs, round_up(11 + nlen, 4).
+	 * This is encoded in the ondisk format, so we cannot change this.
+	 *
+	 * Compute the entsize from offsetof of the flexarray and manually
+	 * adding bytes for the implicit padding.
+	 */
+	const size_t remotesize =
+			offsetof(struct xfs_attr_leaf_name_remote, name) + 2;
+
+	return round_up(remotesize + nlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
-	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 +
-			nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
+	/*
+	 * Prior to Linux 6.5, struct xfs_attr_leaf_name_local ended with
+	 * nameval[1], which was used as a flexarray.  The layout of this
+	 * struct is 3 bytes of fixed-length fields followed by a __u8 flex
+	 * array at offset 3.
+	 *
+	 * struct xfs_attr_leaf_name_local had zero bytes of implicit padding
+	 * at the end of the struct to make the struct length 4.  On most
+	 * architectures, after converting nameval[1] to nameval[], there is
+	 * one implicit padding byte and the struct size remains 4.  However,
+	 * there are compiler configurations that do not add implicit padding
+	 * at all (m68k) and would break.
+	 *
+	 * This entsize computation historically added (the xattr name and
+	 * value length) to (the padded struct length - 1) and rounded that sum
+	 * up to the nearest multiple of 4 (NAME_ALIGN).  IOWs, the formula is
+	 * round_up(3 + nlen + vlen, 4).  This is encoded in the ondisk format,
+	 * so we cannot change this.
+	 *
+	 * Compute the entsize from offsetof of the flexarray and manually
+	 * adding bytes for the implicit padding.
+	 */
+	const size_t localsize =
+			offsetof(struct xfs_attr_leaf_name_local, nameval);
+
+	return round_up(localsize + nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 9c60ebb3..8927ecb2 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -588,16 +588,19 @@ typedef struct xfs_attrlist_cursor {
  *
  * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
  * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
+ *
+ * WARNING: In Linux 6.5, al_offset and a_name were changed from array[1] to
+ * array[].  Anyone using sizeof is (already) broken!
  */
 struct xfs_attrlist {
 	__s32	al_count;	/* number of entries in attrlist */
 	__s32	al_more;	/* T/F: more attrs (do call again) */
-	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
+	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
 };
 
 struct xfs_attrlist_ent {	/* data from attr_list() */
 	__u32	a_valuelen;	/* number bytes in value of attr */
-	char	a_name[1];	/* attr name (NULL terminated) */
+	char	a_name[];	/* attr name (NULL terminated) */
 };
 
 typedef struct xfs_fsop_attrlist_handlereq {
