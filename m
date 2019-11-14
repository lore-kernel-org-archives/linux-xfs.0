Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A77CC43141
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 21:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10EB620725
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 21:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ofEFwH9i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNVAI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 16:00:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51080 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKNVAI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 16:00:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEKxLXU010482;
        Thu, 14 Nov 2019 21:00:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pxlSPC+FhdD2lEhdjmBNDsCHchPH1o5ijEOXzYocvw8=;
 b=ofEFwH9icxU5/VOXu4bOGFXHFkUgOuFGociPWwC1MP+auSQHUNw1m3E4Z+Suf/f8KKOy
 VX2DBy8XIiZoT+vMy/JFb62xnD2oKTQap7mDaV1y26qSdOx3HzyBX2C1Tz8JfdgaRPRS
 EOUQGjchehInTQN6LNDpyAhtuV2Z9Fg2fqgWpRkMUDsB+1+VQ6+PkdfqqM3UyleyfBnh
 RemRHpv8eUNS60XxJuSHEfvaSnpDz5hj0HUTEbwD/W6wEl3NhzHa5+XKfQ1dKiLe0g44
 1ge1laTQvUGJDWB41ptLWEwfi+8WNlomCfRbZB87IQcyCTMi0DUCH4CXF8DEh4MC22wf RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3r5pbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 21:00:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEKsGVj001815;
        Thu, 14 Nov 2019 21:00:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w8g1a1r3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 21:00:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAEL01bZ010255;
        Thu, 14 Nov 2019 21:00:01 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 13:00:01 -0800
Date:   Thu, 14 Nov 2019 13:00:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191114210000.GL6219@magnolia>
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114200955.1365926-5-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 09:09:55PM +0100, Carlos Maiolino wrote:
> This can be replaced by direct calls to kfree() or kvfree() (whenever
> allocation is done via kmem_alloc_io() or kmem_alloc_large().
> 
> This patch has been partially scripted. I used the following sed to
> replace all kmem_free() calls by kfree()
> 
>  # find fs/xfs/ -type f -name '*.c' -o -name '*.h' | xargs sed -i \
>    's/kmem_free/kfree/g'

Coccinelle? ;)

> And manually inspected kmem_alloc_io() and kmem_alloc_large() uses to
> use kvfree() instead.

Why not just use kvfree everywhere?  Is there a significant performance
penalty for the is_vmalloc_addr() check in kvfree vs. having to keep
track of kfree vs. kvfree?

