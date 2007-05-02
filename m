Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 04:19:31 -0700 (PDT)
Received: from ppsw-7.csi.cam.ac.uk (ppsw-7.csi.cam.ac.uk [131.111.8.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l42BJPfB003965
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 04:19:27 -0700
In-Reply-To: <20070502105749.GY77450368@melbourne.sgi.com>
References: <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com> <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk> <20070502091526.GW77450368@melbourne.sgi.com> <2604946E-CF10-426F-9720-DDABD10C8E0D@cam.ac.uk> <20070502105749.GY77450368@melbourne.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A7C19F3B-80E2-437F-BC81-ED1C17EEFE0C@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 12:17:32 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org


On 2 May 2007, at 11:57, David Chinner wrote:

> On Wed, May 02, 2007 at 10:36:12AM +0100, Anton Altaparmakov wrote:
>> On 2 May 2007, at 10:15, David Chinner wrote:
>>> On Tue, May 01, 2007 at 07:46:53PM +0100, Anton Altaparmakov wrote:
>>>> And all applications will run against a multitude of
>>>> kernels.  So version X of the application will run on kernel 2.4.*,
>>>> 2.6.*, a.b.*, etc...  For future expandability of the interface I
>>>> think it is important to have both compulsory and non-compulsory
>>>> flags.
>>>
>>> Ah, so that's what you want - a mutable interface. i.e. versioning.
>>>
>>> So how does compusory flags help here? What happens if a voluntary
>>> flag now becomes compulsory? Or vice versa? How is the application
>>> supposed to deal with this dynamically?
>>>
>>> I suggested a version number for this right back at the start of
>>> this discussion and got told that we don't want versioned interfaces
>>> because we should make the effort to get it right the first time.
>>> I don't think this can be called "getting it right".
>>
>> Look at ext2/3/4.  They do it that way and it works well.  No
>> versioning just compatible and incompatible flags...  The proposal is
>> to do the same here.
>
> Just because it works for extN doesn't make it right for this
> interface.
>
>>>> For example there is no reason why FIEMAP_HSM_READ needs to be
>>>> compulsory.  Most filesystems do not support HSM so can safely  
>>>> ignore
>>>> it.
>>>
>>> They might be able to safely ignore it, but in reality it should
>>> be saying "I don't understand this". If the application *needs* to
>>> use a flag like this, then it should be told that the filesystem is
>>> not capable of doing what it was asked!
>>
>> That is where you are completely wrong!  (-:  Or rather you are wrong
>> for my example, i.e. you are wrong/right depending on the type of
>> flag in question.
>
> And that is the crux of the argument.
>
> My point is that *any* flag returns an error if the filesystem
> does not support it.

Yes and my point is that it should not do so as there are flags where  
it is not necessary.

>> HSM_READ is definitely _NOT_ required because all
>> it means is "if the file is OFFLINE, bring it ONLINE and then return
>> the extent map".
>
> You've got the definition of HSM_READ wrong. If the flag is *not*
> set, then we bring everything back online and return the full extent
> map.

Ah, sorry, I did indeed misunderstand what it was meant to mean.

>>> OTOH if the application does not need to use the flag, then it
>>> shouldn't be using it and we shouldn't be silently ignoring
>>> incorrect usage of the provided API.
>>>
>>> What you are effectively saying about these "voluntary" flags
>>> is that their behaviour is _undefined_. That is, if you use
>>> these flags what you get on a successful call is undefined;
>>> it may or may not contain what you asked for but you can't
>>> tell if it really did what you want or returned the information
>>> you asked for.
>>>
>>> This is a really bad semantic to encode into an API.
>>
>> That is your opinion.  There is nothing undefined in the API at all.
>> You just fail to understand it...
>
> FIEMAP returned success. Did it do what I asked? I don't
> know because it's allowed to return success when it did ignored me.

So what?

> This is as silly an interface definition as saying you can
> implement fsync() with { return 0; }.  So, when fsync() succeeded
> did it write my data to disk? I don't know; it's allowed to return
> success when it ignored me.

No it is not silly at all.  There can be flags that fail but still  
the operation is a success.

Example from admittedly unrelated area: when truncating a file to  
smaller size if the freeing of the allocated blocks fails it does not  
cause the truncate to fail, it just means some space is wasted/marked  
used when it is unused on the volume and running fsck fixes this.  At  
least that is how I have implemented it for NTFS and I think this is  
the most sensible way to do it.  The user does not care if some  
blocks could not be freed.  All they care about is that the file is  
now truncated.  The volume is then marked dirty thus running fsck/ 
chkdsk will reclaim the lost space.

> It's crazy, isn't it? It makes writing applications portable
> across operating systems a real PITA (ask the MySQL folk ;)
> because POSIX really does allow fsync() to be implemented like this.
>
> I use this example because the "allow some filesystems to silently
> ignore flags they don't understand" is a portability problem for
> applications - rather than a cross-OS issue it is a cross-filesystem
> issue. That is, if different filesystems behave differently to
> the same request they will have to be handled specifically by
> the application. Every filesystem should behave in *exactly* the
> same way to the FIEMAP ioctls - if they don't support something
> they throw an error, if they do then they return the correct
> data.

It is only a problem if you do not choose wisely which flags my be  
ignored silently...

>>>> And vice versa, an application might specify some weird and  
>>>> funky yet
>>>> to be developed feature that it expects the FS to perform and if  
>>>> the
>>>> FS cannot do it (either because it does not support it or  
>>>> because it
>>>> failed to perform the operation) the application expects the FS to
>>>> return an error and not to ignore the flag.  An example could be  
>>>> the
>>>> asked for FIEMAP_XATTR_FORK flag.  If that is implemented, and  
>>>> the FS
>>>> ignores it it will return the extent map for the file data  
>>>> instead of
>>>> the XATTR_FORK!  Not what the application wanted at all.  Ouch!  So
>>>> this is definitely a compulsory flag if I ever saw one.
>>>
>>> Yes, the correct answer is -EOPNOTSUPP or -EINVAL in this case. But
>>> we don't need a flag defined in the user visible API to tell us
>>> that we need to return an error here.
>>
>> Heh? What are you talking about?  You need a flag to specify that you
>> want XATTR_FORK.  If not how the hell does the application specify
>> that it wants XATTR_FORK instead of DATA_FORK (default)?  Or are you
>> of the opinion that FIEMAP should definitely not support XATTR_FORK.
>> If the latter I fully agree.  This should be a separate API with
>> named streams and the FD of the named stream should be passed to
>> FIEMAP without the silly XATTR_FORK flag...
>
> Ummmm - I think you misunderstood what I was saying. I was agreeing
> with you that is a FS does not support FIEMAP_XATTR_FORK "the correct
> answer is -EOPNOTSUPP or -EINVAL".
>
> What I was saying is that we don't need a COMPAT flag bit to tell
> us the obvious error return if the filesystem does not support this
> functionality....

But there is no COMPAT bit.  I don't understand what you are saying...

>>>> Also consider what I said above about different kernels.  A new
>>>> feature is implemented in kernel 2.8.13 say that was not there  
>>>> before
>>>> and an application is updated to use that feature.  There will be
>>>> lots of instances where that application will still be run on older
>>>> kernels where this feature does not exist.
>>>
>>> This is *exactly* where silently ignoring flags really falls down.
>>
>> It does not!
>>
>>> On 2.8.13, the flag is silently ignored. On 2.8.14, the flag does
>>> something and it returns different structure contents for the same
>>
>> No it does not.  You do NOT understand at all what we are talking
>> about do you?!?
>>
>> If a flag would do something weird like returning different data then
>> OBVIOUSLY you would make this a mandatory flag and it will NOT be
>> ignored!
>
> You've just successfully argued my case for me.

No I have not at all.

> By your reasoning, if we have voluntary flags 1, 2 and 3 and
> filesystems A, B and C and filesystem A is the only filesystem to
> implement 1, when B implements 1 bit must become a compulsory flag

WHY?  It does not at all.  Flags CANNOT move from voluntary to  
compulsory.  Read my argument again...

> and hence C must now return an error despite being unchanged.

Nope.

> Likewise when C implement 3, 3 must become a comulsory flag and
> A and B must now return an error despite being unchanged.

Again no.

> IOWs, whenever *any* filesystem implements a voluntary feature that
> it didn't previously support, we have to make that a mandatory
> feature and all other filesystems that don't support it now

This is total crap.

> must return an error. You're guaranteeing th application sees
> changes in behaviour with this interface, not preventing.
>
> Can we simply mandate that filesystems return an error
> to commands they don't support or don't understand and
> drop this silly interface mutation thing?

Can we simply not and drop this silly argument?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
