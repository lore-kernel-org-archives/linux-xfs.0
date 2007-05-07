Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 04:03:55 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47B3lfB017677
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 04:03:49 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l47B3hN7031521
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:03:43 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47B3hcJ515560
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:03:43 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47B3g21005021
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:03:43 -0400
Date: Mon, 7 May 2007 16:33:48 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070507110348.GA7012@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503212955.b1b6443c.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Andrew,

Thanks for the review comments!

On Thu, May 03, 2007 at 09:29:55PM -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 23:33:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > This patch implements the fallocate() system call and adds support for
> > i386, x86_64 and powerpc.
> > 
> > ...
> >
> > +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> Please add a comment over this function which specifies its behaviour. 
> Really it should be enough material from which a full manpage can be
> written.
> 
> If that's all too much, this material should at least be spelled out in the
> changelog.  Because there's no way in which this change can be fully
> reviewed unless someone (ie: you) tells us what it is setting out to
> achieve.
> 
> If we 100% implement some standard then a URL for what we claim to
> implement would suffice.  Given that we're at least using different types from
> posix I doubt if such a thing would be sufficient.
> 
> And given the complexity and potential variability within the filesystem
> implementations of this, I'd expect that _something_ additional needs to be
> said?

Ok. I will add a detailed comment here.

> 
> > +{
> > +	struct file *file;
> > +	struct inode *inode;
> > +	long ret = -EINVAL;
> > +
> > +	if (len == 0 || offset < 0)
> > +		goto out;
> 
> The posix spec implies that negative `len' is permitted - presumably "allocate
> ahead of `offset'".  How peculiar.

I think we should go ahead with current glibc implementation (which
Jakub poited at) of not allowing a negative 'len', since posix also
doesn't explicitly say anything about allowing negative 'len'.

> 
> > +	ret = -EBADF;
> > +	file = fget(fd);
> > +	if (!file)
> > +		goto out;
> > +	if (!(file->f_mode & FMODE_WRITE))
> > +		goto out_fput;
> > +
> > +	inode = file->f_path.dentry->d_inode;
> > +
> > +	ret = -ESPIPE;
> > +	if (S_ISFIFO(inode->i_mode))
> > +		goto out_fput;
> > +
> > +	ret = -ENODEV;
> > +	if (!S_ISREG(inode->i_mode))
> > +		goto out_fput;
> 
> So we return ENODEV against an S_ISBLK fd, as per the posix spec.  That
> seems a bit silly of them.

True. 
 
> > +	ret = -EFBIG;
> > +	if (offset + len > inode->i_sb->s_maxbytes)
> > +		goto out_fput;
> 
> This code does handle offset+len going negative, but only by accident, I
> suspect.  It happens that s_maxbytes has unsigned type.  Perhaps a comment
> here would settle the reader's mind.

Ok. I will add a check here for wrap though zero.
 
> > +	if (inode->i_op && inode->i_op->fallocate)
> > +		ret = inode->i_op->fallocate(inode, mode, offset, len);
> > +	else
> > +		ret = -ENOSYS;
> 
> If we _are_ going to support negative `len', as posix suggests, I think we
> should perform the appropriate sanity conversions to `offset' and `len'
> right here, rather than expecting each filesystem to do it.
> 
> If we're not going to handle negative `len' then we should check for it.

Will add a check for negative 'len' and return -EINVAL. This will be
done where currently we check for negative offset (i.e. at the start of
the function).
 
> > +out_fput:
> > +	fput(file);
> > +out:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(sys_fallocate);
> 
> I don't believe this needs to be exported to modules?

Ok. Will remove it.
 
> > +/*
> > + * fallocate() modes
> > + */
> > +#define FA_ALLOCATE	0x1
> > +#define FA_DEALLOCATE	0x2
> 
> Now those aren't in posix.  They should be documented, along with their
> expected semantics.

Will add a comment describing the role of these modes.
 
> >  #ifdef __KERNEL__
> >  
> >  #include <linux/linkage.h>
> > @@ -1125,6 +1131,7 @@ struct inode_operations {
> >  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
> >  	int (*removexattr) (struct dentry *, const char *);
> >  	void (*truncate_range)(struct inode *, loff_t, loff_t);
> > +	long (*fallocate)(struct inode *, int, loff_t, loff_t);
> 
> I really do think it's better to put the variable names in definitions such
> as this.  Especially when we have two identically-typed variables next to
> each other like that.  Quick: which one is the offset and which is the
> length?

Ok. Will add the variable names here.

--
Regards,
Amit Arora
