Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D314029DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 10:18:50 -0500 (CDT)
Message-ID: <52177D59.3000804@sgi.com>
Date: Fri, 23 Aug 2013 10:18:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: v7 add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130822213148.224998379@sgi.com> <52169488.2040303@sandeen.net>
	<521762F4.4050603@sgi.com>
	<08C24AC4-BA56-41C5-BC5C-0DBE2A5C1033@sandeen.net>
	<5217785B.9010804@sgi.com> <52177AA0.5080403@sandeen.net>
In-Reply-To: <52177AA0.5080403@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 08/23/13 10:07, Eric Sandeen wrote:
> On 8/23/13 9:57 AM, Mark Tinguely wrote:
>> On 08/23/13 08:34, Eric Sandeen wrote:
>>> On Aug 23, 2013, at 8:26 AM, Mark Tinguely<tinguely@sgi.com>   wrote:
>>>
>>>> On 08/22/13 17:45, Eric Sandeen wrote:
>>>>> On 8/22/13 4:31 PM, Mark Tinguely wrote:
>>>>>
>>>>>> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
>>>>>> The result from the lseek() call will be printed to the output.
>>>>>> For example:
>>>>>>
>>>>>> xfs_io>    seek -h 609k
>>>>>> HOLE    630784
>>>>>>
>>>>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>>>>> ---
>>>>>>    version 7 or 8 - Eric what number is this?
>>>>>
>>>>> Go for 13, for luck!
>>>>>
>>>>> I think this looks ok, I won't torture you any longer.  If there's anything
>>>>> to fix up when it really gets used in earnest we can do it then.
>>>>>
>>>>> (it crossed my mind that for the "-r" and "-a" invocations it might be good to print
>>>>> out the offset which was sent for each SEEK_* "whence," but *shrug*)
>>>>>
>>>>> Thanks for all the iterations,
>>>>>
>>>>> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>>>>
>>>> Rich, hold off on commit, I can quickly add the whence. We can see how she sails.
>>>>
>>> Was just an idle thought... See if it makes sense I guess...
>>>
>>> Thanks,
>>> Eric
>>
>>
>> without whence:
>> xfs_io>  seek -ar 0
>> HOLE    0
>> DATA    528384
>> HOLE    532480
>> DATA    819200
>> HOLE    823296
>>
>> xfs_io>  seek -dh 512k
>> HOLE    524288
>> DATA    528384
>>
>> xfs_io>  seek -rd 0
>> DATA    528384
>> DATA    819200
>>
>> ============
>>
>> after with whence:
>
> Don't hate me, but if you do this, now I think it needs a header ;)

I was looking at the output and knew you were going to suggest it.

> I dunno, what do you think, does it have value in general?
>

for -ar no because we are alternating data and hole - the last result is 
the new input. But for all the holes and all the data it is an improvement.

The question is should we print the starting offset in only the "-r" 
option or for all cases to be consistent?

I vote to just add the starting offset in all output...

> I'd propose this:  Merge it as I reviewed it, if you're happy,
> just printing the results of the seeks.

Make sense to have it. Let me post the new version. of course the real 
luck of the irish is with me today, v7 has a bug in it. "wow, I could 
have had a v8".
>
> I was thinking that down the line just for edge case testing
> we might want to be able to pass in other "whences."
>
> Later enhancements could also add a "-w" option to explicitly print
> out the passed-in or recursively-selected "whence" if that output
> is desired for comparisons or sanity checking.
>
> Might be good to stop polishing this for now and do any other
> enhancements in later patches.
>
> Your call,
>
> -Eric
>
>> xfs_io>  seek -ar 0:
>> HOLE    0       0
>> DATA    0       528384
>> HOLE    528384  532480
>> DATA    532480  819200
>> HOLE    819200  823296
>>
>> xfs_io>  seek -dh 512k:
>>
>> HOLE    524288
>> DATA    528384
>>
>> xfs_io>  seek -rd 0
>> DATA    0       528384
>> DATA    532480  819200
>>
>> Seems to make most sense in the case of -rd and -rh
>>
>> --Mark.
>>
>

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
