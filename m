Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31397 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753028AbdKVWta (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 17:49:30 -0500
Subject: Re: [PATCH v3 17/17] Add parent pointer ioctl
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-18-git-send-email-allison.henderson@oracle.com>
 <f66c6448-60c8-884a-d9d0-43d3018deece@oracle.com>
 <20171122210744.GS5858@dastard>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a9ace24a-8735-8600-6982-79bc89adf8c4@oracle.com>
Date: Wed, 22 Nov 2017 15:49:25 -0700
MIME-Version: 1.0
In-Reply-To: <20171122210744.GS5858@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 11/22/2017 02:07 PM, Dave Chinner wrote:

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
>>> +
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
>> I was thinking of moving this function else where.  It seems to
>> generate a lot of compile issues when I apply it to xfsprogs because
>> of the things it needs from xfs_attr.h.  Generally are patches to
>> code in fs/xfs/libxfs not supposed to be including things outside
>> libxfs?  Do I need to revise the series to avoid doing that? Thanks!
> In general, yes. More complex than that (e.g. userspace and kernel
> have separate definitions of some structures like xfs_mount,
> xfs_buf, etc), but we try to keep the libxfs code as encapsulated as
> possible.
>
> In terms of getting attrs to userspace, the equivalent attribute
> listing code is in fs/xfs/xfs_attr_list.c, and that avoids all these
> problems. I'd just move the xfs_attr_get_parent_pointer() function
> there as ithis code should not be needed in userspace and it would
> avoid all the userspace libxfs compile issues...
>
> Cheers,
>
> Dave.
Alrighty, that seems like a good place for it then.  Thank you!

Allison
