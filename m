Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 03:50:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4RAo42K028280
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 03:50:07 -0700
Message-ID: <483BE788.4050504@sgi.com>
Date: Tue, 27 May 2008 20:50:48 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] use generic_*xattr routines
References: <20080430112217.GB16966@lst.de> <20080521081656.GA2638@lst.de> <48365486.3060503@sgi.com> <20080523054848.GA29507@lst.de> <483A15CE.9060409@sgi.com> <20080526053759.GA17825@lst.de>
In-Reply-To: <20080526053759.GA17825@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, May 26, 2008 at 11:43:42AM +1000, Timothy Shimmin wrote:
>> I guess this is done to some extent by the put_listent() callback.
>> Though, the context structure is probably a bit overused in different
>> ways.
>> The callback was also used for searching (for parent-ptr code) as well
>> as for list formatting.
>> I presume we are preserving the valuelen list format to keep the API
>> for xfs_attrlist_by_handle used by xfsdump and probably for dmf.
> 
> Yes, the idea is to change the put_listen callback for work more like
> filldir.  Thas is:
> 
>  - the callback is supplied by the xfs_attr_list caller, not set based
>    on options

Oh, okay. For example, instead of setting the flags to ATTR_KERNOVAL
such as in xfs_vn_listxattr when size is 0, one could just set the callback
to xfs_attr_kern_list_sizes and pass it in etc...

>  - there will be an opaque object supplied to xfs_attr_list that is to
>    be used by put_listent so that we don't have to pass down
>    implementation-specific arguments directly.
>

Ok.
So instead of overloading fields in xfs_attr_list_context_t,
you'll pass down a void* argument or some such for callback specific data.

> I'd also like to move the attrlist_cursor_kern_t into this callback
> opaque context because it doesn't make sense for the normal xattr API,
> but I'll have to see if that's actually feasible.

BTW, the cursor stuff is a bit flawed. Like the dir1 code (I believe),
if from userspace you use the cursor and modifications happen to the EAs
(add or removal) between calls, 
we can end up repeating elements in the list or miss some.
We don't preserve the position and we can compact the data etc.

--Tim


xfs_attr_list(
        xfs_inode_t     *dp,
        char            *buffer,
        int             bufsize,
        int             flags,
        attrlist_cursor_kern_t *cursor)
{       
        xfs_attr_list_context_t context;
...
        if (flags & ATTR_KERNAMELS) {
                context.bufsize = bufsize;
                context.firstu = context.bufsize;
                if (flags & ATTR_KERNOVAL)
                        context.put_listent = xfs_attr_kern_list_sizes;
                else
                        context.put_listent = xfs_attr_kern_list;
        } else {
                context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
                context.firstu = context.bufsize;
                context.alist->al_count = 0;
                context.alist->al_more = 0;
                context.alist->al_offset[0] = context.bufsize;
                context.put_listent = xfs_attr_put_listent;
        }


ssize_t
xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
{
        struct inode            *inode = dentry->d_inode;
        struct xfs_inode        *ip = XFS_I(inode);
        attrlist_cursor_kern_t  cursor = { 0 };
        int                     error, xflags;
        ssize_t                 result;

        xflags = ATTR_KERNAMELS;
        if (!size)
                xflags |= ATTR_KERNOVAL;

        if (capable(CAP_SYS_ADMIN))
                xflags |= ATTR_KERNFULLS;
        else
                xflags |= ATTR_KERNORMALS;


        /*
         * First read the regular on-disk attributes.
         */
        result = -xfs_attr_list(ip, data, size, xflags, &cursor);
