Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 18:43:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4Q1gxMe025856
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 18:43:00 -0700
Message-ID: <483A15CE.9060409@sgi.com>
Date: Mon, 26 May 2008 11:43:42 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] use generic_*xattr routines
References: <20080430112217.GB16966@lst.de> <20080521081656.GA2638@lst.de> <48365486.3060503@sgi.com> <20080523054848.GA29507@lst.de>
In-Reply-To: <20080523054848.GA29507@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, May 23, 2008 at 03:22:14PM +1000, Timothy Shimmin wrote:
>> Hi Christoph,
>>
>> Looks reasonable to me.
>>
>> In list_one_attr(), which looks based on attr_generic_listadd(),
>> it does a final:
>>> +	p += len;
>> which seems useless.
> 
> Yeah, feel free to remove it when you commit the patch.  Alternatively
> I'll send an incremental patch once commited.
> 
Yep, I'll remove it before checkin.

>> An aside, I noticed in passing (which was in existing code),
>> how we call vn_revalidate
>> in xfs_xattr_system_set(). I presume this is because we
>> call xfs_acl_setmode() in xfs_acl_vset() when we want to sync
>> the mode bits to the ACL.
>> If this is the case, then I think it would have been clearer
>> to put vn_revalidate() in the vicinity of xfs_acl_setmode().
>> Or is there some other reason?
> 
> No real reason, I was just keeping what was there before.  But getting
> rid of vn_revalidate complete is on my todo list.  The timestamp updates
> in there are already not nessecary anymore, and the i_mode/i_uid/i_gid
> and i_flags updates can be done much better in the caller that change
> the values in the dinode.
> 
Okay, good to know.


>> So you are removing xfs_vn_setxattr, xfs_vn_getxattr, and
>> xfs_vn_removexattr and calling generic_xattr and retaining the
>> code in xattr_handler's.
>>
>> You leave xfs_vn_listxattr alone. Just like ext3 does its own. Ok.
> 
> Yes, the generic listxattr doesn't buy us anything as we just traverse
> the attr btree and list all of them in their natural order.  No point
> in traversing it N times for N different attribute handlers.
> 
Good point (I didn't really look).


>>> +static int
>>> +xfs_xattr_system_get(struct inode *inode, const char *name,
>>> +		void *buffer, size_t size)
>>> +{
>>> +	int acl;
>>> +
>>> +	acl = xfs_decode_acl(name);
>>> +	if (acl < 0)
>>> +		return acl;
>>> +
>>> +	return xfs_acl_vget(inode, buffer, size, acl);
>>> +}
>>> +
>> Fine.
>> Seems a little funny as we are calling it a system EA but
>> then directly calling the acl code.
>> i.e. acknowledging, I guess, that we only have Posix ACLs
>> as system EAs.
>> Almost could call it xfs_xattr_acl_get().
>> It saves on one liner wrappers I guess.
> 
> Probably worth adding a comment that we only have acls for now.
> The reason I did this is to avoid doing multiple memcpys on the xattr
> name for decoding it.  It will probably need some revisiting if/when
> we support other system xattrs.
Okay, I'll add a comment.


> 
> Yeah, se the comment above.  vn_revalidate will go away pretty soon at
> which point this is sorted out.
> 
>>> +struct xattr_handler *xfs_xattr_handlers[] = {
>>> +	&xfs_xattr_user_handler,
>>> +	&xfs_xattr_trusted_handler,
>>> +	&xfs_xattr_security_handler,
>>> +	&xfs_xattr_system_handler,
>>> +	NULL
>>> +};
>>> +
>> So List code is done separately. Hmmmm...
>>
>> Oh, okay, ATTR_KERNAMELS (for attr_vn_listxattr) uses
>> concatenated string arrays
>> whereas for not ATTR_KERNAMELS, such as is used in
>> xfs_attrlist_by_handle is uses list data in the form:
>> <u32: valuelen> <char: name-array> <pad-to-4-byte-boundary>
> 
> Yes, this is quite unfortunate.  My plan is to refactor the low-level
> attr code so that is passes down a formatter ala filldir for directory
> reading.  This should clean up the attr listing code a lot and also
> gets rid of the levtover struct attrnames bits.  But that a different
> patch which still needs to be written.
> 
I guess this is done to some extent by the put_listent() callback.
Though, the context structure is probably a bit overused in different
ways.
The callback was also used for searching (for parent-ptr code) as well
as for list formatting.
I presume we are preserving the valuelen list format to keep the API
for xfs_attrlist_by_handle used by xfsdump and probably for dmf.

Thanks,
--Tim
