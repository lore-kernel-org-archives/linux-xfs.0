Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42190 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbdK2Swj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:52:39 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vATIqcLU031420
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:52:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vATIqceY013381
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:52:38 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vATIqbID032359
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:52:38 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 17/17] Add parent pointer ioctl
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-18-git-send-email-allison.henderson@oracle.com>
 <20171128203537.GZ21412@magnolia>
Message-ID: <13a1961e-73c5-4e1b-0583-4faf637102b9@oracle.com>
Date: Wed, 29 Nov 2017 11:52:36 -0700
MIME-Version: 1.0
In-Reply-To: <20171128203537.GZ21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/2017 01:35 PM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:45AM -0700, Allison Henderson wrote:
>> This patch adds a new file ioctl to retrieve the parent
>> pointer of a given inode
>>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_fs.h   |  1 +
>>   fs/xfs/xfs_attr.h        |  2 ++
>>   fs/xfs/xfs_attr_list.c   |  3 +++
>>   fs/xfs/xfs_ioctl.c       | 48 +++++++++++++++++++++++++++++++++-
>>   5 files changed, 120 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9d4d883..d2be842 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -134,6 +134,73 @@ xfs_attr_get_ilocked(
>>   		return xfs_attr_node_get(args);
>>   }
>>   
>> +/*
>> + * Get the parent pointer for a given inode
>> + * Caller will need to allocate a buffer pointed to by xpnir->p_name
>> + * and store the buffer size in xpnir->p_namelen.  The parent
>> + * pointer will be stored in the given xfs_parent_name_irec
>> + *
>> + * Returns 0 on success and non zero on error
>> + */
>> +int
>> +xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
>> +			    struct xfs_parent_name_irec *xpnir)
> Please fix the parameter list here.
>
>> +{
>> +	struct attrlist			*alist;
>> +	struct attrlist_ent		*aent;
>> +	struct attrlist_cursor_kern     cursor;
>> +	struct xfs_parent_name_rec	*xpnr;
>> +	char				*namebuf;
>> +	int                             error = 0;
>> +	unsigned int                    flags = ATTR_PARENT;
>> +
>> +	/* Allocate a buffer to store the attribute names */
>> +	namebuf = kmem_zalloc_large(XFS_XATTR_LIST_MAX, KM_SLEEP);
>> +	if (!namebuf)
>> +		return -ENOMEM;
>> +
>> +	/* Get all attribute names that have the ATTR_PARENT flag */
>> +	memset(&cursor, 0, sizeof(struct attrlist_cursor_kern));
>> +	error = xfs_attr_list(ip, namebuf, XFS_XATTR_LIST_MAX, flags, &cursor);
>> +	if (error)
>> +		goto out_kfree;
>> +
>> +	alist = (struct attrlist *)namebuf;
>> +
>> +	/* There should never be more than one parent pointer */
>> +	ASSERT(alist->al_count == 1);
> As mentioned earlier, this is not true.  Files can have multiple parents.
>
>> +	aent = (struct attrlist_ent *) &namebuf[alist->al_offset[0]];
>> +	xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
>> +
>> +	/*
>> +	 * The value of the parent pointer attribute should be the file name
>> +	 * So we check the value length of the attribute entry against the name
>> +	 * length of the parent name record to make sure the caller gave enough
>> +	 * buffer space to store the file name (plus a null terminator)
>> +	 */
>> +	if (aent->a_valuelen >= xpnir->p_namelen) {
>> +		error = -ERANGE;
>> +		goto out_kfree;
>> +	}
>> +
>> +	xpnir->p_namelen = aent->a_valuelen + 1;
>> +	memset((void *)(xpnir->p_name), 0, xpnir->p_namelen);
>> +	error = xfs_attr_get(ip, (char *)xpnr,
>> +			     sizeof(struct xfs_parent_name_rec),
>> +			     (unsigned char *)(xpnir->p_name),
>> +			     (int *)&(xpnir->p_namelen), flags);
>> +	if (error)
>> +		goto out_kfree;
>> +
>> +	xfs_init_parent_name_irec(xpnir, xpnr);
>> +
>> +out_kfree:
>> +	kmem_free(namebuf);
>> +
>> +	return error;
>> +}
>> +
>>   /* Retrieve an extended attribute by name, and its value. */
>>   int
>>   xfs_attr_get(
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index b8108f8..2f9ca2c 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -512,6 +512,7 @@ typedef struct xfs_swapext
>>   #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
>>   #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
>>   /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
>> +#define XFS_IOC_GETPPOINTER	_IOR ('X', 61, struct xfs_parent_name_irec)
> I don't think it's a good idea to expose internal data structures
> directly to userspace, because that inhibits our ability to change the
> in-core data structure.
Yes, this part I already have that separated in my local copy
> Furthermore, hardlinked files can have multiple parent pointers, so it's
> not going to suffice to return a single parent pointer entry.  Given
> that there can be potentially 2^32 parents, we're going to need a data
> structure for the ioctl to store (in an opaque manner) the attribute
> iteration cursor and have space to pass back some number of parent
> pointers.
>
> (Yes, it's time to start talking about actual use cases...)
>
> At a bare minimum, this is what I pictured for the "return parents of
> the open file" ioctl:
>
> #define XFS_PPTR_MAXNAMELEN		255
>
> struct xfs_pptr {
> 	u64				pp_ino;
> 	u32				pp_gen;
> 	u8				pp_namelen;
> 	u8				pp_name[XFS_PPTR_MAXNAMELEN];
> };
>
> /* return parents of the handle, instead of the open fd */
> #define XFS_PPTR_FLAG_HANDLE		(1u << 0)
>
> struct xfs_pptr_info {
> 	struct xfs_fsop_handlereq	pi_handle;
> 	struct xfs_attrlist_cursor	pi_cursor;
> 	u32				pi_flags;
> 	u32				pi_reserved;
> 	u32				pi_ptrs_size;
> 	u32				pi_ptrs_used;
> 	u64				pi_reserved2[6];
> 	struct xfs_pptr			pi_ptrs[0];
> };
>
> #define XFS_PPTR_INFO_SIZEOF(ptrs)	(sizeof(struct xfs_pptr_info) + \
> 					((ptrs) * sizeof(struct xfs_pptr)));
>
> static inline struct xfs_pptr_info *
> xfs_pptr_alloc(
> 	size_t			nr_ptrs)
> {
> 	struct xfs_pptr_info	*ppi;
>
> 	ppi = malloc(XFS_PPTR_INFO_SIZEOF(nr_ptrs));
> 	if (!ppi)
> 		return NULL;
> 	memset(ppi, 0, XFS_PPTR_INFO_SIZEOF(nr_ptrs));
> 	ppi->pi_ptrs_size = nr_ptrs;
> 	return ppi;
> }
>
> With the following example userspace program (that does no checking
> whatsoever):
>
> int main(int argc, char *argv[])
> {
> 	struct xfs_pptr_info	*ppi;
> 	struct xfs_pptr		*pp;
> 	int			fd;
>
> 	fd = open(argv[1], O_RDONLY);
> 	ppi = xfs_pptr_alloc(32);
>
> 	while (ioctl(fd, XFS_IOC_GETPPOINTER, ppi) == 0 && ppi->pi_ptrs_used) {
> 		for (i = 0; i < ppi->pi_ptrs_used; i++) {
> 			printf("%llu:%u -> %s\n",
> 					ppi->pi_ptrs[i].pp_ino,
> 					ppi->pi_ptrs[i].pp_gen,
> 					ppi->pi_ptrs[i].pp_name);
> 		}
> 	}
> }
>
> Notice here how we the userspace structure contains an opaque attribute
> list cursor, so we can keep coming back for more parent pointers until
> we run out of xattrs (and pi_ptrs_used == 0).  The kernel will copy its
> internal cursor out to the userspace buffer as an opaque cookie prior to
> returning.
>
>  From this simple implementation it shouldn't be difficult to finish the
> parents_by_handle/parentpaths_by_handle functions in libhandle, though
> given that they've never been implemented in Linux and we no longer care
> about Irix, you've some flexibility to change those library functions if
> that is convenient for setting up xfstests.
Wow, ok that makes a lot of sense. I will follow your model here and get 
it fleshed out.  Thank you!
> Speaking of xfstests... what are the initial test cases?  I figured at
> least the following:
>
> 0) mkfs with protofile, make sure the parent records get created
> 1) create file, check parent records
> 2) hardlink file, check both parent records
> 3) delete one link of a hardlinked file, check parent records
> 4) hardlink a file a few thousand times, check that the iteration
>     scheme laid out above actually works
> 5) rename a file within a directory, check the parent records
> 6) rename a file across directories, check the parent records
> 7) some sort of testing where we run out of space while updating pptrs
> 8) add some error injection knobs to make sure that pptr replay actually
>     works correctly
>
> Can you think of other test cases?
I think that is a good start.  This looks similar to what I've been 
doing by hand to stabilize things as I go along.  I'll have to work on 
developing an inject knob for the last one.
> For xfs_scrub, we want to be able to query the parents of any (damaged)
> inode we find in the filesystem.  If the inode is so damaged we can't
> open it (or it's a special file) then scrub has to construct a file
> handle and pass that in via pi_handle.
Alrighty, I will take a look at those routines and see if I can put 
together something that reconstructs the parent pointers with out 
opening the inode
> I /also/ wonder if there's any interest in having a fallback for
> non-pptr filesystems that walks the dentry->d_parent links (like
> d_paths() does) back to the root.  Such a fallback will only work on an
> opened dir or a file opened by path (i.e. not a handle), however, which
> limits its appeal.
>
> --D
You mean a way to get the parent pointer even if they chose not to 
enable the feature flag?  I think its something we could investigate, 
but I think you're right in that the limitations might not make it quite 
as valuable.  IMHO I think maybe getting the full version working first 
might give people a chance to appreciate what it can do, and if it turns 
out to be something that people end up using a lot, then it might 
generate more demand for the "light" version. :-)
>>   /*
>>    * ioctl commands that replace IRIX syssgi()'s
>> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
>> index 0829687..0ec3458 100644
>> --- a/fs/xfs/xfs_attr.h
>> +++ b/fs/xfs/xfs_attr.h
>> @@ -172,6 +172,8 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>>   		int flags);
>>   int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>>   		size_t namelen, unsigned char *value, int valuelen, int flags);
>> +int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
>> +				struct xfs_parent_name_irec *xpnir);
>>   int xfs_attr_set_args(struct xfs_da_args *args, int flags, bool roll_trans);
>>   int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
>>   		size_t namelen, int flags);
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 7740c8a..78fc477 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -534,6 +534,9 @@ xfs_attr_put_listent(
>>   	if (((context->flags & ATTR_ROOT) == 0) !=
>>   	    ((flags & XFS_ATTR_ROOT) == 0))
>>   		return;
>> +	if (((context->flags & ATTR_PARENT) == 0) !=
>> +	    ((flags & XFS_ATTR_PARENT) == 0))
>> +		return;
>>   
>>   	arraytop = sizeof(*alist) +
>>   			context->count * sizeof(alist->al_offset[0]);
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 4664314..5492607 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -44,6 +44,7 @@
>>   #include "xfs_btree.h"
>>   #include <linux/fsmap.h>
>>   #include "xfs_fsmap.h"
>> +#include "xfs_attr.h"
>>   
>>   #include <linux/capability.h>
>>   #include <linux/cred.h>
>> @@ -1710,6 +1711,50 @@ xfs_ioc_getfsmap(
>>   	return 0;
>>   }
>>   
>> +/*
>> + * IOCTL routine to get the parent pointer of an inode and return it to user
>> + * space.  Caller must pass an struct xfs_parent_name_irec with a name buffer
>> + * large enough to hold the file name.  Returns 0 on success or non-zero on
>> + * failure
>> + */
>> +STATIC int
>> +xfs_ioc_get_parent_pointer(
>> +	struct file			*filp,
>> +	void				__user *arg)
>> +{
>> +	struct inode			*inode = file_inode(filp);
>> +	struct xfs_inode		*ip = XFS_I(inode);
>> +	struct xfs_parent_name_irec	xpnir;
>> +	char				*uname;
>> +	char				*kname;
>> +	int				error = 0;
>> +
>> +	copy_from_user(&xpnir, arg, sizeof(struct xfs_parent_name_irec));
>> +	uname = (char *)xpnir.p_name;
>> +
>> +	/*
>> +	 * Use kernel space memory to get the parent pointer name.
>> +	 * We'll copy it to the user space name back when we're done
>> +	 */
>> +	kname = kmem_zalloc_large(xpnir.p_namelen, KM_SLEEP);
> Please sanity-check the amount of memory we try to allocate.
>
>> +	if (!kname)
>> +		return -ENOMEM;
>> +
>> +	xpnir.p_name = kname;
>> +	error = xfs_attr_get_parent_pointer(ip, &xpnir);
>> +
>> +	if (error)
>> +		goto out;
>> +
>> +	copy_to_user(uname, xpnir.p_name, xpnir.p_namelen);
>> +	xpnir.p_name = uname;
>> +	copy_to_user(arg, &xpnir, sizeof(struct xfs_parent_name_irec));
>> +
>> +out:
>> +	kmem_free(kname);
>> +	return error;
>> +}
>> +
>>   int
>>   xfs_ioc_swapext(
>>   	xfs_swapext_t	*sxp)
>> @@ -1866,7 +1911,8 @@ xfs_file_ioctl(
>>   		return xfs_ioc_getxflags(ip, arg);
>>   	case XFS_IOC_SETXFLAGS:
>>   		return xfs_ioc_setxflags(ip, filp, arg);
>> -
>> +	case XFS_IOC_GETPPOINTER:
>> +		return xfs_ioc_get_parent_pointer(filp, arg);
>>   	case XFS_IOC_FSSETDM: {
>>   		struct fsdmidata	dmi;
>>   
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=4f7DOEYDfWf_ZRdBfE0cU7L0QfDJjKolv1tc2HeLeck&s=6K6iOFwNgQv30L_9mpWjoAPsnvxojOglPp6hADhWRb8&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=4f7DOEYDfWf_ZRdBfE0cU7L0QfDJjKolv1tc2HeLeck&s=6K6iOFwNgQv30L_9mpWjoAPsnvxojOglPp6hADhWRb8&e=

