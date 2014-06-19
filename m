Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 588717F3F
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 08:02:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A529304067
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 06:01:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ouuxu0ZZoua93VcE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Jun 2014 06:01:55 -0700 (PDT)
Date: Thu, 19 Jun 2014 09:01:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] repair: support more than 25 ACLs
Message-ID: <20140619130144.GA9043@bfoster.bfoster>
References: <1403156032-18525-1-git-send-email-david@fromorbit.com>
	<1403156032-18525-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1403156032-18525-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 19, 2014 at 03:33:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> v5 superblock supports many more than 25 ACLs on an inode, but
> xfs_repair still thinks that the maximum is 25. Fix it and update
> the ACL definitions to match the kernel definitions. Also fix the
> remote attr maximum size off-by-one that the maximum number of v5
> ACLs tickles.
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

This mostly looks good to me, though it seems like it could at least
split into a couple patches. A minor question below...

>  libxfs/xfs_attr_remote.c |  2 +-
>  repair/attr_repair.c     | 74 ++++++++++++++++++++++++++++++++----------------
>  repair/attr_repair.h     | 46 +++++++++++++++++++++---------
>  3 files changed, 84 insertions(+), 38 deletions(-)
> 
> diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
> index 5cf5c73..08b983b 100644
> --- a/libxfs/xfs_attr_remote.c
> +++ b/libxfs/xfs_attr_remote.c
> @@ -85,7 +85,7 @@ xfs_attr3_rmt_verify(
>  	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
>  		return false;
>  	if (be32_to_cpu(rmt->rm_offset) +
> -				be32_to_cpu(rmt->rm_bytes) >= XATTR_SIZE_MAX)
> +				be32_to_cpu(rmt->rm_bytes) > XATTR_SIZE_MAX)

Corresponds to kernel commit:

bba719b5 xfs: fix off-by-one error in xfs_attr3_rmt_verify

