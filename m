Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 23:37:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4U6b4ES023696
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 23:37:06 -0700
Message-ID: <483FA0B6.1030703@sgi.com>
Date: Fri, 30 May 2008 16:37:42 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] use generic_*xattr routines
References: <20080430112217.GB16966@lst.de> <20080521081656.GA2638@lst.de> <48365486.3060503@sgi.com> <20080523054848.GA29507@lst.de> <483A15CE.9060409@sgi.com> <20080526053759.GA17825@lst.de> <483BE788.4050504@sgi.com> <20080529123910.GA30874@lst.de>
In-Reply-To: <20080529123910.GA30874@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, May 27, 2008 at 08:50:48PM +1000, Timothy Shimmin wrote:
>>>  - the callback is supplied by the xfs_attr_list caller, not set based
>>>    on options
>> Oh, okay. For example, instead of setting the flags to ATTR_KERNOVAL
>> such as in xfs_vn_listxattr when size is 0, one could just set the callback
>> to xfs_attr_kern_list_sizes and pass it in etc...
> 
> Yes.  I have an initial patch that goes directly to xfs_attr_list_int
> from xfs_xattr.c and kills most of the ATTR_KERN flags.  It's a quite
> nice cleanup already.  Next step will be to convert dmapi to use it's
> own callback aswell.  This will be an even bigger cleanup as
> put_listent gets the xattr value aswell and we can kill the additional
> xfs_attr_get calls, making this code simpler and more efficient.
> 
Sorry, what xfs_attr_get call are you referring to?

>>>  - there will be an opaque object supplied to xfs_attr_list that is to
>>>    be used by put_listent so that we don't have to pass down
>>>    implementation-specific arguments directly.
>>>
>> Ok.
>> So instead of overloading fields in xfs_attr_list_context_t,
>> you'll pass down a void* argument or some such for callback specific data.
> 
> I've started looking at this and after some investigation I think
> we should just pass the xfs_inode directly to all the functions and then
> a void parameter, yes.  We'll need to find a solution for the
> seen_enough paramter, but I think this could be handled similar to
> filldir.  There's also some functions directly touching the attr cursor
> which seems solveable, too.
> 
I'll await the patch :)
The seen_enough param was added for search type callbacks so the callback
could terminate the list walk early.
Oh okay, I also used it to stop when we fill the buffer.

>>> I'd also like to move the attrlist_cursor_kern_t into this callback
>>> opaque context because it doesn't make sense for the normal xattr API,
>>> but I'll have to see if that's actually feasible.
>> BTW, the cursor stuff is a bit flawed. Like the dir1 code (I believe),
>> if from userspace you use the cursor and modifications happen to the EAs
>> (add or removal) between calls, 
>> we can end up repeating elements in the list or miss some.
>> We don't preserve the position and we can compact the data etc.
> 
> Yes, I think this whole cursor is a rather bad idea.  But given that
> it's used by xfsdump we can't easily get rid of it.
Not if we are to remain compatible with old xfsdump programs (assuming we changed
the latest one).
Yep.

--Tim
