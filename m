Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Sep 2006 00:50:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8M7nqaG022272
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 00:49:54 -0700
Message-ID: <451395AB.4060400@sgi.com>
Date: Fri, 22 Sep 2006 17:50:03 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH -mm] rescue large xfs preferred iosize from the inode
 diet patch
References: <45131334.6050803@sandeen.net> <45134472.7080002@sgi.com> <4513493F.8090005@sandeen.net> <45134DC5.4070607@sandeen.net> <20060922061950.GE3034@melbourne.sgi.com>
In-Reply-To: <20060922061950.GE3034@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs mailing list <xfs@oss.sgi.com>

David Chinner wrote:
> On Thu, Sep 21, 2006 at 09:43:17PM -0500, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Ah, ok, thanks guys.  Should have checked CVS I guess.
>>>
>> cc -= lkml;
>>
>> actually the patch nathan put in seems like a lot of replicated code.
> 
> Yeah, that's what caught me - I looked at the tree which had nathan's
> patch in it, and assumed that the stuff the -mm tree had cleaned it up
> to use the generic_fillattr() code.
> 
>> But maybe he's solving some problem I didn't think of.
> 
> The difference is the old code updated the fields in the linux inode
> with all the info from disk and then filled in the stat data from
> the linux inode.  The new code gets the data from "disk" and puts it
> straight into the the stat buffer without updating the linux inode.
> 
>> Any idea what?
> 
> I would have thought that we want what we report to userspace to be
> consistent in the linux inode as well. I suppose that by duplicating
> the code we removed a copy of the data but I see little advantage
> from doing that considering the extra code to do it and the fat that
> the linux inode may not be up to date now....
> 

Well we just sync it (linux inode) up at points when we need to don't we?
(Hmmm, doesn't look like we call vn_revalidate much anymore.)

I agree Eric's fix is simpler but I'd like to wait for Nathan's comments.
Perhaps he is trying to future proof us, from this thing
happening again when we rely on the linux inode? :)


Review at the time:
-------------------------------
Re: review: rework stat/getattr for i_blksize removal

To: Timothy Shimmin <tes@sgi.com>
Subject: Re: review: rework stat/getattr for i_blksize removal
From: Nathan Scott <nathans@sgi.com>
Date: Thu, 6 Jul 2006 15:45:14 +1000
Cc: xfs-dev
On Thu, Jul 06, 2006 at 03:37:02PM +1000, Timothy Shimmin wrote:
 > Hi Nathan,
 >
 > Looks reasonable.
 > Just a few questions of interest below :)

Thanks & no worries...

 > So we don't need to call vn_revalidate because we no longer need to update
 > the inode at this point with the data from the vnode because
 > we are no longer looking at the linux inode?
 > We are now just looking at the vnode and its fields (which we
 > get a lot from the xfs inode in xfs_getattr).

Yep.

 > +       error = bhv_vop_getattr(vp, &vattr, ATTR_LAZY, NULL);
 > +       if (likely(!error)) {
 > +               stat->size = i_size_read(inode);
 >
 > Q: OOI, Why can't we use vattr.va_size?
 > Is inode->i_size up to date at this point?

Slightly more uptodate at times, but we probably could use it too.
There are times where that is updated in advance of the XFS inode
(e.g. during write, its updated per-page, whereas we only update
the XFS inode right at the end).

I was just looking to reduce any risk here, but maybe we should go
for the xfs_inode size, for consistency ... lemme ponder it a bit.

 > +               stat->rdev = (vattr.va_rdev == 0) ? 0 :
 > +                               MKDEV(sysv_major(vattr.va_rdev) & 0x1ff,
 > +                                     sysv_minor(vattr.va_rdev));
 >
 > Q: Is it really worth special casing 0 with a conditional?
 > Result will be the same won't it?

Heh - good point.  It is the same in the end, will fix.

cheers.

-- 
Nathan

-------------------------------

--Tim
