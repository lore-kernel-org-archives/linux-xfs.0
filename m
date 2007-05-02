Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 02:38:32 -0700 (PDT)
Received: from ppsw-7.csi.cam.ac.uk (ppsw-7.csi.cam.ac.uk [131.111.8.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l429cPfB032340
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 02:38:28 -0700
In-Reply-To: <20070502091526.GW77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com> <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk> <20070502091526.GW77450368@melbourne.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2604946E-CF10-426F-9720-DDABD10C8E0D@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 10:36:12 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org


On 2 May 2007, at 10:15, David Chinner wrote:

> On Tue, May 01, 2007 at 07:46:53PM +0100, Anton Altaparmakov wrote:
>> On 1 May 2007, at 15:20, David Chinner wrote:
>>>>
>>>> So, either the filesystem will understand the flag or iff the
>>>> unknown flag
>>>> is in the incompat set, it will return EINVAL or else the unknown
>>>> flag will
>>>> be safely ignored.
>>>
>>> My point was that there is a difference between specification and
>>> implementation - if the specification says something is compulsory,
>>> then they must be implemented in the filesystem. This is easy
>>> enough to ensure by code review - we don't need additional interface
>>> complexity for this....
>>
>> You are wrong about this because you are missing the point that you
>> have no code to review.  The users that will use those flags are
>> going to be applications that run in user space.  Chances are you
>> will never see their code.  Heck, they might not even be open source
>> applications...
>
> Ummm - the specification defines what is compulsory for *filesystems*
> to implement, not what applications can use. We don't need to see
> what the applications do - what we care about is that all filesystems
> implement the compulsory part of the specification. That's the code
> we review, and that's what I was referring to.
>
>> And all applications will run against a multitude of
>> kernels.  So version X of the application will run on kernel 2.4.*,
>> 2.6.*, a.b.*, etc...  For future expandability of the interface I
>> think it is important to have both compulsory and non-compulsory  
>> flags.
>
> Ah, so that's what you want - a mutable interface. i.e. versioning.
>
> So how does compusory flags help here? What happens if a voluntary
> flag now becomes compulsory? Or vice versa? How is the application
> supposed to deal with this dynamically?
>
> I suggested a version number for this right back at the start of
> this discussion and got told that we don't want versioned interfaces
> because we should make the effort to get it right the first time.
> I don't think this can be called "getting it right".

Look at ext2/3/4.  They do it that way and it works well.  No  
versioning just compatible and incompatible flags...  The proposal is  
to do the same here.

>> For example there is no reason why FIEMAP_HSM_READ needs to be
>> compulsory.  Most filesystems do not support HSM so can safely ignore
>> it.
>
> They might be able to safely ignore it, but in reality it should
> be saying "I don't understand this". If the application *needs* to
> use a flag like this, then it should be told that the filesystem is
> not capable of doing what it was asked!

That is where you are completely wrong!  (-:  Or rather you are wrong  
for my example, i.e. you are wrong/right depending on the type of  
flag in question.  HSM_READ is definitely _NOT_ required because all  
it means is "if the file is OFFLINE, bring it ONLINE and then return  
the extent map".  Clearly all file systems that do not support HSM  
can 100% ignore this flag as all files will ALWAYS be ONLINE so they  
will return the correct data ALWAYS so no need to do anything for  
HSM_READ.

> OTOH if the application does not need to use the flag, then it
> shouldn't be using it and we shouldn't be silently ignoring
> incorrect usage of the provided API.
>
> What you are effectively saying about these "voluntary" flags
> is that their behaviour is _undefined_. That is, if you use
> these flags what you get on a successful call is undefined;
> it may or may not contain what you asked for but you can't
> tell if it really did what you want or returned the information
> you asked for.
>
> This is a really bad semantic to encode into an API.

That is your opinion.  There is nothing undefined in the API at all.   
You just fail to understand it...

>> And vice versa, an application might specify some weird and funky yet
>> to be developed feature that it expects the FS to perform and if the
>> FS cannot do it (either because it does not support it or because it
>> failed to perform the operation) the application expects the FS to
>> return an error and not to ignore the flag.  An example could be the
>> asked for FIEMAP_XATTR_FORK flag.  If that is implemented, and the FS
>> ignores it it will return the extent map for the file data instead of
>> the XATTR_FORK!  Not what the application wanted at all.  Ouch!  So
>> this is definitely a compulsory flag if I ever saw one.
>
> Yes, the correct answer is -EOPNOTSUPP or -EINVAL in this case. But
> we don't need a flag defined in the user visible API to tell us
> that we need to return an error here.

Heh? What are you talking about?  You need a flag to specify that you  
want XATTR_FORK.  If not how the hell does the application specify  
that it wants XATTR_FORK instead of DATA_FORK (default)?  Or are you  
of the opinion that FIEMAP should definitely not support XATTR_FORK.   
If the latter I fully agree.  This should be a separate API with  
named streams and the FD of the named stream should be passed to  
FIEMAP without the silly XATTR_FORK flag...

>> So as you see you must support both voluntary and compulsory flags...
>
> No, you've managed to convince me that they are not necessary and
> they are in fact a Bad Idea... ;)

We agree to disagree then.  I think they are a very Good Idea(TM).  (-;

>> Also consider what I said above about different kernels.  A new
>> feature is implemented in kernel 2.8.13 say that was not there before
>> and an application is updated to use that feature.  There will be
>> lots of instances where that application will still be run on older
>> kernels where this feature does not exist.
>
> This is *exactly* where silently ignoring flags really falls down.

It does not!

> On 2.8.13, the flag is silently ignored. On 2.8.14, the flag does
> something and it returns different structure contents for the same

No it does not.  You do NOT understand at all what we are talking  
about do you?!?

If a flag would do something weird like returning different data then  
OBVIOUSLY you would make this a mandatory flag and it will NOT be  
ignored!

You should know better than arguing with fallacies.  Seriously...

> state. Now how does the application writer know which is correct or
> how to tell the difference?  They have to guess or write detection
> code which is exactly what we want to avoid.

No they don't.  It is then a compulsory flag so your argument is  
totally moot.

> I objected to the UNKNOWN flag because it wasn't explicit
> in it's meaning - I'm doing the same thing here. An interface
> needs to be explicitly defined and should not have and undefined
> behaviour in it....

That is exactly the point.  It is explicitly defined and has NO  
undefined behaviour in it.  (-:

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
