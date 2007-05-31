Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 01:52:19 -0700 (PDT)
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4V8qEWt011729
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 01:52:17 -0700
Message-ID: <465E8CBE.8020709@suse.cz>
Date: Thu, 31 May 2007 10:52:14 +0200
From: Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS
 in compat mode
References: <20070530125954.706423971@suse.cz> <20070530143044.060544510@suse.cz> <20070531063734.GJ85884050@sgi.com>
In-Reply-To: <20070531063734.GJ85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

David Chinner wrote:
> On Wed, May 30, 2007 at 02:59:57PM +0200, Michal Marek wrote:
>> +typedef struct xfs_bstat32 {
>> +	__u64		bs_ino;		/* inode number			*/
>> +	__u16		bs_mode;	/* type and mode		*/
>> +	__u16		bs_nlink;	/* number of links		*/
>> +	__u32		bs_uid;		/* user id			*/
>> +	__u32		bs_gid;		/* group id			*/
>> +	__u32		bs_rdev;	/* device value			*/
>> +	__s32		bs_blksize;	/* block size			*/
>> +	__s64		bs_size;	/* file size			*/
>> +	xfs_bstime32_t	bs_atime;	/* access time			*/
>> +	xfs_bstime32_t	bs_mtime;	/* modify time			*/
>> +	xfs_bstime32_t	bs_ctime;	/* inode change time		*/
>> +	int64_t		bs_blocks;	/* number of blocks		*/
>> +	__u32		bs_xflags;	/* extended flags		*/
>> +	__s32		bs_extsize;	/* extent size			*/
>> +	__s32		bs_extents;	/* number of extents		*/
>> +	__u32		bs_gen;		/* generation count		*/
>> +	__u16		bs_projid;	/* project id			*/
>> +	unsigned char	bs_pad[14];	/* pad space, unused		*/
>> +	__u32		bs_dmevmask;	/* DMIG event mask		*/
>> +	__u16		bs_dmstate;	/* DMIG state info		*/
>> +	__u16		bs_aextents;	/* attribute number of extents	*/
>> +}
>> +#ifdef BROKEN_X86_ALIGNMENT
>> +	__attribute__((packed))
>> +#endif
>> +	xfs_bstat32_t;
> 
> #ifdef BROKEN_X86_ALIGNMENT
> #define _PACKED	__attribute__((packed))
> #else
> #define _PACKED
> #endif
> 
> typedef struct xfs_bstat_32 {
> 	......
> } _PACKED xfs_bstat32_t

Yes, that would look cleaner. Perhaps something like PACKED_IF_NEEDED so
that it's clear that it's not allways defined to __attribute__((packed))?


>> +static int xfs_bstat_store_compat(
>> +	xfs_bstat32_t __user *p32,
>> +	xfs_bstat_t __user *p)
>> +{
>> +#define copy(memb) copy_in_user(&p32->memb, &p->memb, sizeof(p32->memb))
> 
> Hmmm - now I see why you used this.
> 
> These copies are used everywhere in this file, maybe it would be best
> to define a copy_from_32() and a copy_to_32() macros and use them
> everywhere in the file?

OK, I'll use a "proper" (not playing with some local variables) global
macro like Arnd suggested in this thread.


>> +#define MAX_BSTAT_LEN \
>> +	((__s32)((64*1024 - sizeof(xfs_fsop_bulkreq_t)) / sizeof(xfs_bstat_t)))
>> +#define MAX_INOGRP_LEN \
>> +	((__s32)((64*1024 - sizeof(xfs_fsop_bulkreq_t)) / sizeof(xfs_inogrp_t)))
> 
> Oooo magic numbers. Why were these chosen?

I wanted to limit the argument passed to compat_alloc_user_space
somehow; 64K is probably not the best idea, but some upper bound is
needed, isn't it? OK, if we can get around without any conversions at
all (see below), then these constants can go away.


>> +
>> +STATIC int
>> +xfs_ioctl32_bulkstat_wrap(
>> +	bhv_vnode_t	*vp,
>> +	struct inode    *inode,
>> +	struct file     *file,
>> +	int             mode,
>> +	unsigned        cmd,
>> +	unsigned long   arg)
>>  {
>> -	xfs_fsop_bulkreq32_t	__user *p32 = (void __user *)arg;
>> -	xfs_fsop_bulkreq_t	__user *p = compat_alloc_user_space(sizeof(*p));
>> -	u32			addr;
>> -
>> -	if (get_user(addr, &p32->lastip) ||
>> -	    put_user(compat_ptr(addr), &p->lastip) ||
>> -	    copy_in_user(&p->icount, &p32->icount, sizeof(s32)) ||
>> -	    get_user(addr, &p32->ubuffer) ||
>> -	    put_user(compat_ptr(addr), &p->ubuffer) ||
>> -	    get_user(addr, &p32->ocount) ||
>> -	    put_user(compat_ptr(addr), &p->ocount))
>> +	xfs_fsop_bulkreq32_t __user *p32 = (void __user *)arg;
>> +	xfs_fsop_bulkreq_t tmp;
>> +	u32 addr;
>> +	void *buf32;
>> +	int err;
>> +
>> +	if (get_user(addr, &p32->lastip))
>> +		return 0;
> 
> return -EFAULT?

Oops, silly mistake. Thanks!


>> +	if (cmd == XFS_IOC_FSBULKSTAT_32)
>> +		cmd = XFS_IOC_FSBULKSTAT;
>> +	if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32)
>> +		cmd = XFS_IOC_FSBULKSTAT_SINGLE;
>> +	if (cmd == XFS_IOC_FSINUMBERS_32)
>> +		cmd = XFS_IOC_FSINUMBERS;
> 
> 	cmd = _NATIVE_IOC(cmd, struct xfs_fsop_bulkreq);
> 	switch (cmd) {
> 	case XFS_IOC_FSBULKSTAT:
> 	case XFS_IOC_FSBULKSTAT_SINGLE:

Yes, I'll use _NATIVE_IOC here (also in other places as you pointed out).


>> +
>> +	if (cmd == XFS_IOC_FSBULKSTAT || cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
> 
> Oh, now it gets messy :(

True :-/


> So, we do a whole lot of repacking of the bulkstat structures
> once we've got the data out of the bulkstat call.
> 
> I think this is really the wrong way of doing this - the bulkstat
> functions themselves take a "formatter" argument that is used to pack
> the buffer in a given format. I think that we need to be supplying
> the bulkstat code with different formatters in this case, not
> repacking the buffer into a different format at a later time.
> 
> The formatter used by default is xfs_bulkstat_one() which 
> falls down to xfs_bulkstat_one_dinode() or xfs_bulkstat_one_iget()
> depending on whether we are doing icache coherent or blockdev
> cache coherent lookups. It is these functions that need to be
> told what format they are packing, I think, and xfs_bulkstat_single()
> needs to be taught about them....

Well, I didn't want to touch other files but xfs_ioctl32.c so that the
patch has a higher chance of being accepted ;-) But of course if you
think that patching the implementation to be aware of the compat ioctls
is acceptable, then I can do it.


>> +	if (cmd == XFS_IOC_FSINUMBERS) {
> 
> And I'm wondering if we should be doing the same thing here
> (i.e. customer formatters), because this is equally ugly...

I'll try to clean up the XFS_IOC_FSBULKSTAT part first...


Thanks to all for their comments and suggestions! I'll send updated
patches later.

Michal
