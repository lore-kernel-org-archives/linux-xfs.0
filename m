Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 May 2007 11:48:44 -0700 (PDT)
Received: from ppsw-9.csi.cam.ac.uk (ppsw-9.csi.cam.ac.uk [131.111.8.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l41ImefB006913
	for <xfs@oss.sgi.com>; Tue, 1 May 2007 11:48:41 -0700
In-Reply-To: <20070501142049.GG77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Tue, 1 May 2007 19:46:53 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On 1 May 2007, at 15:20, David Chinner wrote:
> On Mon, Apr 30, 2007 at 09:39:06PM -0700, Nicholas Miell wrote:
>> On Tue, 2007-05-01 at 14:22 +1000, David Chinner wrote:
>>> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
>>>> This is actually for future use.  Any flags that are added into  
>>>> this
>>>> range must be understood by both sides or it should be  
>>>> considered an
>>>> error.  Flags outside the FIEMAP_FLAG_INCOMPAT do not  
>>>> necessarily need
>>>> to be supported.  If it turns out that 8 bits is too small a  
>>>> range for
>>>> INCOMPAT flags, then we can make 0x01000000 an incompat flag  
>>>> that means
>>>> e.g. 0x00ff0000 are also incompat flags also.
>>>
>>> Ah, ok. So it's not really a set of "compatibility" flags, it's  
>>> more a
>>> "compulsory" set. Under those terms, i don't really see why this is
>>> necessary - either the filesystem will understand the flags or it  
>>> will
>>> return EINVAL or ignore them...
>>>
>>>> I'm assuming that all flags that will be in the original FIEMAP  
>>>> proposal
>>>> will be understood by the implementations.  Most filesystems can  
>>>> safely
>>>> ignore FLAG_HSM_READ, for example, since they don't support HSM,  
>>>> and for
>>>> that matter FLAG_SYNC is probably moot for most filesystems also  
>>>> because
>>>> they do block allocation at preprw time.
>>>
>>> Exactly my point - so why do we really need to encode a  
>>> compulsory set of
>>
>> Because flags have meaning, independent of whether or not the  
>> filesystem
>> understands them. And if the filesystem chooses to ignore critically
>> important flags (instead of returning EINVAL), bad things may happen.
>>
>> So, either the filesystem will understand the flag or iff the  
>> unknown flag
>> is in the incompat set, it will return EINVAL or else the unknown  
>> flag will
>> be safely ignored.
>
> My point was that there is a difference between specification and
> implementation - if the specification says something is compulsory,
> then they must be implemented in the filesystem. This is easy
> enough to ensure by code review - we don't need additional interface
> complexity for this....

You are wrong about this because you are missing the point that you  
have no code to review.  The users that will use those flags are  
going to be applications that run in user space.  Chances are you  
will never see their code.  Heck, they might not even be open source  
applications...  And all applications will run against a multitude of  
kernels.  So version X of the application will run on kernel 2.4.*,  
2.6.*, a.b.*, etc...  For future expandability of the interface I  
think it is important to have both compulsory and non-compulsory flags.

For example there is no reason why FIEMAP_HSM_READ needs to be  
compulsory.  Most filesystems do not support HSM so can safely ignore  
it.  And applications that want to read/write the data locations that  
are obtained with the FIEMAP call will likely always supply  
FIEMAP_HSM_READ because they want to ensure the file is brought in if  
it is off line so they definitely want file systems that do not  
support this flag to ignore it.

And vice versa, an application might specify some weird and funky yet  
to be developed feature that it expects the FS to perform and if the  
FS cannot do it (either because it does not support it or because it  
failed to perform the operation) the application expects the FS to  
return an error and not to ignore the flag.  An example could be the  
asked for FIEMAP_XATTR_FORK flag.  If that is implemented, and the FS  
ignores it it will return the extent map for the file data instead of  
the XATTR_FORK!  Not what the application wanted at all.  Ouch!  So  
this is definitely a compulsory flag if I ever saw one.

So as you see you must support both voluntary and compulsory flags...

Also consider what I said above about different kernels.  A new  
feature is implemented in kernel 2.8.13 say that was not there before  
and an application is updated to use that feature.  There will be  
lots of instances where that application will still be run on older  
kernels where this feature does not exist.  Depending on the feature  
it may be quite sensible to simply ignore in the kernel that the  
application set an unknown flag whilst for a different feature it may  
be the opposite.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
