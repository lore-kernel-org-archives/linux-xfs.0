Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E16E7FBF
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 16:00:58 -0500 (CDT)
Message-ID: <5213D909.8020805@sgi.com>
Date: Tue, 20 Aug 2013 16:00:57 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com>
	<5212AA1D.3000809@sandeen.net> <52137D3D.8060205@sgi.com>
	<52138111.1030109@sandeen.net> <20130820185037.GB5262@sgi.com>
In-Reply-To: <20130820185037.GB5262@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 08/20/13 13:50, Ben Myers wrote:
> Eric,
>
> On Tue, Aug 20, 2013 at 09:45:37AM -0500, Eric Sandeen wrote:
>> On 8/20/13 9:29 AM, Mark Tinguely wrote:
>>> On 08/19/13 18:28, Eric Sandeen wrote:
>>>> On 8/19/13 3:19 PM, Mark Tinguely wrote:
>>>>
>>>> <an attachment that doesn't show up on reply, moving d_type support
>>>> to v4 superblocks ;)>
>>>>
>>>> Thanks, Mark!
>>>>
>>>> Has you been able to test this at all?
>>
>> Hi Mark -
>>
>>> There is no test for this feature.
>>
>> no xfstest, I know.  :)
>>
>>> Yes I did my version of testing.
>>> First adding each type of inode type and verifying it. Then fsstress
>>> testing using the same seed for sb v4+feature, v4 plain, v5+feature.
>>> The resulting directory and checked with xfs_db. fsstress was chosen
>>> because how it manipulate directory items.
>>>
>>>>
>>>> I do still owe a promised xfstest - but for that, we'll need at
>>>> least mkfs&   xfs_repair support.
>>>>
>>>
>>> Dave made changes so that xfs_repair will run (find the correct
>>> directory items) but the feature verification and repairs has not
>>> been done, so technically this is an incomplete feature.
>>
>> Right, but Dave's patches only recognize it as a valid feature
>> on V5 superblocks; V4 will take a bit more logic, won't it?
>> Won't repair see this as an invalid feature flag on V4 even
>> with Dave's patches?
>
> That's a good point.  I have not looked at Mark's patch to see if this has been
> done.  Mark?

The user and kernel space share the code for feature compatibility check 
code. Does the code support the feature ....

... Yes, Dave made the changes so that xfs_repair works with feature 
turned off or on.

Are you sure...

... Yes, the repair xfstests work the same for v4 feature on or off.

>
>>>> Did you patch up mkfs to do basic tests of your kernelspace patch?
>>>
>>> yes. to the directory area in mkfs per suggestion.
>>>
>>> The tests run the same on the v5 and v4 - ummm, it is the same
>>> directory code. see above.
>>>
>>>>
>>>> Talking to Dave, he reminds me of a few things this needs, if it's
>>>> going to be complete&   compatible on V4:
>>>>
>>>> * mkfs.xfs commandline option support&   manpage updates
>>>
>>> yes
>>>
>>>> * xfs_db support (including version friendly-text output)
>>>
>>> yes, xfsprogs v4/v5 uses the same directory code, Dave's patches
>>> support xfs_db. It works for v4/v5.
>>
>> ok
>>
>>>
>>>> * XFS_IOC_FSGEOM support so that xfs_info can report the
>>>> difference * xfs_repair needs to know that it's a valid feature on
>>>> V4
>>>
>>> okay, it will run xfs_repair to the same level as v5. AND ...As
>>> pointed out, there is no xfs_repair support to verify/correct the
>>> feature in v5 and therefore v4 - (again it is the same directory
>>> code). As is, this feature is incomplete. That could keep the kernel
>>> portion from moving forward.
>>>
>>>> Some of that may overlap w/ things still needed on V5, but some is
>>>> unique to allowing it on V4.
>>>>
>>>> Mark, do you plan to do some of those unique-to-V4 parts, too?
>>>
>>> Yes.
>>
>> Ok, cool.
>>
>>>>
>>>> As an aside: I would support getting this feature onto V4
>>>> superblocks, after we have confidence that all the bits are done,
>>>> tested, and robust.
>>>>
>>>> I still would really like to see it go forward in parallel on V5,
>>>> and not be blocked by the extra work needed for proper V4
>>>> integration.
>>>>
>>>
>>> understood - now documented.  Hi Linus.
>>
>> I'm Eric ;)
>
> ;)
>
>>> This feature uses shared directory code. It has to be turned on using
>>> a mkfs to be used. No one will accidentally get this feature.
>>>
>>> The feature and implementation are good. The directory code is common
>>> - the feature added changes to that directory code. If the
>>> implementation is bad it will trash the v4/v5 directories the same -
>>> no matter if the feature is turned on or off. If you are so afraid of
>>> the common code may break any directories, then this feature should
>>> be held back for more testing.
>>
>> I'm not overly fearful...
>>
>>> All that I insist is this nice feature be added to the mainstream
>>> filesystem at the same time as the experimental filesystem. There is
>>> NO TECHNICAL reason that this feature is not supported mainstream
>>> filesystem.
>>
>> No, not technical... (although, there is also no technical reason that
>> V4 and V5 must go in at the same time, so we're into the realm of
>> opinion&  preference here)
>
> IMO if this were clearly related to the v5 super block features we could soften
> the line regarding whether it must be finished before it goes in.  But it seems
> not to be directly related.
>
>> One reason I'd argue for V5 potentially prior to V4 is that V4 requires
>> a few more code changes over and above V5.  If those V4 changes lag,
>> it it might make sense to separate them.  If they don't lag, great.
>
> As I mentioned on the call last week, I am sympathetic to this viewpoint.
> Having said that... I also think Mark and Geoffrey also have a good point in
> saying that since this isn't a v5 feature it's not experimental code, and it
> needs to be completed before we pull it in, and this should include the v4
> implementation.
>
> Seems like we haven't seen the completion of the v5 version of this code at
> this point, so the argument of whether v4 should gate it for 3.12 is kind of
> moot.  I do prefer that they go in together, not being an experimental
> feature... and it would be nice if we can make that happen in 3.12.
>
>>> I repeat, if you have technical concerns for the feature's
>>> implementation and its impact on v4 filesystems because it uses
>>> common directory code, then it should be held back for more testing.
>>
>> I'm not trying to pick a fight.
>
> Thanks.  If we can have such minor disagreements without resorting to
> badmouthing myself as maintainer and the rest of the SGI team on the list I
> really do appreciate it.  Our people are well intentioned, want to help, and
> they deserve better.  As do the rest of the contributors.

oops, I already delivered my badmouthing in person....I (literally) told 
him in a whiny voice, with arms flailing in the air, to R-T-F-Patches 
already.

>
>> I just want to make sure that all
>> the new work unique to having it on V4 is identified&  owned...
>
> Good plan.  I think Mark needs to look at the xfs_repair issue you mentioned.
> Sounds like xfs_db already works.
>

done.

> Thanks,
> 	Ben
>

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
