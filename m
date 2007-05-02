Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 02:15:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l429FjfB025664
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 02:15:47 -0700
Date: Wed, 2 May 2007 19:15:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070502091526.GW77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com> <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: David Chinner <dgc@sgi.com>, Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Tue, May 01, 2007 at 07:46:53PM +0100, Anton Altaparmakov wrote:
> On 1 May 2007, at 15:20, David Chinner wrote:
> >>
> >>So, either the filesystem will understand the flag or iff the  
> >>unknown flag
> >>is in the incompat set, it will return EINVAL or else the unknown  
> >>flag will
> >>be safely ignored.
> >
> >My point was that there is a difference between specification and
> >implementation - if the specification says something is compulsory,
> >then they must be implemented in the filesystem. This is easy
> >enough to ensure by code review - we don't need additional interface
> >complexity for this....
> 
> You are wrong about this because you are missing the point that you  
> have no code to review.  The users that will use those flags are  
> going to be applications that run in user space.  Chances are you  
> will never see their code.  Heck, they might not even be open source  
> applications...

Ummm - the specification defines what is compulsory for *filesystems*
to implement, not what applications can use. We don't need to see
what the applications do - what we care about is that all filesystems
implement the compulsory part of the specification. That's the code
we review, and that's what I was referring to.

> And all applications will run against a multitude of  
> kernels.  So version X of the application will run on kernel 2.4.*,  
> 2.6.*, a.b.*, etc...  For future expandability of the interface I  
> think it is important to have both compulsory and non-compulsory flags.

Ah, so that's what you want - a mutable interface. i.e. versioning.

So how does compusory flags help here? What happens if a voluntary
flag now becomes compulsory? Or vice versa? How is the application
supposed to deal with this dynamically?

I suggested a version number for this right back at the start of
this discussion and got told that we don't want versioned interfaces
because we should make the effort to get it right the first time.
I don't think this can be called "getting it right".

> For example there is no reason why FIEMAP_HSM_READ needs to be  
> compulsory.  Most filesystems do not support HSM so can safely ignore  
> it.

They might be able to safely ignore it, but in reality it should
be saying "I don't understand this". If the application *needs* to
use a flag like this, then it should be told that the filesystem is
not capable of doing what it was asked!

OTOH if the application does not need to use the flag, then it
shouldn't be using it and we shouldn't be silently ignoring
incorrect usage of the provided API.

What you are effectively saying about these "voluntary" flags
is that their behaviour is _undefined_. That is, if you use
these flags what you get on a successful call is undefined;
it may or may not contain what you asked for but you can't
tell if it really did what you want or returned the information
you asked for.

This is a really bad semantic to encode into an API.

> And vice versa, an application might specify some weird and funky yet  
> to be developed feature that it expects the FS to perform and if the  
> FS cannot do it (either because it does not support it or because it  
> failed to perform the operation) the application expects the FS to  
> return an error and not to ignore the flag.  An example could be the  
> asked for FIEMAP_XATTR_FORK flag.  If that is implemented, and the FS  
> ignores it it will return the extent map for the file data instead of  
> the XATTR_FORK!  Not what the application wanted at all.  Ouch!  So  
> this is definitely a compulsory flag if I ever saw one.

Yes, the correct answer is -EOPNOTSUPP or -EINVAL in this case. But
we don't need a flag defined in the user visible API to tell us
that we need to return an error here.

> So as you see you must support both voluntary and compulsory flags...

No, you've managed to convince me that they are not necessary and
they are in fact a Bad Idea... ;)

> Also consider what I said above about different kernels.  A new  
> feature is implemented in kernel 2.8.13 say that was not there before  
> and an application is updated to use that feature.  There will be  
> lots of instances where that application will still be run on older  
> kernels where this feature does not exist. 

This is *exactly* where silently ignoring flags really falls down.
On 2.8.13, the flag is silently ignored. On 2.8.14, the flag does
something and it returns different structure contents for the same
state. Now how does the application writer know which is correct or
how to tell the difference?  They have to guess or write detection
code which is exactly what we want to avoid.

I objected to the UNKNOWN flag because it wasn't explicit
in it's meaning - I'm doing the same thing here. An interface
needs to be explicitly defined and should not have and undefined
behaviour in it....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
