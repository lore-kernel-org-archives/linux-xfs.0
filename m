Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 352FC7F50
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:14:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FF6B304039
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:14:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id x2MK9nArDwBYwCER for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 11:14:29 -0700 (PDT)
Message-ID: <520D1A82.1000709@sandeen.net>
Date: Thu, 15 Aug 2013 13:14:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <20130814062041.GB12779@dastard>
	<520BAE48.1020605@allmail.net> <520D0D5D.4000309@sandeen.net>
	<520D162B.5060901@allmail.net>
In-Reply-To: <520D162B.5060901@allmail.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Maier <m1278468@allmail.net>
Cc: xfs@oss.sgi.com

On 8/15/13 12:55 PM, Michael Maier wrote:
> Eric Sandeen wrote:
>> On 8/14/13 11:20 AM, Michael Maier wrote:
>>> Dave Chinner wrote:
>>
>> ...
>>
>>>> If it makes you feel any better, the bug that caused this had been
>>>> in the code for 15+ years and you are the first person I know of to
>>>> have ever hit it....
>>>
>>> Probably the second one :-) See
>>> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428
>>>
>>>> xfs_repair doesn't appear to have any checks in it to detect this
>>>> situation or repair it - there are some conditions for zeroing the
>>>> unused parts of a superblock, but they are focussed around detecting
>>>> and correcting damage caused by a buggy Irix 6.5-beta mkfs from 15
>>>> years ago.
>>>
>>> The _big problem_ is: xfs_repair not just doesn't repair it, but it
>>> _causes data loss_ in some situations!
>>>
>>
>> So as far as I can tell at this point, a few things have happened to
>> result in this unfortunate situation.  Congratulations, you hit a
>> perfect storm.  :(
> 
> I can appease you - as it "only" hit my backup device and because I
> noticed the problem before I really needed it: I didn't hit any data
> loss over all, because the original data is ok and I repeated the backup
> w/ the fixed FS now!
> 
>> 1) prior resize operations populated unused portions of backup sbs w/ junk
>> 2) newer kernels fail to verify superblocks in this state
>> 3) during your growfs under 3.10, that verification failure aborted
>>    backup superblock updates, leaving many unmodified
>> 4a) xfs_repair doesn't find or fix the junk in the backup sbs, and
>> 4b) when running, it looks for the superblocks which are "most matching"
>>     other superblocks on the disk, and takes that version as correct.
>>
>> So you had 16 superblocks (0-15) which were correct after the growfs.
>> But 16 didn't verify and was aborted, so nothing was updated after that.
>> This means that 16 onward have the wrong number of AGs and disk blocks;
>> i.e. they are the pre-growfs size, and there are 26 of them.
>>
>> Today, xfs_repair sees this 26-to-16 vote, and decides that the 26
>> matching superblocks "win," rewrites the first superblock with this
>> geometry, and uses that to verify the rest of the filesytem.  Hence
>> anything post-growfs looks out of bounds, and gets nuked.
>>
>> So right now, I'm thinking that the "proper geometry" heuristic should
>> be adjusted, but how to do that in general, I'm not sure.  Weighting
>> sb 0 heavily, especially if it matches many subsequent superblocks,
>> seems somewhat reasonable.
> 
> This would have been my next question! I repaired it w/ the git
> xfs_repair on the already reduced to original size FS. I think, if I
> would have done the same w/ the grown FS, the FS most probably would be
> reduced to the size before the growing.
> 
> Wouldn't it be better to not grow at all if there are problems detected?
> Means: Don't do the check after the growing, but before? Ok, I could
> have done it myself ... . From now on, I will do it like this!

well, see the next couple patches I'm about to send to the list ... ;)

but a check prior wouldn't have helped you, because repair didn't detect
the problem that growfs choked on.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