>  		return false;
>  	if (rmt->rm_owner == 0)
>  		return false;
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 5dd7e5f..87d3b0a 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -25,7 +25,7 @@
>  #include "protos.h"
>  #include "dir2.h"
>  
> -static int xfs_acl_valid(xfs_acl_disk_t *daclp);
> +static int xfs_acl_valid(struct xfs_mount *mp, struct xfs_acl *daclp);
>  static int xfs_mac_valid(xfs_mac_label_t *lp);
>  
>  /*
> @@ -734,11 +734,15 @@ verify_da_path(xfs_mount_t	*mp,
>   * If value is non-zero, then a remote attribute is being passed in
>   */
>  static int
> -valuecheck(char *namevalue, char *value, int namelen, int valuelen)
> +valuecheck(
> +	struct xfs_mount *mp,
> +	char		*namevalue,
> +	char		*value,
> +	int		namelen,
> +	int		valuelen)
>  {
>  	/* for proper alignment issues, get the structs and memmove the values */
>  	xfs_mac_label_t macl;
> -	xfs_acl_t thisacl;
>  	void *valuep;
>  	int clearit = 0;
>  
> @@ -746,18 +750,23 @@ valuecheck(char *namevalue, char *value, int namelen, int valuelen)
>  			(strncmp(namevalue, SGI_ACL_DEFAULT,
>  				SGI_ACL_DEFAULT_SIZE) == 0)) {
>  		if (value == NULL) {
> -			memset(&thisacl, 0, sizeof(xfs_acl_t));
> -			memmove(&thisacl, namevalue+namelen, valuelen);
> -			valuep = &thisacl;
> +			valuep = malloc(valuelen);
> +			if (!valuep)
> +				do_error(_("No memory for ACL check!\n"));
> +			memcpy(valuep, namevalue + namelen, valuelen);
>  		} else
>  			valuep = value;
>  
> -		if (xfs_acl_valid((xfs_acl_disk_t *)valuep) != 0) {
> +		if (xfs_acl_valid(mp, valuep) != 0) {
>  			clearit = 1;
>  			do_warn(
>  	_("entry contains illegal value in attribute named SGI_ACL_FILE "
>  	  "or SGI_ACL_DEFAULT\n"));
>  		}
> +
> +		if (valuep != value)
> +			free(valuep);
> +
>  	} else if (strncmp(namevalue, SGI_MAC_FILE, SGI_MAC_FILE_SIZE) == 0) {
>  		if (value == NULL) {
>  			memset(&macl, 0, sizeof(xfs_mac_label_t));
> @@ -800,6 +809,7 @@ valuecheck(char *namevalue, char *value, int namelen, int valuelen)
>   */
>  static int
>  process_shortform_attr(
> +	struct xfs_mount *mp,
>  	xfs_ino_t	ino,
>  	xfs_dinode_t	*dip,
>  	int		*repair)
> @@ -904,7 +914,7 @@ process_shortform_attr(
>  
>  		/* Only check values for root security attributes */
>  		if (currententry->flags & XFS_ATTR_ROOT)
> -		       junkit = valuecheck((char *)&currententry->nameval[0],
> +		       junkit = valuecheck(mp, (char *)&currententry->nameval[0],
>  					NULL, currententry->namelen, 
>  					currententry->valuelen);
>  
> @@ -1039,6 +1049,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  
>  static int
>  process_leaf_attr_local(
> +	struct xfs_mount	*mp,
>  	xfs_attr_leafblock_t	*leaf,
>  	int			i,
>  	xfs_attr_leaf_entry_t	*entry,
> @@ -1076,7 +1087,7 @@ process_leaf_attr_local(
>  
>  	/* Only check values for root security attributes */
>  	if (entry->flags & XFS_ATTR_ROOT) {
> -		if (valuecheck((char *)&local->nameval[0], NULL, 
> +		if (valuecheck(mp, (char *)&local->nameval[0], NULL, 
>  				local->namelen, be16_to_cpu(local->valuelen))) {
>  			do_warn(
>  	_("bad security value for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
> @@ -1134,7 +1145,7 @@ process_leaf_attr_remote(
>  			i, ino);
>  		goto bad_free_out;
>  	}
> -	if (valuecheck((char *)&remotep->name[0], value, remotep->namelen,
> +	if (valuecheck(mp, (char *)&remotep->name[0], value, remotep->namelen,
>  				be32_to_cpu(remotep->valuelen))) {
>  		do_warn(
>  	_("remote attribute value check failed for entry %d, inode %" PRIu64 "\n"),
> @@ -1216,15 +1227,15 @@ process_leaf_attr_block(
>  			break;	/* got an overlap */
>  		}
>  
> -		if (entry->flags & XFS_ATTR_LOCAL) 
> -			thissize = process_leaf_attr_local(leaf, i, entry,
> +		if (entry->flags & XFS_ATTR_LOCAL)
> +			thissize = process_leaf_attr_local(mp, leaf, i, entry,
>  						last_hashval, da_bno, ino);
>  		else
>  			thissize = process_leaf_attr_remote(leaf, i, entry,
>  						last_hashval, da_bno, ino,
>  						mp, blkmap);
>  		if (thissize < 0) {
> -			clearit = 1;				
> +			clearit = 1;
>  			break;
>  		}
>  
> @@ -1608,15 +1619,19 @@ process_longform_attr(
>  
>  
>  static int
> -xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
> +xfs_acl_from_disk(
> +	struct xfs_mount	*mp,
> +	struct xfs_icacl	**aclp,
> +	struct xfs_acl		*dacl)
>  {
>  	int			count;
> -	xfs_acl_t		*acl;
> -	xfs_acl_entry_t 	*ace;
> -	xfs_acl_entry_disk_t	*dace, *end;
> +	int			size;
> +	struct xfs_icacl	*acl;
> +	struct xfs_icacl_entry	*ace;
> +	struct xfs_acl_entry	*dace, *end;
>  
>  	count = be32_to_cpu(dacl->acl_cnt);
> -	if (count > XFS_ACL_MAX_ENTRIES) {
> +	if (count > XFS_ACL_MAX_ENTRIES(mp)) {
>  		do_warn(_("Too many ACL entries, count %d\n"), count);
>  		*aclp = NULL;
>  		return EINVAL;
> @@ -1624,7 +1639,16 @@ xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
>  
>  
>  	end = &dacl->acl_entry[0] + count;
> -	acl = malloc((int)((char *)end - (char *)dacl));
> +	size = sizeof(dacl->acl_cnt) + (count * sizeof(struct xfs_acl_entry));
> +	if (size != (int)((char *)end - (char *)dacl)) {
> +		do_warn(_("ACL count (%d) does not match buffer size (%d/%d)\n"),
> +			  count, size, (int)((char *)end - (char *)dacl));
> +		*aclp = NULL;
> +		return EINVAL;
> +	}

This size check seems superfluous. In what scenario could it fail?

> +
> +	acl = malloc(sizeof(struct xfs_icacl) +
> +		     count * sizeof(struct xfs_icacl_entry));
>  	if (!acl) {
>  		do_warn(_("cannot malloc enough for ACL attribute\n"));
>  		do_warn(_("SKIPPING this ACL\n"));
> @@ -1667,7 +1691,7 @@ process_attributes(
>  	if (aformat == XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(be16_to_cpu(asf->hdr.totsize) <=
>  			XFS_DFORK_ASIZE(dip, mp));
> -		err = process_shortform_attr(ino, dip, repair);
> +		err = process_shortform_attr(mp, ino, dip, repair);
>  	} else if (aformat == XFS_DINODE_FMT_EXTENTS ||
>  					aformat == XFS_DINODE_FMT_BTREE)  {
>  			err = process_longform_attr(mp, ino, dip, blkmap,
> @@ -1686,17 +1710,19 @@ process_attributes(
>   * Validate an ACL
>   */
>  static int
> -xfs_acl_valid(xfs_acl_disk_t *daclp)
> +xfs_acl_valid(
> +	struct xfs_mount *mp,
> +	struct xfs_acl	*daclp)
>  {
> -	xfs_acl_t	*aclp = NULL;
> -	xfs_acl_entry_t *entry, *e;
> +	struct xfs_icacl	*aclp = NULL;
> +	struct xfs_icacl_entry	*entry, *e;
>  	int user = 0, group = 0, other = 0, mask = 0, mask_required = 0;
>  	int i, j;
>  
>  	if (daclp == NULL)
>  		goto acl_invalid;
>  
> -	switch (xfs_acl_from_disk(&aclp, daclp)) {
> +	switch (xfs_acl_from_disk(mp, &aclp, daclp)) {
>  	case ENOMEM:
>  		return 0;
>  	case EINVAL:
> diff --git a/repair/attr_repair.h b/repair/attr_repair.h
> index f42536a..0d0c62c 100644
> --- a/repair/attr_repair.h
> +++ b/repair/attr_repair.h
> @@ -37,29 +37,49 @@ typedef __int32_t	xfs_acl_type_t;
>  typedef __int32_t	xfs_acl_tag_t;
>  typedef __int32_t	xfs_acl_id_t;
>  
> -typedef struct xfs_acl_entry {
> +/*
> + * "icacl" = in-core ACL. There is no equivalent in the XFS kernel code,
> + * so they are magic names just for repair. The "acl" types are what the kernel
> + * code uses for the on-disk format names, so use them here too for the on-disk
> + * ACL format definitions.
> + */
> +struct xfs_icacl_entry {
>  	xfs_acl_tag_t	ae_tag;
>  	xfs_acl_id_t	ae_id;
>  	xfs_acl_perm_t	ae_perm;
> -} xfs_acl_entry_t;
> +};
>  
> -#define XFS_ACL_MAX_ENTRIES	25
> -typedef struct xfs_acl {
> -	__int32_t	acl_cnt;
> -	xfs_acl_entry_t	acl_entry[XFS_ACL_MAX_ENTRIES];
> -} xfs_acl_t;
> +struct xfs_icacl {
> +	__int32_t		acl_cnt;
> +	struct xfs_icacl_entry	acl_entry[0];
> +};
>  
> -typedef struct xfs_acl_entry_disk {
> +struct xfs_acl_entry {
>  	__be32		ae_tag;
>  	__be32		ae_id;
>  	__be16		ae_perm;
> -} xfs_acl_entry_disk_t;
> +	__be16		ae_pad;
> +};
>  
> -typedef struct xfs_acl_disk {
> -	__be32		acl_cnt;
> -	xfs_acl_entry_disk_t	acl_entry[XFS_ACL_MAX_ENTRIES];
> -} xfs_acl_disk_t;
> +struct xfs_acl {
> +	__be32			acl_cnt;
> +	struct xfs_acl_entry	acl_entry[0];
> +};
>  
> +/*
> + * The number of ACL entries allowed is defined by the on-disk format.
> + * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
> + * limited only by the maximum size of the xattr that stores the information.
> + */
> +#define XFS_ACL_MAX_ENTRIES(mp) \
> +	(xfs_sb_version_hascrc(&mp->m_sb) \
> +		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
> +						sizeof(struct xfs_acl_entry) \
> +		: 25)
> +
> +#define XFS_ACL_MAX_SIZE(mp) \
> +	(sizeof(struct xfs_acl) + \
> +		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
>  

Mostly corresponds to kernel commit:

0a8aa193 xfs: increase number of ACL entries for V5 superblocks

Brian

>  #define SGI_ACL_FILE	"SGI_ACL_FILE"
>  #define SGI_ACL_DEFAULT	"SGI_ACL_DEFAULT"
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
