Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45814 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754669AbdBNQKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 11:10:18 -0500
Message-ID: <1487088593.3133.23.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/2] fs: add inode helpers for fsuid and fsgid
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 14 Feb 2017 08:09:53 -0800
In-Reply-To: <87lgt9mcyv.fsf@xmission.com>
References: <1487008001.3125.41.camel@HansenPartnership.com>
         <20170213194337.GA9852@infradead.org> <20170213213416.GA15349@dastard>
         <20170214060809.GA21114@infradead.org>
         <1487053651.3125.72.camel@HansenPartnership.com>
         <1487053720.3125.73.camel@HansenPartnership.com>
         <87lgt9mcyv.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

On Tue, 2017-02-14 at 20:46 +1300, Eric W. Biederman wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > Now that we have two different views of filesystem ids (the 
> > filesystem view and the kernel view), we have a problem in that
> > current_fsuid/fsgid() return the kernel view but are sometimes used 
> > in filesystem code where the filesystem view shoud be used.  This
> > patch introduces helpers to produce the filesystem view of current 
> > fsuid and fsgid.
> 
> If I am reading this right what we are seeing is that xfs explicitly
> opted out of type safety with predictable results.   Accidentally
> confusing kuids and uids, which is potentially security issue.
> 
> All of that said where are you getting sb->s_user_ns != &init_user_ns
> for an xfs filesystem?  There are quite a few xfs interfaces that are
> not ready for that.   xfs has a very wide userspace interface of 
> ioctls that all needs to be looked at and addressed carefully if 
> there is anything like this going on.
> 
> I think we really need to ask if we should use kuids and kgids for 
> the xfs internal quota code.

That question devolves to who administers quota operations in
containers.   The answer is usually that apparent root in the container
needs to be able to administer quotas as though they were real root
outside, so transforming the user quota calculations is correct to
first order.

To second order we need a way of controlling the container's quota which is why we've had a flurry of two level quota patches over the years.  We've finally settled on group or project quotas and, if you look at xfs, you'll see the project quota will work even in the face of uid shifts in the user quota, so I think it's all working.

>   At the end of the day that is going to be a whole lot less error
> prone.

It would make the job of the filesystem write harder: a lot of quota
code is very close to the disk, so they'd need a whole lot of
transforms to kernel view.

> > Signed-off-by: James Bottomley <
> > James.Bottomley@HansenPartnership.com>
> > 
> > diff --git a/include/linux/cred.h b/include/linux/cred.h
> > index f0e70a1..18e9c41 100644
> > --- a/include/linux/cred.h
> > +++ b/include/linux/cred.h
> > @@ -399,4 +399,9 @@ do {						
> > \
> >  	*(_fsgid) = __cred->fsgid;		\
> >  } while(0)
> >  
> > +/* return the current id in the filesystem view */
> > +#define i_fsuid(i) from_kuid((i)->i_sb->s_user_ns,
> > current_fsuid())
> > +#define i_fsgid(i) from_kgid((i)->i_sb->s_user_ns,
> > current_fsgid())
> 
> Could we please place these helpers in fs.h?

We could ... the current_ helpers are in cred.h, which is why I put the
new ones there, but I've no strong feelings either way.

> That should allow them to become inline functions and live with the
> existing filesystem helpers in there.

I don't believe they did.  There's code in most filesystems (usually in
quota) where they need to perform calculations with the current user
id.  The problem is that with s_user_ns, they can't use current_fsuid()
because it's the kernel view and the places where the filesystem is
using it are often in the filesystem view.

> My gut says the names disk_fsuid(i) and disk_fsgid(i) would be
> clearer.

I chose i_fsuid/fsgid for two reasons

   1. because it takes an inode as an arguments.
   2. to be consistent with i_uid_read/write() which are the other
      namespace shifting primitives for filesystems.

I think 2. is quite compelling, so if you want a different name for
this, we should rename i_uid/gid_read/write() as well.

> Of course all of this has the challenge of error handling in the case
> when current_fsuid or current_fsgid do not map into the current
> filesystem.

Yes, I think it actually fails in the quota case because unmapped
usually gives uid/gid -1 which has no quota set, so you can bust out of
your quota with the right s_user_ns.  On the other hand if you can set
up s_user_ns then you should be admin for that quota and it's caveat
emptor.

James

