Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C7C87CBF
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 17:37:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3A40AC003
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 15:37:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mrEshaXDW3P4CKmS for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 15:37:27 -0700 (PDT)
Date: Fri, 15 May 2015 08:36:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: create new metadata UUID field and incompat flag
Message-ID: <20150514223610.GU15721@dastard>
References: <55525356.1020807@sandeen.net>
 <55525437.9070501@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55525437.9070501@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, May 12, 2015 at 02:27:51PM -0500, Eric Sandeen wrote:
> This adds a new superblock field, sb_meta_uuid.  If set, along with
> a new incompat flag, the code will use that field on a V5 filesystem
> to compare to metadata UUIDs, which allows us to change the user-
> visible UUID at will.  Userspace handles the setting and clearing
> of the incompat flag as appropriate, as the UUID gets changed; i.e.
> setting the user-visible UUID back to the original UUID (as stored in
> the new field) will remove the incompatible feature flag.
> 
> If the incompat flag is not set, this copies the user-visible UUID into
> into the meta_uuid slot in memory when the superblock is read from disk;
> the meta_uuid field is not written back to disk in this case.
> 
> The remainder of this patch simply switches verifiers, initializers,
> etc to use the new sb_meta_uuid field.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Couple of minor things:
>  
>  /*
> + * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
> + * is stored separately from the user-visible UUID; this allows the
> + * user-visible UUID to be changed on V5 filesystems which have a
> + * filesystem UUID stamped into every piece of metadata.
> + */
> +static inline int xfs_sb_version_hasmetauuid(xfs_sb_t *sbp)

bool, struct xfs_sb.

> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -377,6 +377,17 @@ __xfs_sb_from_disk(
>  	to->sb_pad = 0;
>  	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
>  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
> +	/*
> +	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
> +	 * feature flag is set; if not set we keep it only in memory.
> +	 */
> +	if (xfs_sb_version_hasmetauuid(to)) {
> +		memcpy(&to->sb_meta_uuid, &from->sb_meta_uuid,
> +					sizeof(to->sb_meta_uuid));
> +	} else {
> +		memcpy(&to->sb_meta_uuid, &from->sb_uuid,
> +					sizeof(to->sb_meta_uuid));
> +	}

uuid_copy()

>  	/* Convert on-disk flags to in-memory flags? */
>  	if (convert_xquota)
>  		xfs_sb_quota_from_disk(to);
> @@ -518,6 +529,10 @@ xfs_sb_to_disk(
>  				cpu_to_be32(from->sb_features_log_incompat);
>  		to->sb_pad = 0;
>  		to->sb_lsn = cpu_to_be64(from->sb_lsn);
> +		if (xfs_sb_version_hasmetauuid(from)) {
> +			memcpy(&to->sb_meta_uuid, &from->sb_meta_uuid,
> +						sizeof(to->sb_meta_uuid));
> +		}

uuid_copy() here, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
