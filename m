Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31442 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753278AbdKVWts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 17:49:48 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAMMnlpo009206
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 22:49:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAMMnkHU015405
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 22:49:47 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAMMnkOL000558
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 22:49:46 GMT
Subject: Re: [PATCH v3 17/17] Add parent pointer ioctl
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-18-git-send-email-allison.henderson@oracle.com>
 <f66c6448-60c8-884a-d9d0-43d3018deece@oracle.com>
 <20171122211352.GK2135@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <dbc2d346-9b99-25dc-0c85-2c638ae122d5@oracle.com>
Date: Wed, 22 Nov 2017 15:49:45 -0700
MIME-Version: 1.0
In-Reply-To: <20171122211352.GK2135@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 11/22/2017 02:13 PM, Darrick J. Wong wrote:

> On Wed, Nov 22, 2017 at 12:54:45PM -0700, Allison Henderson wrote:
>> On 11/17/2017 11:21 AM, Allison Henderson wrote:
>>
>>> This patch adds a new file ioctl to retrieve the parent
>>> pointer of a given inode
>>>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>   fs/xfs/libxfs/xfs_fs.h   |  1 +
>>>   fs/xfs/xfs_attr.h        |  2 ++
>>>   fs/xfs/xfs_attr_list.c   |  3 +++
>>>   fs/xfs/xfs_ioctl.c       | 48 +++++++++++++++++++++++++++++++++-
>>>   5 files changed, 120 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index 9d4d883..d2be842 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -134,6 +134,73 @@ xfs_attr_get_ilocked(
>>>   		return xfs_attr_node_get(args);
>>>   }
>>> +/*
>>> + * Get the parent pointer for a given inode
>>> + * Caller will need to allocate a buffer pointed to by xpnir->p_name
>>> + * and store the buffer size in xpnir->p_namelen.  The parent
>>> + * pointer will be stored in the given xfs_parent_name_irec
>>> + *
>>> + * Returns 0 on success and non zero on error
>>> + */
>>> +int
>>> +xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
>>> +			    struct xfs_parent_name_irec *xpnir)
>>> +{
>>> +	struct attrlist			*alist;
>>> +	struct attrlist_ent		*aent;
>>> +	struct attrlist_cursor_kern     cursor;
>>> +	struct xfs_parent_name_rec	*xpnr;
>>> +	char				*namebuf;
>>> +	int                             error = 0;
>>> +	unsigned int                    flags = ATTR_PARENT;
>>> +
>>> +	/* Allocate a buffer to store the attribute names */
>>> +	namebuf = kmem_zalloc_large(XFS_XATTR_LIST_MAX, KM_SLEEP);
>>> +	if (!namebuf)
>>> +		return -ENOMEM;
>>> +
>>> +	/* Get all attribute names that have the ATTR_PARENT flag */
>>> +	memset(&cursor, 0, sizeof(struct attrlist_cursor_kern));
>>> +	error = xfs_attr_list(ip, namebuf, XFS_XATTR_LIST_MAX, flags, &cursor);
>>> +	if (error)
>>> +		goto out_kfree;
>>> +
>>> +	alist = (struct attrlist *)namebuf;
>>> +
>>> +	/* There should never be more than one parent pointer */
>>> +	ASSERT(alist->al_count == 1);
> /me wonders, does this handle hardlinked files correctly?
Good question, I will try it out and maybe revise this area a bit. Maybe 
we need to be returning more than one parent pointer
>
>>> +	aent = (struct attrlist_ent *) &namebuf[alist->al_offset[0]];
>>> +	xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
>>> +
>>> +	/*
>>> +	 * The value of the parent pointer attribute should be the file name
>>> +	 * So we check the value length of the attribute entry against the name
>>> +	 * length of the parent name record to make sure the caller gave enough
>>> +	 * buffer space to store the file name (plus a null terminator)
>>> +	 */
>>> +	if (aent->a_valuelen >= xpnir->p_namelen) {
>>> +		error = -ERANGE;
>>> +		goto out_kfree;
>>> +	}
>>> +
>>> +	xpnir->p_namelen = aent->a_valuelen + 1;
>>> +	memset((void *)(xpnir->p_name), 0, xpnir->p_namelen);
>>> +	error = xfs_attr_get(ip, (char *)xpnr,
>>> +			     sizeof(struct xfs_parent_name_rec),
>>> +			     (unsigned char *)(xpnir->p_name),
>>> +			     (int *)&(xpnir->p_namelen), flags);
>>> +	if (error)
>>> +		goto out_kfree;
>>> +
>>> +	xfs_init_parent_name_irec(xpnir, xpnr);
>>> +
>>> +out_kfree:
>>> +	kmem_free(namebuf);
>>> +
>>> +	return error;
>>> +}
>> I was thinking of moving this function else where.  It seems to generate a
>> lot of compile issues when I apply it to xfsprogs because of the things it
>> needs from xfs_attr.h.
> note: i forget what this function does exactly. :/
It just picks out the name tuple from the parent pointer attribute and 
and uses it to look up the attribute value (the file name).  All that 
gets stored in the xfs_parent_name_irec that the callers passes in.
>
> Heh.  Yeah, you might need to split the parent pointer code into
> fs/xfs/libxfs/xfs_parent_ptr.c that handles all the internal work and a
> fs/xfs/xfs_parent.c that glues the kernel to libxfs, similar to how the
> directory code is split up.
>
> IOWs, fs/xfs/libxfs/xfs_parent_ptr.c has routines to set/clear
> xfs_parent_irec structures by modifying xattr data as appropriate; and
> iterate all the theoretical xfs_parent_irecs based on what's in the
> xattr data.
>
> fs/xfs/xfs_parent.c then has all the glue code to connect the iterator
> interface to ioctls, etc.
Yeah, I may need to revisit some of that as I go about putting together 
what I need for new xfstests then
>> Generally are patches to code in fs/xfs/libxfs not supposed to be
>> including things outside libxfs?
> You'd think so, but yesno. :P
>
> In general we'd prefer libxfs to be as self-contained as possible so
> that xfsprogs/kernel have exactly the same libxfs code.  OTOH the
> practical reality of both libxfs's is that they sometimes need things
> that are defined outside of libxfs.
>
> That said, I'll now undercut my own point by noting that libxfs is
> really just common code shared between the two codebases that want it.
>
>> Do I need to revise the series to avoid doing that? Thanks!
> So it's not a hard and fast rule, just more of a "minimize the libxfs
> dependencies on the outer world" thing.
>
> (Those outer world things force Eric to fix them up in whatever
> odd way xfsprogs needs because it's userspace.)
>
> --D
Alrighty, I'll try to keep everything as much as possible.  Thanks all!

Allison

>> Allison
>>> +
>>>   /* Retrieve an extended attribute by name, and its value. */
>>>   int
>>>   xfs_attr_get(
>>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>>> index b8108f8..2f9ca2c 100644
>>> --- a/fs/xfs/libxfs/xfs_fs.h
>>> +++ b/fs/xfs/libxfs/xfs_fs.h
>>> @@ -512,6 +512,7 @@ typedef struct xfs_swapext
>>>   #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
>>>   #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
>>>   /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
>>> +#define XFS_IOC_GETPPOINTER	_IOR ('X', 61, struct xfs_parent_name_irec)
>>>   /*
>>>    * ioctl commands that replace IRIX syssgi()'s
>>> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
>>> index 0829687..0ec3458 100644
>>> --- a/fs/xfs/xfs_attr.h
>>> +++ b/fs/xfs/xfs_attr.h
>>> @@ -172,6 +172,8 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>>>   		int flags);
>>>   int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>>>   		size_t namelen, unsigned char *value, int valuelen, int flags);
>>> +int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
>>> +				struct xfs_parent_name_irec *xpnir);
>>>   int xfs_attr_set_args(struct xfs_da_args *args, int flags, bool roll_trans);
>>>   int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
>>>   		size_t namelen, int flags);
>>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>>> index 7740c8a..78fc477 100644
>>> --- a/fs/xfs/xfs_attr_list.c
>>> +++ b/fs/xfs/xfs_attr_list.c
>>> @@ -534,6 +534,9 @@ xfs_attr_put_listent(
>>>   	if (((context->flags & ATTR_ROOT) == 0) !=
>>>   	    ((flags & XFS_ATTR_ROOT) == 0))
>>>   		return;
>>> +	if (((context->flags & ATTR_PARENT) == 0) !=
>>> +	    ((flags & XFS_ATTR_PARENT) == 0))
>>> +		return;
>>>   	arraytop = sizeof(*alist) +
>>>   			context->count * sizeof(alist->al_offset[0]);
>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>> index 4664314..5492607 100644
>>> --- a/fs/xfs/xfs_ioctl.c
>>> +++ b/fs/xfs/xfs_ioctl.c
>>> @@ -44,6 +44,7 @@
>>>   #include "xfs_btree.h"
>>>   #include <linux/fsmap.h>
>>>   #include "xfs_fsmap.h"
>>> +#include "xfs_attr.h"
>>>   #include <linux/capability.h>
>>>   #include <linux/cred.h>
>>> @@ -1710,6 +1711,50 @@ xfs_ioc_getfsmap(
>>>   	return 0;
>>>   }
>>> +/*
>>> + * IOCTL routine to get the parent pointer of an inode and return it to user
>>> + * space.  Caller must pass an struct xfs_parent_name_irec with a name buffer
>>> + * large enough to hold the file name.  Returns 0 on success or non-zero on
>>> + * failure
>>> + */
>>> +STATIC int
>>> +xfs_ioc_get_parent_pointer(
>>> +	struct file			*filp,
>>> +	void				__user *arg)
>>> +{
>>> +	struct inode			*inode = file_inode(filp);
>>> +	struct xfs_inode		*ip = XFS_I(inode);
>>> +	struct xfs_parent_name_irec	xpnir;
>>> +	char				*uname;
>>> +	char				*kname;
>>> +	int				error = 0;
>>> +
>>> +	copy_from_user(&xpnir, arg, sizeof(struct xfs_parent_name_irec));
>>> +	uname = (char *)xpnir.p_name;
>>> +
>>> +	/*
>>> +	 * Use kernel space memory to get the parent pointer name.
>>> +	 * We'll copy it to the user space name back when we're done
>>> +	 */
>>> +	kname = kmem_zalloc_large(xpnir.p_namelen, KM_SLEEP);
>>> +	if (!kname)
>>> +		return -ENOMEM;
>>> +
>>> +	xpnir.p_name = kname;
>>> +	error = xfs_attr_get_parent_pointer(ip, &xpnir);
>>> +
>>> +	if (error)
>>> +		goto out;
>>> +
>>> +	copy_to_user(uname, xpnir.p_name, xpnir.p_namelen);
>>> +	xpnir.p_name = uname;
>>> +	copy_to_user(arg, &xpnir, sizeof(struct xfs_parent_name_irec));
>>> +
>>> +out:
>>> +	kmem_free(kname);
>>> +	return error;
>>> +}
>>> +
>>>   int
>>>   xfs_ioc_swapext(
>>>   	xfs_swapext_t	*sxp)
>>> @@ -1866,7 +1911,8 @@ xfs_file_ioctl(
>>>   		return xfs_ioc_getxflags(ip, arg);
>>>   	case XFS_IOC_SETXFLAGS:
>>>   		return xfs_ioc_setxflags(ip, filp, arg);
>>> -
>>> +	case XFS_IOC_GETPPOINTER:
>>> +		return xfs_ioc_get_parent_pointer(filp, arg);
>>>   	case XFS_IOC_FSSETDM: {
>>>   		struct fsdmidata	dmi;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIDAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=G7N7y48j4ogYpf2u666QU1bTWEMPTiSyJA2qT5hBpkQ&s=OJkTAOSkzCECkmU6FhK-vc77mLJpqb65wuKPpdpCGSA&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIDAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=G7N7y48j4ogYpf2u666QU1bTWEMPTiSyJA2qT5hBpkQ&s=OJkTAOSkzCECkmU6FhK-vc77mLJpqb65wuKPpdpCGSA&e=