--D

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/kmem.h                  |  5 ----
>  fs/xfs/libxfs/xfs_attr.c       |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  8 +++---
>  fs/xfs/libxfs/xfs_da_btree.c   | 10 +++----
>  fs/xfs/libxfs/xfs_defer.c      |  4 +--
>  fs/xfs/libxfs/xfs_dir2.c       | 18 ++++++------
>  fs/xfs/libxfs/xfs_dir2_block.c |  4 +--
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  8 +++---
>  fs/xfs/libxfs/xfs_iext_tree.c  |  8 +++---
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 +++---
>  fs/xfs/libxfs/xfs_refcount.c   |  4 +--
>  fs/xfs/scrub/agheader.c        |  2 +-
>  fs/xfs/scrub/agheader_repair.c |  2 +-
>  fs/xfs/scrub/attr.c            |  2 +-
>  fs/xfs/scrub/bitmap.c          |  4 +--
>  fs/xfs/scrub/btree.c           |  2 +-
>  fs/xfs/scrub/refcount.c        |  8 +++---
>  fs/xfs/scrub/scrub.c           |  2 +-
>  fs/xfs/xfs_acl.c               |  4 +--
>  fs/xfs/xfs_attr_inactive.c     |  2 +-
>  fs/xfs/xfs_attr_list.c         |  4 +--
>  fs/xfs/xfs_bmap_item.c         |  4 +--
>  fs/xfs/xfs_buf.c               | 12 ++++----
>  fs/xfs/xfs_buf_item.c          |  4 +--
>  fs/xfs/xfs_dquot.c             |  2 +-
>  fs/xfs/xfs_dquot_item.c        |  8 +++---
>  fs/xfs/xfs_error.c             |  2 +-
>  fs/xfs/xfs_extent_busy.c       |  2 +-
>  fs/xfs/xfs_extfree_item.c      | 14 +++++-----
>  fs/xfs/xfs_filestream.c        |  4 +--
>  fs/xfs/xfs_inode.c             | 12 ++++----
>  fs/xfs/xfs_inode_item.c        |  2 +-
>  fs/xfs/xfs_ioctl.c             |  6 ++--
>  fs/xfs/xfs_ioctl32.c           |  2 +-
>  fs/xfs/xfs_iops.c              |  2 +-
>  fs/xfs/xfs_itable.c            |  4 +--
>  fs/xfs/xfs_iwalk.c             |  4 +--
>  fs/xfs/xfs_log.c               | 12 ++++----
>  fs/xfs/xfs_log_cil.c           | 16 +++++------
>  fs/xfs/xfs_log_recover.c       | 50 +++++++++++++++++-----------------
>  fs/xfs/xfs_mount.c             |  8 +++---
>  fs/xfs/xfs_mru_cache.c         |  8 +++---
>  fs/xfs/xfs_qm.c                |  6 ++--
>  fs/xfs/xfs_refcount_item.c     |  6 ++--
>  fs/xfs/xfs_rmap_item.c         |  6 ++--
>  fs/xfs/xfs_rtalloc.c           |  8 +++---
>  fs/xfs/xfs_super.c             |  2 +-
>  fs/xfs/xfs_trans_ail.c         |  4 +--
>  48 files changed, 158 insertions(+), 163 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 6143117770e9..ccdc72519339 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -56,11 +56,6 @@ extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
>  extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
> -static inline void  kmem_free(const void *ptr)
> -{
> -	kvfree(ptr);
> -}
> -
>  
>  static inline void *
>  kmem_zalloc(size_t size, xfs_km_flags_t flags)
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 510ca6974604..bc8ca09e71d0 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -174,7 +174,7 @@ xfs_attr_get(
>  	/* on error, we have to clean up allocated value buffers */
>  	if (error) {
>  		if (flags & ATTR_ALLOC) {
> -			kmem_free(args.value);
> +			kvfree(args.value);
>  			*value = NULL;
>  		}
>  		return error;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 85ec5945d29f..795b9b21b64d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -931,7 +931,7 @@ xfs_attr_shortform_to_leaf(
>  	error = 0;
>  	*leaf_bp = bp;
>  out:
> -	kmem_free(tmpbuffer);
> +	kfree(tmpbuffer);
>  	return error;
>  }
>  
> @@ -1131,7 +1131,7 @@ xfs_attr3_leaf_to_shortform(
>  	error = 0;
>  
>  out:
> -	kmem_free(tmpbuffer);
> +	kfree(tmpbuffer);
>  	return error;
>  }
>  
> @@ -1572,7 +1572,7 @@ xfs_attr3_leaf_compact(
>  	 */
>  	xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
>  
> -	kmem_free(tmpbuffer);
> +	kfree(tmpbuffer);
>  }
>  
>  /*
> @@ -2293,7 +2293,7 @@ xfs_attr3_leaf_unbalance(
>  		}
>  		memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
>  		savehdr = tmphdr; /* struct copy */
> -		kmem_free(tmp_leaf);
> +		kfree(tmp_leaf);
>  	}
>  
>  	xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index c5c0b73febae..7ae82d91f776 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2189,7 +2189,7 @@ xfs_da_grow_inode_int(
>  
>  out_free_map:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  	return error;
>  }
>  
> @@ -2639,7 +2639,7 @@ xfs_dabuf_map(
>  	error = xfs_buf_map_from_irec(mp, map, nmaps, irecs, nirecs);
>  out:
>  	if (irecs != &irec)
> -		kmem_free(irecs);
> +		kfree(irecs);
>  	return error;
>  }
>  
> @@ -2686,7 +2686,7 @@ xfs_da_get_buf(
>  
>  out_free:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  
>  	return error;
>  }
> @@ -2735,7 +2735,7 @@ xfs_da_read_buf(
>  	*bpp = bp;
>  out_free:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  
>  	return error;
>  }
> @@ -2772,7 +2772,7 @@ xfs_da_reada_buf(
>  
>  out_free:
>  	if (mapp != &map)
> -		kmem_free(mapp);
> +		kfree(mapp);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 22557527cfdb..27c3d150068a 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -341,7 +341,7 @@ xfs_defer_cancel_list(
>  			ops->cancel_item(pwi);
>  		}
>  		ASSERT(dfp->dfp_count == 0);
> -		kmem_free(dfp);
> +		kfree(dfp);
>  	}
>  }
>  
> @@ -433,7 +433,7 @@ xfs_defer_finish_noroll(
>  		} else {
>  			/* Done with the dfp, free it. */
>  			list_del(&dfp->dfp_list);
> -			kmem_free(dfp);
> +			kfree(dfp);
>  		}
>  
>  		if (ops->finish_cleanup)
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 624c05e77ab4..efd7cec65259 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -109,8 +109,8 @@ xfs_da_mount(
>  	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
>  				     KM_MAYFAIL);
>  	if (!mp->m_dir_geo || !mp->m_attr_geo) {
> -		kmem_free(mp->m_dir_geo);
> -		kmem_free(mp->m_attr_geo);
> +		kfree(mp->m_dir_geo);
> +		kfree(mp->m_attr_geo);
>  		return -ENOMEM;
>  	}
>  
> @@ -176,8 +176,8 @@ void
>  xfs_da_unmount(
>  	struct xfs_mount	*mp)
>  {
> -	kmem_free(mp->m_dir_geo);
> -	kmem_free(mp->m_attr_geo);
> +	kfree(mp->m_dir_geo);
> +	kfree(mp->m_attr_geo);
>  }
>  
>  /*
> @@ -242,7 +242,7 @@ xfs_dir_init(
>  	args->dp = dp;
>  	args->trans = tp;
>  	error = xfs_dir2_sf_create(args, pdp->i_ino);
> -	kmem_free(args);
> +	kfree(args);
>  	return error;
>  }
>  
> @@ -311,7 +311,7 @@ xfs_dir_createname(
>  		rval = xfs_dir2_node_addname(args);
>  
>  out_free:
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> @@ -417,7 +417,7 @@ xfs_dir_lookup(
>  	}
>  out_free:
>  	xfs_iunlock(dp, lock_mode);
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> @@ -475,7 +475,7 @@ xfs_dir_removename(
>  	else
>  		rval = xfs_dir2_node_removename(args);
>  out_free:
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> @@ -536,7 +536,7 @@ xfs_dir_replace(
>  	else
>  		rval = xfs_dir2_node_replace(args);
>  out_free:
> -	kmem_free(args);
> +	kfree(args);
>  	return rval;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 358151ddfa75..766f282b706a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1229,7 +1229,7 @@ xfs_dir2_sf_to_block(
>  			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  	}
>  	/* Done with the temporary buffer */
> -	kmem_free(sfp);
> +	kfree(sfp);
>  	/*
>  	 * Sort the leaf entries by hash value.
>  	 */
> @@ -1244,6 +1244,6 @@ xfs_dir2_sf_to_block(
>  	xfs_dir3_data_check(dp, bp);
>  	return 0;
>  out_free:
> -	kmem_free(sfp);
> +	kfree(sfp);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index db1a82972d9e..f4de4e7b10ef 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -350,7 +350,7 @@ xfs_dir2_block_to_sf(
>  	xfs_dir2_sf_check(args);
>  out:
>  	xfs_trans_log_inode(args->trans, dp, logflags);
> -	kmem_free(sfp);
> +	kfree(sfp);
>  	return error;
>  }
>  
> @@ -585,7 +585,7 @@ xfs_dir2_sf_addname_hard(
>  		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  		memcpy(sfep, oldsfep, old_isize - nbytes);
>  	}
> -	kmem_free(buf);
> +	kfree(buf);
>  	dp->i_d.di_size = new_isize;
>  	xfs_dir2_sf_check(args);
>  }
> @@ -1202,7 +1202,7 @@ xfs_dir2_sf_toino4(
>  	/*
>  	 * Clean up the inode.
>  	 */
> -	kmem_free(buf);
> +	kfree(buf);
>  	dp->i_d.di_size = newsize;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  }
> @@ -1275,7 +1275,7 @@ xfs_dir2_sf_toino8(
>  	/*
>  	 * Clean up the inode.
>  	 */
> -	kmem_free(buf);
> +	kfree(buf);
>  	dp->i_d.di_size = newsize;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  }
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index 52451809c478..a7ba30cd81da 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -734,7 +734,7 @@ xfs_iext_remove_node(
>  again:
>  	ASSERT(node->ptrs[pos]);
>  	ASSERT(node->ptrs[pos] == victim);
> -	kmem_free(victim);
> +	kfree(victim);
>  
>  	nr_entries = xfs_iext_node_nr_entries(node, pos) - 1;
>  	offset = node->keys[0];
> @@ -780,7 +780,7 @@ xfs_iext_remove_node(
>  		ASSERT(node == ifp->if_u1.if_root);
>  		ifp->if_u1.if_root = node->ptrs[0];
>  		ifp->if_height--;
> -		kmem_free(node);
> +		kfree(node);
>  	}
>  }
>  
> @@ -854,7 +854,7 @@ xfs_iext_free_last_leaf(
>  	struct xfs_ifork	*ifp)
>  {
>  	ifp->if_height--;
> -	kmem_free(ifp->if_u1.if_root);
> +	kfree(ifp->if_u1.if_root);
>  	ifp->if_u1.if_root = NULL;
>  }
>  
> @@ -1035,7 +1035,7 @@ xfs_iext_destroy_node(
>  		}
>  	}
>  
> -	kmem_free(node);
> +	kfree(node);
>  }
>  
>  void
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index ad2b9c313fd2..296677958212 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -445,7 +445,7 @@ xfs_iroot_realloc(
>  						     (int)new_size);
>  		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
>  	}
> -	kmem_free(ifp->if_broot);
> +	kfree(ifp->if_broot);
>  	ifp->if_broot = new_broot;
>  	ifp->if_broot_bytes = (int)new_size;
>  	if (ifp->if_broot)
> @@ -486,7 +486,7 @@ xfs_idata_realloc(
>  		return;
>  
>  	if (new_size == 0) {
> -		kmem_free(ifp->if_u1.if_data);
> +		kfree(ifp->if_u1.if_data);
>  		ifp->if_u1.if_data = NULL;
>  		ifp->if_bytes = 0;
>  		return;
> @@ -511,7 +511,7 @@ xfs_idestroy_fork(
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (ifp->if_broot != NULL) {
> -		kmem_free(ifp->if_broot);
> +		kfree(ifp->if_broot);
>  		ifp->if_broot = NULL;
>  	}
>  
> @@ -523,7 +523,7 @@ xfs_idestroy_fork(
>  	 */
>  	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
>  		if (ifp->if_u1.if_data != NULL) {
> -			kmem_free(ifp->if_u1.if_data);
> +			kfree(ifp->if_u1.if_data);
>  			ifp->if_u1.if_data = NULL;
>  		}
>  	} else if ((ifp->if_flags & XFS_IFEXTENTS) && ifp->if_height) {
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 78236bd6c64f..07894c53e753 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1684,7 +1684,7 @@ xfs_refcount_recover_cow_leftovers(
>  			goto out_free;
>  
>  		list_del(&rr->rr_list);
> -		kmem_free(rr);
> +		kfree(rr);
>  	}
>  
>  	return error;
> @@ -1694,7 +1694,7 @@ xfs_refcount_recover_cow_leftovers(
>  	/* Free the leftover list */
>  	list_for_each_entry_safe(rr, n, &debris, rr_list) {
>  		list_del(&rr->rr_list);
> -		kmem_free(rr);
> +		kfree(rr);
>  	}
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index ba0f747c82e8..6f7126f6d25c 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -753,7 +753,7 @@ xchk_agfl(
>  	}
>  
>  out_free:
> -	kmem_free(sai.entries);
> +	kfree(sai.entries);
>  out:
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 7a1a38b636a9..15fabf020d1b 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -624,7 +624,7 @@ xrep_agfl_init_header(
>  		if (br->len)
>  			break;
>  		list_del(&br->list);
> -		kmem_free(br);
> +		kfree(br);
>  	}
>  
>  	/* Write new AGFL to disk. */
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd444b80..7a2a240febc1 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -49,7 +49,7 @@ xchk_setup_xattr_buf(
>  	if (ab) {
>  		if (sz <= ab->sz)
>  			return 0;
> -		kmem_free(ab);
> +		kvfree(ab);
>  		sc->buf = NULL;
>  	}
>  
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index 18a684e18a69..cabde1c4c235 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -47,7 +47,7 @@ xfs_bitmap_destroy(
>  
>  	for_each_xfs_bitmap_extent(bmr, n, bitmap) {
>  		list_del(&bmr->list);
> -		kmem_free(bmr);
> +		kfree(bmr);
>  	}
>  }
>  
> @@ -174,7 +174,7 @@ xfs_bitmap_disunion(
>  			/* Total overlap, just delete ex. */
>  			lp = lp->next;
>  			list_del(&br->list);
> -			kmem_free(br);
> +			kfree(br);
>  			break;
>  		case 0:
>  			/*
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index f52a7b8256f9..bed40b605076 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -698,7 +698,7 @@ xchk_btree(
>  			error = xchk_btree_check_block_owner(&bs,
>  					co->level, co->daddr);
>  		list_del(&co->list);
> -		kmem_free(co);
> +		kfree(co);
>  	}
>  
>  	return error;
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 0cab11a5d390..985724e81ebf 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -215,7 +215,7 @@ xchk_refcountbt_process_rmap_fragments(
>  				continue;
>  			}
>  			list_del(&frag->list);
> -			kmem_free(frag);
> +			kfree(frag);
>  			nr++;
>  		}
>  
> @@ -257,11 +257,11 @@ xchk_refcountbt_process_rmap_fragments(
>  	/* Delete fragments and work list. */
>  	list_for_each_entry_safe(frag, n, &worklist, list) {
>  		list_del(&frag->list);
> -		kmem_free(frag);
> +		kfree(frag);
>  	}
>  	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
>  		list_del(&frag->list);
> -		kmem_free(frag);
> +		kfree(frag);
>  	}
>  }
>  
> @@ -308,7 +308,7 @@ xchk_refcountbt_xref_rmap(
>  out_free:
>  	list_for_each_entry_safe(frag, n, &refchk.fragments, list) {
>  		list_del(&frag->list);
> -		kmem_free(frag);
> +		kfree(frag);
>  	}
>  }
>  
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index f1775bb19313..7c63cdf13946 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -175,7 +175,7 @@ xchk_teardown(
>  		sc->flags &= ~XCHK_HAS_QUOTAOFFLOCK;
>  	}
>  	if (sc->buf) {
> -		kmem_free(sc->buf);
> +		kvfree(sc->buf);
>  		sc->buf = NULL;
>  	}
>  	return error;
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 91693fce34a8..81b2c989242e 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -157,7 +157,7 @@ xfs_get_acl(struct inode *inode, int type)
>  	} else  {
>  		acl = xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
>  					XFS_ACL_MAX_ENTRIES(ip->i_mount));
> -		kmem_free(xfs_acl);
> +		kvfree(xfs_acl);
>  	}
>  	return acl;
>  }
> @@ -199,7 +199,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		error = xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
>  				len, ATTR_ROOT);
>  
> -		kmem_free(xfs_acl);
> +		kvfree(xfs_acl);
>  	} else {
>  		/*
>  		 * A NULL ACL argument means we want to remove the ACL.
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index a78c501f6fb1..8351b3b611ac 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -181,7 +181,7 @@ xfs_attr3_leaf_inactive(
>  			error = tmp;	/* save only the 1st errno */
>  	}
>  
> -	kmem_free(list);
> +	kfree(list);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 0ec6606149a2..e1d1c4eb9e69 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -131,7 +131,7 @@ xfs_attr_shortform_list(
>  					     XFS_ERRLEVEL_LOW,
>  					     context->dp->i_mount, sfe,
>  					     sizeof(*sfe));
> -			kmem_free(sbuf);
> +			kfree(sbuf);
>  			return -EFSCORRUPTED;
>  		}
>  
> @@ -195,7 +195,7 @@ xfs_attr_shortform_list(
>  		cursor->offset++;
>  	}
>  out:
> -	kmem_free(sbuf);
> +	kfree(sbuf);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ee6f4229cebc..a89e10519f05 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -391,7 +391,7 @@ xfs_bmap_update_finish_item(
>  		bmap->bi_bmap.br_blockcount = count;
>  		return -EAGAIN;
>  	}
> -	kmem_free(bmap);
> +	kfree(bmap);
>  	return error;
>  }
>  
> @@ -411,7 +411,7 @@ xfs_bmap_update_cancel_item(
>  	struct xfs_bmap_intent		*bmap;
>  
>  	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
> -	kmem_free(bmap);
> +	kfree(bmap);
>  }
>  
>  const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a0229c368e78..80ef2fc8bb77 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -193,7 +193,7 @@ xfs_buf_free_maps(
>  	struct xfs_buf	*bp)
>  {
>  	if (bp->b_maps != &bp->__b_map) {
> -		kmem_free(bp->b_maps);
> +		kfree(bp->b_maps);
>  		bp->b_maps = NULL;
>  	}
>  }
> @@ -292,7 +292,7 @@ _xfs_buf_free_pages(
>  	xfs_buf_t	*bp)
>  {
>  	if (bp->b_pages != bp->b_page_array) {
> -		kmem_free(bp->b_pages);
> +		kfree(bp->b_pages);
>  		bp->b_pages = NULL;
>  	}
>  }
> @@ -325,7 +325,7 @@ xfs_buf_free(
>  			__free_page(page);
>  		}
>  	} else if (bp->b_flags & _XBF_KMEM)
> -		kmem_free(bp->b_addr);
> +		kvfree(bp->b_addr);
>  	_xfs_buf_free_pages(bp);
>  	xfs_buf_free_maps(bp);
>  	kmem_cache_free(xfs_buf_zone, bp);
> @@ -373,7 +373,7 @@ xfs_buf_allocate_memory(
>  		if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
>  		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
>  			/* b_addr spans two pages - use alloc_page instead */
> -			kmem_free(bp->b_addr);
> +			kvfree(bp->b_addr);
>  			bp->b_addr = NULL;
>  			goto use_alloc_page;
>  		}
> @@ -1702,7 +1702,7 @@ xfs_free_buftarg(
>  
>  	xfs_blkdev_issue_flush(btp);
>  
> -	kmem_free(btp);
> +	kfree(btp);
>  }
>  
>  int
> @@ -1778,7 +1778,7 @@ xfs_alloc_buftarg(
>  error_lru:
>  	list_lru_destroy(&btp->bt_lru);
>  error_free:
> -	kmem_free(btp);
> +	kfree(btp);
>  	return NULL;
>  }
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3458a1264a3f..8dc3330f1797 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -713,7 +713,7 @@ xfs_buf_item_free_format(
>  	struct xfs_buf_log_item	*bip)
>  {
>  	if (bip->bli_formats != &bip->__bli_format) {
> -		kmem_free(bip->bli_formats);
> +		kfree(bip->bli_formats);
>  		bip->bli_formats = NULL;
>  	}
>  }
> @@ -938,7 +938,7 @@ xfs_buf_item_free(
>  	struct xfs_buf_log_item	*bip)
>  {
>  	xfs_buf_item_free_format(bip);
> -	kmem_free(bip->bli_item.li_lv_shadow);
> +	kfree(bip->bli_item.li_lv_shadow);
>  	kmem_cache_free(xfs_buf_item_zone, bip);
>  }
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 153815bf18fc..a073281c3bd7 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -52,7 +52,7 @@ xfs_qm_dqdestroy(
>  {
>  	ASSERT(list_empty(&dqp->q_lru));
>  
> -	kmem_free(dqp->q_logitem.qli_item.li_lv_shadow);
> +	kfree(dqp->q_logitem.qli_item.li_lv_shadow);
>  	mutex_destroy(&dqp->q_qlock);
>  
>  	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot);
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index d60647d7197b..1b5e68ccef60 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -316,10 +316,10 @@ xfs_qm_qoffend_logitem_committed(
>  	spin_lock(&ailp->ail_lock);
>  	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
>  
> -	kmem_free(qfs->qql_item.li_lv_shadow);
> -	kmem_free(lip->li_lv_shadow);
> -	kmem_free(qfs);
> -	kmem_free(qfe);
> +	kfree(qfs->qql_item.li_lv_shadow);
> +	kfree(lip->li_lv_shadow);
> +	kfree(qfs);
> +	kfree(qfe);
>  	return (xfs_lsn_t)-1;
>  }
>  
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 51dd1f43d12f..4c0883380d7c 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -226,7 +226,7 @@ xfs_errortag_del(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_sysfs_del(&mp->m_errortag_kobj);
> -	kmem_free(mp->m_errortag);
> +	kfree(mp->m_errortag);
>  }
>  
>  bool
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 3991e59cfd18..9f0b99c7b34a 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -532,7 +532,7 @@ xfs_extent_busy_clear_one(
>  	}
>  
>  	list_del_init(&busyp->list);
> -	kmem_free(busyp);
> +	kfree(busyp);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6ea847f6e298..29b3a90aee91 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -35,9 +35,9 @@ void
>  xfs_efi_item_free(
>  	struct xfs_efi_log_item	*efip)
>  {
> -	kmem_free(efip->efi_item.li_lv_shadow);
> +	kfree(efip->efi_item.li_lv_shadow);
>  	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
> -		kmem_free(efip);
> +		kfree(efip);
>  	else
>  		kmem_cache_free(xfs_efi_zone, efip);
>  }
> @@ -240,9 +240,9 @@ static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
>  STATIC void
>  xfs_efd_item_free(struct xfs_efd_log_item *efdp)
>  {
> -	kmem_free(efdp->efd_item.li_lv_shadow);
> +	kfree(efdp->efd_item.li_lv_shadow);
>  	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
> -		kmem_free(efdp);
> +		kfree(efdp);
>  	else
>  		kmem_cache_free(xfs_efd_zone, efdp);
>  }
> @@ -488,7 +488,7 @@ xfs_extent_free_finish_item(
>  			free->xefi_startblock,
>  			free->xefi_blockcount,
>  			&free->xefi_oinfo, free->xefi_skip_discard);
> -	kmem_free(free);
> +	kfree(free);
>  	return error;
>  }
>  
> @@ -508,7 +508,7 @@ xfs_extent_free_cancel_item(
>  	struct xfs_extent_free_item	*free;
>  
>  	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -	kmem_free(free);
> +	kfree(free);
>  }
>  
>  const struct xfs_defer_op_type xfs_extent_free_defer_type = {
> @@ -572,7 +572,7 @@ xfs_agfl_free_finish_item(
>  	extp->ext_len = free->xefi_blockcount;
>  	efdp->efd_next_extent++;
>  
> -	kmem_free(free);
> +	kfree(free);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 2ae356775f63..9778e4e69e07 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -118,7 +118,7 @@ xfs_fstrm_free_func(
>  	xfs_filestream_put_ag(mp, item->ag);
>  	trace_xfs_filestream_free(mp, mru->key, item->ag);
>  
> -	kmem_free(item);
> +	kfree(item);
>  }
>  
>  /*
> @@ -263,7 +263,7 @@ xfs_filestream_pick_ag(
>  	return 0;
>  
>  out_free_item:
> -	kmem_free(item);
> +	kfree(item);
>  out_put_ag:
>  	xfs_filestream_put_ag(mp, *agp);
>  	return err;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a92d4521748d..e1121ed7cbb5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -708,7 +708,7 @@ xfs_lookup(
>  
>  out_free_name:
>  	if (ci_name)
> -		kmem_free(ci_name->name);
> +		kfree(ci_name->name);
>  out_unlock:
>  	*ipp = NULL;
>  	return error;
> @@ -2001,7 +2001,7 @@ xfs_iunlink_insert_backref(
>  	 */
>  	if (error) {
>  		WARN(error != -ENOMEM, "iunlink cache insert error %d", error);
> -		kmem_free(iu);
> +		kfree(iu);
>  	}
>  	/*
>  	 * Absorb any runtime errors that aren't a result of corruption because
> @@ -2066,7 +2066,7 @@ xfs_iunlink_change_backref(
>  
>  	/* If there is no new next entry just free our item and return. */
>  	if (next_unlinked == NULLAGINO) {
> -		kmem_free(iu);
> +		kfree(iu);
>  		return 0;
>  	}
>  
> @@ -2094,7 +2094,7 @@ xfs_iunlink_free_item(
>  	bool			*freed_anything = arg;
>  
>  	*freed_anything = true;
> -	kmem_free(iu);
> +	kfree(iu);
>  }
>  
>  void
> @@ -3598,7 +3598,7 @@ xfs_iflush_cluster(
>  
>  out_free:
>  	rcu_read_unlock();
> -	kmem_free(cilist);
> +	kfree(cilist);
>  out_put:
>  	xfs_perag_put(pag);
>  	return 0;
> @@ -3629,7 +3629,7 @@ xfs_iflush_cluster(
>  
>  	/* abort the corrupt inode, as it was not attached to the buffer */
>  	xfs_iflush_abort(cip, false);
> -	kmem_free(cilist);
> +	kfree(cilist);
>  	xfs_perag_put(pag);
>  	return -EFSCORRUPTED;
>  }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 3a62976291a1..c8461a5515f1 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -666,7 +666,7 @@ void
>  xfs_inode_item_destroy(
>  	xfs_inode_t	*ip)
>  {
> -	kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
> +	kfree(ip->i_itemp->ili_item.li_lv_shadow);
>  	kmem_cache_free(xfs_ili_zone, ip->i_itemp);
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 364961c23cd0..f86dde7c9ea6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -417,7 +417,7 @@ xfs_attrlist_by_handle(
>  		error = -EFAULT;
>  
>  out_kfree:
> -	kmem_free(kbuf);
> +	kvfree(kbuf);
>  out_dput:
>  	dput(dentry);
>  	return error;
> @@ -448,7 +448,7 @@ xfs_attrmulti_attr_get(
>  		error = -EFAULT;
>  
>  out_kfree:
> -	kmem_free(kbuf);
> +	kvfree(kbuf);
>  	return error;
>  }
>  
> @@ -1777,7 +1777,7 @@ xfs_ioc_getbmap(
>  
>  	error = 0;
>  out_free_buf:
> -	kmem_free(buf);
> +	kvfree(buf);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 3c0d518e1039..de472fcd2f67 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -400,7 +400,7 @@ xfs_compat_attrlist_by_handle(
>  		error = -EFAULT;
>  
>  out_kfree:
> -	kmem_free(kbuf);
> +	kvfree(kbuf);
>  out_dput:
>  	dput(dentry);
>  	return error;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 57e6e44123a9..e532db27d0dc 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -303,7 +303,7 @@ xfs_vn_ci_lookup(
>  	dname.name = ci_name.name;
>  	dname.len = ci_name.len;
>  	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
> -	kmem_free(ci_name.name);
> +	kfree(ci_name.name);
>  	return dentry;
>  }
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 884950adbd16..36bf47f11117 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -175,7 +175,7 @@ xfs_bulkstat_one(
>  
>  	error = xfs_bulkstat_one_int(breq->mp, NULL, breq->startino, &bc);
>  
> -	kmem_free(bc.buf);
> +	kfree(bc.buf);
>  
>  	/*
>  	 * If we reported one inode to userspace then we abort because we hit
> @@ -250,7 +250,7 @@ xfs_bulkstat(
>  	error = xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>  
> -	kmem_free(bc.buf);
> +	kfree(bc.buf);
>  
>  	/*
>  	 * We found some inodes, so clear the error status and return them.
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index aa375cf53021..67e98f9023d2 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -164,7 +164,7 @@ STATIC void
>  xfs_iwalk_free(
>  	struct xfs_iwalk_ag	*iwag)
>  {
> -	kmem_free(iwag->recs);
> +	kfree(iwag->recs);
>  	iwag->recs = NULL;
>  }
>  
> @@ -578,7 +578,7 @@ xfs_iwalk_ag_work(
>  	error = xfs_iwalk_ag(iwag);
>  	xfs_iwalk_free(iwag);
>  out:
> -	kmem_free(iwag);
> +	kfree(iwag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6a147c63a8a6..e8349b0d7c51 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1540,11 +1540,11 @@ xlog_alloc_log(
>  out_free_iclog:
>  	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
>  		prev_iclog = iclog->ic_next;
> -		kmem_free(iclog->ic_data);
> -		kmem_free(iclog);
> +		kvfree(iclog->ic_data);
> +		kfree(iclog);
>  	}
>  out_free_log:
> -	kmem_free(log);
> +	kfree(log);
>  out:
>  	return ERR_PTR(error);
>  }	/* xlog_alloc_log */
> @@ -2001,14 +2001,14 @@ xlog_dealloc_log(
>  	iclog = log->l_iclog;
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
>  		next_iclog = iclog->ic_next;
> -		kmem_free(iclog->ic_data);
> -		kmem_free(iclog);
> +		kvfree(iclog->ic_data);
> +		kfree(iclog);
>  		iclog = next_iclog;
>  	}
>  
>  	log->l_mp->m_log = NULL;
>  	destroy_workqueue(log->l_ioend_workqueue);
> -	kmem_free(log);
> +	kfree(log);
>  }	/* xlog_dealloc_log */
>  
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48435cf2aa16..23d70836a2b7 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -184,7 +184,7 @@ xlog_cil_alloc_shadow_bufs(
>  			 * the buffer, only the log vector header and the iovec
>  			 * storage.
>  			 */
> -			kmem_free(lip->li_lv_shadow);
> +			kfree(lip->li_lv_shadow);
>  
>  			lv = kmem_alloc_large(buf_size, KM_NOFS);
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
> @@ -492,7 +492,7 @@ xlog_cil_free_logvec(
>  
>  	for (lv = log_vector; lv; ) {
>  		struct xfs_log_vec *next = lv->lv_next;
> -		kmem_free(lv);
> +		kvfree(lv);
>  		lv = next;
>  	}
>  }
> @@ -506,7 +506,7 @@ xlog_discard_endio_work(
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
>  
>  	xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
> -	kmem_free(ctx);
> +	kfree(ctx);
>  }
>  
>  /*
> @@ -608,7 +608,7 @@ xlog_cil_committed(
>  	if (!list_empty(&ctx->busy_extents))
>  		xlog_discard_busy_extents(mp, ctx);
>  	else
> -		kmem_free(ctx);
> +		kfree(ctx);
>  }
>  
>  void
> @@ -872,7 +872,7 @@ xlog_cil_push(
>  out_skip:
>  	up_write(&cil->xc_ctx_lock);
>  	xfs_log_ticket_put(new_ctx->ticket);
> -	kmem_free(new_ctx);
> +	kfree(new_ctx);
>  	return 0;
>  
>  out_abort_free_ticket:
> @@ -1185,7 +1185,7 @@ xlog_cil_init(
>  
>  	ctx = kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
>  	if (!ctx) {
> -		kmem_free(cil);
> +		kfree(cil);
>  		return -ENOMEM;
>  	}
>  
> @@ -1216,10 +1216,10 @@ xlog_cil_destroy(
>  	if (log->l_cilp->xc_ctx) {
>  		if (log->l_cilp->xc_ctx->ticket)
>  			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
> -		kmem_free(log->l_cilp->xc_ctx);
> +		kfree(log->l_cilp->xc_ctx);
>  	}
>  
>  	ASSERT(list_empty(&log->l_cilp->xc_cil));
> -	kmem_free(log->l_cilp);
> +	kfree(log->l_cilp);
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 02f2147952b3..4167e1326f62 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -418,7 +418,7 @@ xlog_find_verify_cycle(
>  	*new_blk = -1;
>  
>  out:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -529,7 +529,7 @@ xlog_find_verify_log_record(
>  		*last_blk = i;
>  
>  out:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -783,7 +783,7 @@ xlog_find_head(
>  			goto out_free_buffer;
>  	}
>  
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	if (head_blk == log_bbnum)
>  		*return_head_blk = 0;
>  	else
> @@ -797,7 +797,7 @@ xlog_find_head(
>  	return 0;
>  
>  out_free_buffer:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	if (error)
>  		xfs_warn(log->l_mp, "failed to find log head");
>  	return error;
> @@ -1051,7 +1051,7 @@ xlog_verify_tail(
>  		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
>  			 orig_tail, *tail_blk);
>  out:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -1098,7 +1098,7 @@ xlog_verify_head(
>  	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
>  				      XLOG_MAX_ICLOGS, tmp_buffer,
>  				      &tmp_rhead_blk, &tmp_rhead, &tmp_wrapped);
> -	kmem_free(tmp_buffer);
> +	kvfree(tmp_buffer);
>  	if (error < 0)
>  		return error;
>  
> @@ -1431,7 +1431,7 @@ xlog_find_tail(
>  		error = xlog_clear_stale_blocks(log, tail_lsn);
>  
>  done:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  
>  	if (error)
>  		xfs_warn(log->l_mp, "failed to locate log tail");
> @@ -1479,7 +1479,7 @@ xlog_find_zeroed(
>  	first_cycle = xlog_get_cycle(offset);
>  	if (first_cycle == 0) {		/* completely zeroed log */
>  		*blk_no = 0;
> -		kmem_free(buffer);
> +		kvfree(buffer);
>  		return 1;
>  	}
>  
> @@ -1490,7 +1490,7 @@ xlog_find_zeroed(
>  
>  	last_cycle = xlog_get_cycle(offset);
>  	if (last_cycle != 0) {		/* log completely written to */
> -		kmem_free(buffer);
> +		kvfree(buffer);
>  		return 0;
>  	}
>  
> @@ -1537,7 +1537,7 @@ xlog_find_zeroed(
>  
>  	*blk_no = last_blk;
>  out_free_buffer:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	if (error)
>  		return error;
>  	return 1;
> @@ -1649,7 +1649,7 @@ xlog_write_log_records(
>  	}
>  
>  out_free_buffer:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -2039,7 +2039,7 @@ xlog_check_buffer_cancelled(
>  	if (flags & XFS_BLF_CANCEL) {
>  		if (--bcp->bc_refcount == 0) {
>  			list_del(&bcp->bc_list);
> -			kmem_free(bcp);
> +			kfree(bcp);
>  		}
>  	}
>  	return 1;
> @@ -3188,7 +3188,7 @@ xlog_recover_inode_pass2(
>  	xfs_buf_relse(bp);
>  error:
>  	if (need_free)
> -		kmem_free(in_f);
> +		kfree(in_f);
>  	return error;
>  }
>  
> @@ -4292,7 +4292,7 @@ xlog_recover_add_to_trans(
>  		"bad number of regions (%d) in inode log format",
>  				  in_f->ilf_size);
>  			ASSERT(0);
> -			kmem_free(ptr);
> +			kfree(ptr);
>  			return -EFSCORRUPTED;
>  		}
>  
> @@ -4307,7 +4307,7 @@ xlog_recover_add_to_trans(
>  	"log item region count (%d) overflowed size (%d)",
>  				item->ri_cnt, item->ri_total);
>  		ASSERT(0);
> -		kmem_free(ptr);
> +		kfree(ptr);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -4337,13 +4337,13 @@ xlog_recover_free_trans(
>  		/* Free the regions in the item. */
>  		list_del(&item->ri_list);
>  		for (i = 0; i < item->ri_cnt; i++)
> -			kmem_free(item->ri_buf[i].i_addr);
> +			kfree(item->ri_buf[i].i_addr);
>  		/* Free the item itself */
> -		kmem_free(item->ri_buf);
> -		kmem_free(item);
> +		kfree(item->ri_buf);
> +		kfree(item);
>  	}
>  	/* Free the transaction recover structure */
> -	kmem_free(trans);
> +	kfree(trans);
>  }
>  
>  /*
> @@ -5327,7 +5327,7 @@ xlog_do_recovery_pass(
>  			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
>  			if (h_size % XLOG_HEADER_CYCLE_SIZE)
>  				hblks++;
> -			kmem_free(hbp);
> +			kvfree(hbp);
>  			hbp = xlog_alloc_buffer(log, hblks);
>  		} else {
>  			hblks = 1;
> @@ -5343,7 +5343,7 @@ xlog_do_recovery_pass(
>  		return -ENOMEM;
>  	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
>  	if (!dbp) {
> -		kmem_free(hbp);
> +		kvfree(hbp);
>  		return -ENOMEM;
>  	}
>  
> @@ -5504,9 +5504,9 @@ xlog_do_recovery_pass(
>  	}
>  
>   bread_err2:
> -	kmem_free(dbp);
> +	kvfree(dbp);
>   bread_err1:
> -	kmem_free(hbp);
> +	kvfree(hbp);
>  
>  	/*
>  	 * Submit buffers that have been added from the last record processed,
> @@ -5570,7 +5570,7 @@ xlog_do_log_recovery(
>  	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
>  				      XLOG_RECOVER_PASS1, NULL);
>  	if (error != 0) {
> -		kmem_free(log->l_buf_cancel_table);
> +		kfree(log->l_buf_cancel_table);
>  		log->l_buf_cancel_table = NULL;
>  		return error;
>  	}
> @@ -5589,7 +5589,7 @@ xlog_do_log_recovery(
>  	}
>  #endif	/* DEBUG */
>  
> -	kmem_free(log->l_buf_cancel_table);
> +	kfree(log->l_buf_cancel_table);
>  	log->l_buf_cancel_table = NULL;
>  
>  	return error;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 5ea95247a37f..53ddb058b11a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -42,7 +42,7 @@ xfs_uuid_table_free(void)
>  {
>  	if (xfs_uuid_table_size == 0)
>  		return;
> -	kmem_free(xfs_uuid_table);
> +	kfree(xfs_uuid_table);
>  	xfs_uuid_table = NULL;
>  	xfs_uuid_table_size = 0;
>  }
> @@ -127,7 +127,7 @@ __xfs_free_perag(
>  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
>  
>  	ASSERT(atomic_read(&pag->pag_ref) == 0);
> -	kmem_free(pag);
> +	kfree(pag);
>  }
>  
>  /*
> @@ -243,7 +243,7 @@ xfs_initialize_perag(
>  	xfs_buf_hash_destroy(pag);
>  out_free_pag:
>  	mutex_destroy(&pag->pag_ici_reclaim_lock);
> -	kmem_free(pag);
> +	kfree(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
>  	for (index = first_initialised; index < agcount; index++) {
> @@ -253,7 +253,7 @@ xfs_initialize_perag(
>  		xfs_buf_hash_destroy(pag);
>  		xfs_iunlink_destroy(pag);
>  		mutex_destroy(&pag->pag_ici_reclaim_lock);
> -		kmem_free(pag);
> +		kfree(pag);
>  	}
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index a06661dac5be..6ef0a71d7681 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -364,9 +364,9 @@ xfs_mru_cache_create(
>  
>  exit:
>  	if (err && mru && mru->lists)
> -		kmem_free(mru->lists);
> +		kfree(mru->lists);
>  	if (err && mru)
> -		kmem_free(mru);
> +		kfree(mru);
>  
>  	return err;
>  }
> @@ -406,8 +406,8 @@ xfs_mru_cache_destroy(
>  
>  	xfs_mru_cache_flush(mru);
>  
> -	kmem_free(mru->lists);
> -	kmem_free(mru);
> +	kfree(mru->lists);
> +	kfree(mru);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 66ea8e4fca86..06c92dc61a03 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -698,7 +698,7 @@ xfs_qm_init_quotainfo(
>  out_free_lru:
>  	list_lru_destroy(&qinf->qi_lru);
>  out_free_qinf:
> -	kmem_free(qinf);
> +	kfree(qinf);
>  	mp->m_quotainfo = NULL;
>  	return error;
>  }
> @@ -722,7 +722,7 @@ xfs_qm_destroy_quotainfo(
>  	xfs_qm_destroy_quotainos(qi);
>  	mutex_destroy(&qi->qi_tree_lock);
>  	mutex_destroy(&qi->qi_quotaofflock);
> -	kmem_free(qi);
> +	kfree(qi);
>  	mp->m_quotainfo = NULL;
>  }
>  
> @@ -1049,7 +1049,7 @@ xfs_qm_reset_dqcounts_buf(
>  	} while (nmaps > 0);
>  
>  out:
> -	kmem_free(map);
> +	kfree(map);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8eeed73928cd..0ac598f55339 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -32,7 +32,7 @@ xfs_cui_item_free(
>  	struct xfs_cui_log_item	*cuip)
>  {
>  	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
> -		kmem_free(cuip);
> +		kfree(cuip);
>  	else
>  		kmem_cache_free(xfs_cui_zone, cuip);
>  }
> @@ -392,7 +392,7 @@ xfs_refcount_update_finish_item(
>  		refc->ri_blockcount = new_aglen;
>  		return -EAGAIN;
>  	}
> -	kmem_free(refc);
> +	kfree(refc);
>  	return error;
>  }
>  
> @@ -424,7 +424,7 @@ xfs_refcount_update_cancel_item(
>  	struct xfs_refcount_intent	*refc;
>  
>  	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> -	kmem_free(refc);
> +	kfree(refc);
>  }
>  
>  const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4911b68f95dd..a0a02d862ddd 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -32,7 +32,7 @@ xfs_rui_item_free(
>  	struct xfs_rui_log_item	*ruip)
>  {
>  	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
> -		kmem_free(ruip);
> +		kfree(ruip);
>  	else
>  		kmem_cache_free(xfs_rui_zone, ruip);
>  }
> @@ -436,7 +436,7 @@ xfs_rmap_update_finish_item(
>  			rmap->ri_bmap.br_blockcount,
>  			rmap->ri_bmap.br_state,
>  			(struct xfs_btree_cur **)state);
> -	kmem_free(rmap);
> +	kfree(rmap);
>  	return error;
>  }
>  
> @@ -468,7 +468,7 @@ xfs_rmap_update_cancel_item(
>  	struct xfs_rmap_intent		*rmap;
>  
>  	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> -	kmem_free(rmap);
> +	kfree(rmap);
>  }
>  
>  const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d42b5a2047e0..7f03b4ab3452 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1082,7 +1082,7 @@ xfs_growfs_rt(
>  	/*
>  	 * Free the fake mp structure.
>  	 */
> -	kmem_free(nmp);
> +	kfree(nmp);
>  
>  	/*
>  	 * If we had to allocate a new rsum_cache, we either need to free the
> @@ -1091,10 +1091,10 @@ xfs_growfs_rt(
>  	 */
>  	if (rsum_cache != mp->m_rsum_cache) {
>  		if (error) {
> -			kmem_free(mp->m_rsum_cache);
> +			kvfree(mp->m_rsum_cache);
>  			mp->m_rsum_cache = rsum_cache;
>  		} else {
> -			kmem_free(rsum_cache);
> +			kvfree(rsum_cache);
>  		}
>  	}
>  
> @@ -1253,7 +1253,7 @@ void
>  xfs_rtunmount_inodes(
>  	struct xfs_mount	*mp)
>  {
> -	kmem_free(mp->m_rsum_cache);
> +	kvfree(mp->m_rsum_cache);
>  	if (mp->m_rbmip)
>  		xfs_irele(mp->m_rbmip);
>  	if (mp->m_rsumip)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d9ae27ddf253..cc1933dc652f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -725,7 +725,7 @@ xfs_mount_free(
>  {
>  	kfree(mp->m_rtname);
>  	kfree(mp->m_logname);
> -	kmem_free(mp);
> +	kfree(mp);
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 00cc5b8734be..589918d11041 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -844,7 +844,7 @@ xfs_trans_ail_init(
>  	return 0;
>  
>  out_free_ailp:
> -	kmem_free(ailp);
> +	kfree(ailp);
>  	return -ENOMEM;
>  }
>  
> @@ -855,5 +855,5 @@ xfs_trans_ail_destroy(
>  	struct xfs_ail	*ailp = mp->m_ail;
>  
>  	kthread_stop(ailp->ail_task);
> -	kmem_free(ailp);
> +	kfree(ailp);
>  }
> -- 
> 2.23.0
> 
