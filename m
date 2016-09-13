Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76BFC7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 09:49:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 477A98F8050
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 07:49:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tvttVDwoHb0Ok3qR for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2016 07:49:25 -0700 (PDT)
Subject: Re: [PATCH] xfs_repair: update the manual content about xfs_repair
	exit status
References: <1473482849-5706-1-git-send-email-zlang@redhat.com>
	<0e20a2e5-eb5a-aa6c-eff7-e67d35c6f227@sandeen.net>
	<20160913144405.GG12847@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <424a93e5-dbd4-dbc1-1f2c-3ae57131fab8@sandeen.net>
Date: Tue, 13 Sep 2016 09:49:22 -0500
MIME-Version: 1.0
In-Reply-To: <20160913144405.GG12847@dhcp12-143.nay.redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com



On 9/13/16 9:44 AM, Zorro Lang wrote:
> On Mon, Sep 12, 2016 at 11:01:12AM -0500, Eric Sandeen wrote:
>> On 9/9/16 11:47 PM, Zorro Lang wrote:
>>> The man 8 xfs_repair said "xfs_repair run without the -n option will
>>> always return a status code of 0". That's not correct.
>>>
>>> xfs_repair will return 2 if it find valuable metadata changes in log
>>> which needs to be replayed, 1 if it can't fix the corruption or some
>>> other errors happened and 0 if nothing wrong or all the corruptions
>>> were fixed.
>>>
>>> Generally xfs_repair -L will always return 0, except it can't clear
>>> the log.
>>
>> And I think that's an operational type error, not the result
>> of a filesystem problem; more like an IO error, or a code bug,
>> I *think* ... more below.
>>
>>
>>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>>> ---
>>>
>>> Hi,
>>>
>>> I  trusted the xfs_repair manpage, and thought xfs_repair will always return 0.
>>> But recently I found it lies when I tried to review someone xfstests case.
>>>
>>> A correct manpage will help more people to write right cases, so I try to modify
>>> the manpage, by search all exit/do_error in xfsprogs/repair. I'm not the best
>>> one who learn about xfs_repair, so I just hope I did the right thing:-P Please
>>> feel free to correct me.
>>>
>>> Thanks,
>>> Zorro
>>>
>>>  man/man8/xfs_repair.8 | 13 ++++++++++++-
>>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
>>> index 1b4d9e3..1f8f13b 100644
>>> --- a/man/man8/xfs_repair.8
>>> +++ b/man/man8/xfs_repair.8
>>> @@ -504,12 +504,23 @@ that is known to be free. The entry is therefore invalid and is deleted.
>>>  This message refers to a large directory.
>>>  If the directory were small, the message would read "junking entry ...".
>>>  .SH EXIT STATUS
>>> +.TP
>>>  .B xfs_repair \-n
>>>  (no modify node)
>>>  will return a status of 1 if filesystem corruption was detected and
>>>  0 if no filesystem corruption was detected.
>>> +.TP
>>>  .B xfs_repair
>>> -run without the \-n option will always return a status code of 0.
>>> +run without the \-n option will return a status code of 2 if it find the
>>> +filesystem has valuable metadata changes in log which needs to be
>>> +replayed, 1 if there's corruption left to be fixed
>>
>> I'm not sure that's the best description; from a quick look, I think
>> those exit values of 1 result from do_error(), and in repair that's
>> (usually?) due to something like a memory allocation failure, or an
>> inconsistent state in the tool; more like hitting an ASSERT.  That might
>> leave corruption, but only as a follow-on effect.
> 
> Hi Eric,
> 
> Many thanks for you can help to review this patch.
> 
> I've check all code will exit(1), generally it caused by memory or disk
> errors. But some other situations likes:
>  - No enough matching AGs or superblocks
>  - Primary superblock bad after phase 1
>  - Sector size on host filesystem larger than image sector size, when try
>    to repair a file image
>  ...
> 
> will exit(1) too.

Sigh, ok.  I guess the exit(1) has proliferated a lot.  :(

> But yes, they're all belong to runtime error:) There're too many situations
> can return 1. But only one place can return 2, so we can say except return 0
> and 2, others will return 1 :-P
> 
> 
>>
>>> + or can't find log head
>>> +and tail or some other errors happened, 
>>
>> Which is the same as above, I think - an internal error.
>>
>>> and 0 if nothing wrong or all the
>>> +corruptions were fixed.
>>> +.TP
>>> +.B xfs_repair \-L
>>> +(Force Log Zeroing)
>>> +will return a status code of 1 if it can't clear the log, or will always
>>> +return 0.
>>
>>
>> How about something like this:
>>
>>  .B xfs_repair \-n
>>  (no modify node)
>>  will return a status of 1 if filesystem corruption was detected and
>>  0 if no filesystem corruption was detected.
>>  .TP
>>  .B xfs_repair
>>  run without the \-n option will return a status code of 2 if it finds a
>>  filesystem log which needs to be replayed (by a mount/umount cycle), 1 if
>>  a runtime error is encountered, and 0 in all other cases, whether or not
>>  filesystem corruption was detected.
> 
> Your patch(xfs_repair: exit with status 2 if log dirtiness is unknown) will
> make xfs_repair return 2, when it can't find log head/tail. I think xfs_repair
> won't think the log needs to be replayed if it can't find the log tail/head.
> 
> So how about "return a status code of 2 if it finds filesystem log needs to be
> replayed or cleared"?

That seems reasonable...

-Eric

> Thanks,
> Zorro
> 
>>
>> and I'd leave out the bit about xfs_repair -L; really that's just a runtime
>> error - if we clear the log and then can't find the head/tail, something
>> strange has gone wrong.
>>
>> Thanks,
>>
>> -Eric
>>
>>>  .SH BUGS
>>>  The filesystem to be checked and repaired must have been
>>>  unmounted cleanly using normal system administration procedures
>>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
