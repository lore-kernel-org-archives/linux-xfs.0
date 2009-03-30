Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2U6LVeo181374 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 01:21:41 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6CD86AC017
	for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 23:21:06 -0700 (PDT)
Message-Id: <BC45F7F8-7287-451A-9539-04E351877921@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090318094131.771403000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 1/5] xfs: cleanup uuid handling
Date: Mon, 30 Mar 2009 01:06:09 -0500
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094131.771403000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Mar 18, 2009, at 4:41 AM, Christoph Hellwig wrote:

> The uuid table handling should not be part of a semi-generic uuid  
> library
> but in the XFS code using it, so move those bits to xfs_mount.c and
> refactor the whole glob to give a proper abstraction.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: xfs/fs/xfs/support/uuid.c
> ===================================================================
> --- xfs.orig/fs/xfs/support/uuid.c	2009-02-15 19:40:08.564944522 +0100
> +++ xfs/fs/xfs/support/uuid.c	2009-02-24 21:50:49.051029140 +0100
> @@ -17,10 +17,6 @@
>  */
> #include <xfs.h>
>
> -static DEFINE_MUTEX(uuid_monitor);
> -static int	uuid_table_size;
> -static uuid_t	*uuid_table;
> -
> /* IRIX interpretation of an uuid_t */
> typedef struct {
> 	__be32	uu_timelow;
> @@ -46,12 +42,6 @@ uuid_getnodeuniq(uuid_t *uuid, int fsid
> 	fsid[1] = be32_to_cpu(uup->uu_timelow);
> }
>
> -void
> -uuid_create_nil(uuid_t *uuid)
> -{
> -	memset(uuid, 0, sizeof(*uuid));
> -}
> -
> int
> uuid_is_nil(uuid_t *uuid)
> {
> @@ -71,64 +61,3 @@ uuid_equal(uuid_t *uuid1, uuid_t *uuid2)
> {
> 	return memcmp(uuid1, uuid2, sizeof(uuid_t)) ? 0 : 1;
> }
> -
> -/*
> - * Given a 128-bit uuid, return a 64-bit value by adding the top  
> and bottom
> - * 64-bit words.  NOTE: This function can not be changed EVER.   
> Although
> - * brain-dead, some applications depend on this 64-bit value  
> remaining
> - * persistent.  Specifically, DMI vendors store the value as a  
> persistent
> - * filehandle.
> - */
> -__uint64_t
> -uuid_hash64(uuid_t *uuid)
> -{
> -	__uint64_t	*sp = (__uint64_t *)uuid;
> -
> -	return sp[0] + sp[1];
> -}
> -
> -int
> -uuid_table_insert(uuid_t *uuid)
> -{
> -	int	i, hole;
> -
> -	mutex_lock(&uuid_monitor);
> -	for (i = 0, hole = -1; i < uuid_table_size; i++) {
> -		if (uuid_is_nil(&uuid_table[i])) {
> -			hole = i;
> -			continue;
> -		}
> -		if (uuid_equal(uuid, &uuid_table[i])) {
> -			mutex_unlock(&uuid_monitor);
> -			return 0;
> -		}
> -	}
> -	if (hole < 0) {
> -		uuid_table = kmem_realloc(uuid_table,
> -			(uuid_table_size + 1) * sizeof(*uuid_table),
> -			uuid_table_size  * sizeof(*uuid_table),
> -			KM_SLEEP);
> -		hole = uuid_table_size++;
> -	}
> -	uuid_table[hole] = *uuid;
> -	mutex_unlock(&uuid_monitor);
> -	return 1;
> -}
> -
> -void
> -uuid_table_remove(uuid_t *uuid)
> -{
> -	int	i;
> -
> -	mutex_lock(&uuid_monitor);
> -	for (i = 0; i < uuid_table_size; i++) {
> -		if (uuid_is_nil(&uuid_table[i]))
> -			continue;
> -		if (!uuid_equal(uuid, &uuid_table[i]))
> -			continue;
> -		uuid_create_nil(&uuid_table[i]);
> -		break;
> -	}
> -	ASSERT(i < uuid_table_size);
> -	mutex_unlock(&uuid_monitor);
> -}
> Index: xfs/fs/xfs/support/uuid.h
> ===================================================================
> --- xfs.orig/fs/xfs/support/uuid.h	2009-02-15 19:40:08.569944670 +0100
> +++ xfs/fs/xfs/support/uuid.h	2009-02-24 21:50:37.206029255 +0100
> @@ -22,12 +22,8 @@ typedef struct {
> 	unsigned char	__u_bits[16];
> } uuid_t;
>
> -extern void uuid_create_nil(uuid_t *uuid);
> extern int uuid_is_nil(uuid_t *uuid);
> extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
> extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
> -extern __uint64_t uuid_hash64(uuid_t *uuid);
> -extern int uuid_table_insert(uuid_t *uuid);
> -extern void uuid_table_remove(uuid_t *uuid);
>
> #endif	/* __XFS_SUPPORT_UUID_H__ */
> Index: xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.c	2009-02-24 15:32:35.871518446 +0100
> +++ xfs/fs/xfs/xfs_mount.c	2009-02-24 21:51:03.558027729 +0100
> @@ -45,7 +45,6 @@
> #include "xfs_fsops.h"
> #include "xfs_utils.h"
>
> -STATIC int	xfs_uuid_mount(xfs_mount_t *);
> STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
>
>
> @@ -121,6 +120,84 @@ static const struct {
>     { sizeof(xfs_sb_t),			 0 }
> };
>
> +static DEFINE_MUTEX(xfs_uuid_table_mutex);
> +static int xfs_uuid_table_size;
> +static uuid_t *xfs_uuid_table;
> +
> +/*
> + * See if the UUID is unique among mounted XFS filesystems.
> + * Mount fails if UUID is nil or a FS with the same UUID is already  
> mounted.
> + */
> +STATIC int
> +xfs_uuid_mount(
> +	struct xfs_mount	*mp)
> +{
> +	uuid_t			*uuid = &mp->m_sb.sb_uuid;
> +	int			hole, i;
> +
> +	if (mp->m_flags & XFS_MOUNT_NOUUID)
> +		return 0;
> +
> +	if (uuid_is_nil(uuid)) {
> +		cmn_err(CE_WARN,
> +			"XFS: Filesystem %s has nil UUID - can't mount",
> +			mp->m_fsname);
> +		return XFS_ERROR(EINVAL);
> +	}
> +
> +	mutex_lock(&xfs_uuid_table_mutex);
> +	for (i = 0, hole = -1; i < xfs_uuid_table_size; i++) {
> +		if (uuid_is_nil(&xfs_uuid_table[i])) {
> +			hole = i;
> +			continue;
> +		}
> +		if (uuid_equal(uuid, &xfs_uuid_table[i]))
> +			goto out_duplicate;
> +	}
> +
> +	if (hole < 0) {
> +		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
> +			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
> +			xfs_uuid_table_size  * sizeof(*xfs_uuid_table),
> +			KM_SLEEP);
> +		hole = xfs_uuid_table_size++;
> +	}
> +	xfs_uuid_table[hole] = *uuid;
> +	mutex_unlock(&xfs_uuid_table_mutex);
> +
> +	return 0;
> +
> + out_duplicate:
> +	mutex_unlock(&xfs_uuid_table_mutex);
> +	cmn_err(CE_WARN, "XFS: Filesystem %s has duplicate UUID - can't  
> mount",
> +			 mp->m_fsname);
> +	return XFS_ERROR(EINVAL);
> +}
> +
> +STATIC void
> +xfs_uuid_unmount(
> +	struct xfs_mount	*mp)
> +{
> +	uuid_t			*uuid = &mp->m_sb.sb_uuid;
> +	int			i;
> +
> +	if (mp->m_flags & XFS_MOUNT_NOUUID)
> +		return;
> +
> +	mutex_lock(&xfs_uuid_table_mutex);
> +	for (i = 0; i < xfs_uuid_table_size; i++) {
> +		if (uuid_is_nil(&xfs_uuid_table[i]))
> +			continue;
> +		if (!uuid_equal(uuid, &xfs_uuid_table[i]))
> +			continue;
> +		memset(&xfs_uuid_table[i], 0, sizeof(uuid_t));
> +		break;
> +	}
> +	ASSERT(i < xfs_uuid_table_size);
> +	mutex_unlock(&xfs_uuid_table_mutex);
> +}
> +
> +
> /*
>  * Free up the resources associated with a mount structure.  Assume  
> that
>  * the structure was initially zeroed, so we can tell which fields got
> @@ -1016,18 +1093,9 @@ xfs_mountfs(
>
> 	mp->m_maxioffset = xfs_max_file_offset(sbp->sb_blocklog);
>
> -	/*
> -	 * XFS uses the uuid from the superblock as the unique
> -	 * identifier for fsid.  We can not use the uuid from the volume
> -	 * since a single partition filesystem is identical to a single
> -	 * partition volume/filesystem.
> -	 */
> -	if (!(mp->m_flags & XFS_MOUNT_NOUUID)) {
> -		if (xfs_uuid_mount(mp)) {
> -			error = XFS_ERROR(EINVAL);
> -			goto out;
> -		}
> -	}
> +	error = xfs_uuid_mount(mp);
> +	if (error)
> +		goto out;
>
> 	/*
> 	 * Set the minimum read and write sizes
> @@ -1275,8 +1343,7 @@ xfs_mountfs(
>  out_free_perag:
> 	xfs_free_perag(mp);
>  out_remove_uuid:
> -	if (!(mp->m_flags & XFS_MOUNT_NOUUID))
> -		uuid_table_remove(&mp->m_sb.sb_uuid);
> +	xfs_uuid_unmount(mp);
>  out:
> 	return error;
> }
> @@ -1351,9 +1418,7 @@ xfs_unmountfs(
> 	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
> 	xfs_log_unmount_write(mp);
> 	xfs_log_unmount(mp);
> -
> -	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0)
> -		uuid_table_remove(&mp->m_sb.sb_uuid);
> +	xfs_uuid_unmount(mp);
>
> #if defined(DEBUG)
> 	xfs_errortag_clearall(mp, 0);
> @@ -1855,29 +1920,6 @@ xfs_freesb(
> }
>
> /*
> - * See if the UUID is unique among mounted XFS filesystems.
> - * Mount fails if UUID is nil or a FS with the same UUID is already  
> mounted.
> - */
> -STATIC int
> -xfs_uuid_mount(
> -	xfs_mount_t	*mp)
> -{
> -	if (uuid_is_nil(&mp->m_sb.sb_uuid)) {
> -		cmn_err(CE_WARN,
> -			"XFS: Filesystem %s has nil UUID - can't mount",
> -			mp->m_fsname);
> -		return -1;
> -	}
> -	if (!uuid_table_insert(&mp->m_sb.sb_uuid)) {
> -		cmn_err(CE_WARN,
> -			"XFS: Filesystem %s has duplicate UUID - can't mount",
> -			mp->m_fsname);
> -		return -1;
> -	}
> -	return 0;
> -}
> -
> -/*
>  * Used to log changes to the superblock unit and width fields which  
> could
>  * be altered by the mount options, as well as any potential  
> sb_features2
>  * fixup. Only the first superblock is updated.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
