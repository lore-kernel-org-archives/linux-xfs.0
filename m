Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 03:58:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l42AwCfB023745
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 03:58:14 -0700
Date: Wed, 2 May 2007 20:57:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070502105749.GY77450368@melbourne.sgi.com>
References: <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com> <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk> <20070502091526.GW77450368@melbourne.sgi.com> <2604946E-CF10-426F-9720-DDABD10C8E0D@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2604946E-CF10-426F-9720-DDABD10C8E0D@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: David Chinner <dgc@sgi.com>, Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Wed, May 02, 2007 at 10:36:12AM +0100, Anton Altaparmakov wrote:
> On 2 May 2007, at 10:15, David Chinner wrote:
> >On Tue, May 01, 2007 at 07:46:53PM +0100, Anton Altaparmakov wrote:
> >>And all applications will run against a multitude of
> >>kernels.  So version X of the application will run on kernel 2.4.*,
> >>2.6.*, a.b.*, etc...  For future expandability of the interface I
> >>think it is important to have both compulsory and non-compulsory  
> >>flags.
> >
> >Ah, so that's what you want - a mutable interface. i.e. versioning.
> >
> >So how does compusory flags help here? What happens if a voluntary
> >flag now becomes compulsory? Or vice versa? How is the application
> >supposed to deal with this dynamically?
> >
> >I suggested a version number for this right back at the start of
> >this discussion and got told that we don't want versioned interfaces
> >because we should make the effort to get it right the first time.
> >I don't think this can be called "getting it right".
> 
> Look at ext2/3/4.  They do it that way and it works well.  No  
> versioning just compatible and incompatible flags...  The proposal is  
> to do the same here.

Just because it works for extN doesn't make it right for this
interface.

> >>For example there is no reason why FIEMAP_HSM_READ needs to be
> >>compulsory.  Most filesystems do not support HSM so can safely ignore
> >>it.
> >
> >They might be able to safely ignore it, but in reality it should
> >be saying "I don't understand this". If the application *needs* to
> >use a flag like this, then it should be told that the filesystem is
> >not capable of doing what it was asked!
> 
> That is where you are completely wrong!  (-:  Or rather you are wrong  
> for my example, i.e. you are wrong/right depending on the type of  
> flag in question.

And that is the crux of the argument.

My point is that *any* flag returns an error if the filesystem
does not support it.

> HSM_READ is definitely _NOT_ required because all  
> it means is "if the file is OFFLINE, bring it ONLINE and then return  
> the extent map".

You've got the definition of HSM_READ wrong. If the flag is *not*
set, then we bring everything back online and return the full extent
map.

Specifying the flag indicates that we do *not* want the offline
extents brought back online.  i.e. it is a HSM or a datamover
(e.g. backup program) that is querying the extents and we want to
known *exactly* what the current state of the file is right now.

So, if the HSM_READ flag is set, then the application is
expecting the filesytem to be part of a HSM. Hence if it's not,
it should return an error because somebody has done something wrong.

> >OTOH if the application does not need to use the flag, then it
> >shouldn't be using it and we shouldn't be silently ignoring
> >incorrect usage of the provided API.
> >
> >What you are effectively saying about these "voluntary" flags
> >is that their behaviour is _undefined_. That is, if you use
> >these flags what you get on a successful call is undefined;
> >it may or may not contain what you asked for but you can't
> >tell if it really did what you want or returned the information
> >you asked for.
> >
> >This is a really bad semantic to encode into an API.
> 
> That is your opinion.  There is nothing undefined in the API at all.   
> You just fail to understand it...

FIEMAP returned success. Did it do what I asked? I don't
know because it's allowed to return success when it did ignored me.

This is as silly an interface definition as saying you can
implement fsync() with { return 0; }.  So, when fsync() succeeded
did it write my data to disk? I don't know; it's allowed to return
success when it ignored me.

It's crazy, isn't it? It makes writing applications portable
across operating systems a real PITA (ask the MySQL folk ;)
because POSIX really does allow fsync() to be implemented like this.

I use this example because the "allow some filesystems to silently
ignore flags they don't understand" is a portability problem for
applications - rather than a cross-OS issue it is a cross-filesystem
issue. That is, if different filesystems behave differently to
the same request they will have to be handled specifically by
the application. Every filesystem should behave in *exactly* the
same way to the FIEMAP ioctls - if they don't support something
they throw an error, if they do then they return the correct
data.

> >>And vice versa, an application might specify some weird and funky yet
> >>to be developed feature that it expects the FS to perform and if the
> >>FS cannot do it (either because it does not support it or because it
> >>failed to perform the operation) the application expects the FS to
> >>return an error and not to ignore the flag.  An example could be the
> >>asked for FIEMAP_XATTR_FORK flag.  If that is implemented, and the FS
> >>ignores it it will return the extent map for the file data instead of
> >>the XATTR_FORK!  Not what the application wanted at all.  Ouch!  So
> >>this is definitely a compulsory flag if I ever saw one.
> >
> >Yes, the correct answer is -EOPNOTSUPP or -EINVAL in this case. But
> >we don't need a flag defined in the user visible API to tell us
> >that we need to return an error here.
> 
> Heh? What are you talking about?  You need a flag to specify that you  
> want XATTR_FORK.  If not how the hell does the application specify  
> that it wants XATTR_FORK instead of DATA_FORK (default)?  Or are you  
> of the opinion that FIEMAP should definitely not support XATTR_FORK.   
> If the latter I fully agree.  This should be a separate API with  
> named streams and the FD of the named stream should be passed to  
> FIEMAP without the silly XATTR_FORK flag...

Ummmm - I think you misunderstood what I was saying. I was agreeing
with you that is a FS does not support FIEMAP_XATTR_FORK "the correct
answer is -EOPNOTSUPP or -EINVAL".

What I was saying is that we don't need a COMPAT flag bit to tell
us the obvious error return if the filesystem does not support this
functionality....

> >>Also consider what I said above about different kernels.  A new
> >>feature is implemented in kernel 2.8.13 say that was not there before
> >>and an application is updated to use that feature.  There will be
> >>lots of instances where that application will still be run on older
> >>kernels where this feature does not exist.
> >
> >This is *exactly* where silently ignoring flags really falls down.
> 
> It does not!
> 
> >On 2.8.13, the flag is silently ignored. On 2.8.14, the flag does
> >something and it returns different structure contents for the same
> 
> No it does not.  You do NOT understand at all what we are talking  
> about do you?!?
> 
> If a flag would do something weird like returning different data then  
> OBVIOUSLY you would make this a mandatory flag and it will NOT be  
> ignored!

You've just successfully argued my case for me.

By your reasoning, if we have voluntary flags 1, 2 and 3 and
filesystems A, B and C and filesystem A is the only filesystem to
implement 1, when B implements 1 bit must become a compulsory flag
and hence C must now return an error despite being unchanged.

Likewise when C implement 3, 3 must become a comulsory flag and
A and B must now return an error despite being unchanged.

IOWs, whenever *any* filesystem implements a voluntary feature that
it didn't previously support, we have to make that a mandatory
feature and all other filesystems that don't support it now
must return an error. You're guaranteeing th application sees
changes in behaviour with this interface, not preventing.

Can we simply mandate that filesystems return an error
to commands they don't support or don't understand and
drop this silly interface mutation thing?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
