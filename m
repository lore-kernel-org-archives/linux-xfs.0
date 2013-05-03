Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B84529DF8
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 09:43:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 579E98F8052
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 07:43:09 -0700 (PDT)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id BmHpbyQYjgI0hfzR for <xfs@oss.sgi.com>;
	Fri, 03 May 2013 07:43:08 -0700 (PDT)
Message-ID: <5183CCFB.8060505@jan-o-sch.net>
Date: Fri, 03 May 2013 16:43:07 +0200
From: Jan Schmidt <list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add execution of a custom command to fsstress
	(-x and -X options)
References: <1363863585-25598-1-git-send-email-list.xfs@jan-o-sch.net>
	<20130321195054.GO17758@dastard> <514B72B9.1010005@jan-o-sch.net>
	<20130321211218.GP17758@dastard> <514C0309.1000104@jan-o-sch.net>
	<20130324235135.GH6369@dastard> <515EBE9E.3000905@jan-o-sch.net>
In-Reply-To: <515EBE9E.3000905@jan-o-sch.net>
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
To: xfs@oss.sgi.com

On Fri, April 05, 2013 at 14:07 (+0200), Jan Schmidt wrote:
> 
> On Mon, March 25, 2013 at 00:51 (+0100), Dave Chinner wrote:
>> On Fri, Mar 22, 2013 at 08:06:49AM +0100, Jan Schmidt wrote:
>>> On Thu, March 21, 2013 at 22:12 (+0100), Dave Chinner wrote:> On Thu, Mar 21,
>>> 2013 at 09:51:05PM +0100, Jan Schmidt wrote:
>>>>>
>>>>>
>>>>> On 21.03.2013 20:50, Dave Chinner wrote:
>>>>>> On Thu, Mar 21, 2013 at 11:59:45AM +0100, Jan Schmidt wrote:
>>>>>>> From: Jan Schmidt <list.btrfs@jan-o-sch.net>
>>>>>>>
>>>>>>> This patch adds execution of a custom command in the middle of all fsstress
>>>>>>> operations. Its intended use is the creation of snapshots in the middle of a
>>>>>>> test run.
>>>>>>
>>>>>> Why do you need fsstress to do this? Why can't you just run fsstress
>>>>>> in the background and run a loop creating periodic snapshots in the
>>>>>> control script?
>>>>>
>>>>> Because I want reproducible results. Same random seed should result in
>>>>> the very same snapshots being created.
>>>>
>>>> Why can't you run fsstress for N operations, run a snapshot,
>>>> then run it again for M operations? That will give you exactly the
>>>> same results, wouldn't it?
>>>
>>> As far as I have understood what fsstress does, the second run would generate
>>> different filenames, i.e. it would never rename / truncate / punch holes into /
>>> ... files  created by the first run - it cannot even know that they exist.
>>
>> Yes, you are right.
>>
>>>>>> Also, did you intend that every process creates a snapshot? i.e. it
>>>>>> looks lik eif you run a 1000 processes, they'll all run a snapshot
>>>>>> operation at X operations? i.e. this will generate nproc * X
>>>>>> snapshots in a single run. This doesn't seem very wise to me....
>>>>>
>>>>> Agreed, I haven't thought of running more than one process. For the sake
>>>>> of reproducibility, I wouldn't want multiple processes for my test case
>>>>> either.
>>>>>
>>>>> I'm not sure if there are other applications than snapshot creation for
>>>>> such a feature, so I cannot argue whether to have each process execute
>>>>> such a command or not.
>>>>
>>>> If such a feature is necessary, I'd suggest that implementing the
>>>> snapshot ioctl as just another operation directly into fsstress is
>>>> probably a better way to implement this functionality. That way you
>>>> can control the frequency via the command line in exactly the same
>>>> way as every other operation....
>>>
>>> What I currently need is a function to make one reasonably weird snapshot. So my
>>> plan goes like this: do n weird operations, make a snapshot (this is going to be
>>> the base snapshot), do n weird operations (partly to the same files), make a
>>> second snapshot (this is going to be the incremental snapshot, I create that one
>>> myself after fsstress is done, currently). Having both snapshots with an equal
>>> number of modification operations isn't required, however at least a fair number
>>> of operations for each of them is desired.
>>
>> Ah, so you're wanting to test incremental backups based on
>> snapshots. Ok, that context puts it in a different light....
>>
>>> Adding it as a normal fsstress operation would generate a whole lot of
>>> snapshots. I could, for like 50k operations, scale all the factors for each
>>> operation accordingly to get a single snapshot out of it. I still won't force it
>>> anywhere near the middle that way, though. Also, going from 50k operation to 60k
>>> operations gets cumbersome that way.
>>
>> *nod*
>>
>>> Plumbing that into fsstress the way I did is the only solution I could think of
>>> to reach the mentioned goals. If nobody else needs it, I can of course keep it
>>> local, here. However, I'd really like to make an xfstest out of it sooner or
>>> later - currently, we've no test at all for (btrfs) send and receive.
>>
>> For send/receive, you should probably start with some basic tests
>> that are easy to verify first. e.g. the equivalent of the basic
>> incremental xfsdump/restore tests like 064/065 which do well
>> defined, easy to verify operations to determine correct behaviour.
> 
> That sounds like a good start.
> 
>> I can see the value in adding a random variant in addition to these
>> basic tests, so I can see how having a predictable callout from
>> fsstress would be useful for incremental xfsdump/restore testing as
>> well.
>>
>> FWIW, what does you current callout execute? A shell script that
>> runs a bunch of other commands that ends with a btrfs send?
> 
> It's basically just "btrfs subvol snapshot", but yeah, for more complex things
> I'd put a shell script there.
> 
>> The biggest question I have about this is how to make it valuable
>> for more types of fsstress execution, especially concurrent
>> execution. I can't see a use (yet) for a per-process callout, but
>> I'm wondering if we should have some kind of "wait for all processes
>> to do N ops, then run the callout" style of synchronisation.
>>
>> I'm not sure what is best here as I don't know the full context of
>> what you are wanting to test (and how), but I think we can come up
>> with something better than "only works for single process
>> invocations". :)
> 
> Well, in fact you do have the full context of what I'm wanting to test, as far
> as I can see it.
> 
> I bet we could came up with a suggestion how to interpret something like the
> proposed -x switch in multi process context. However, I don't like to code for
> hypothetic situations I cannot really imagine a use case for. So, the best thing
> I came up with is a switch that can do something meaningful in single process
> applications of fsstress.
> 
> I'm happy to code the rest of it, if a good suggestion comes up how this could
> be handled and how it could be useful to others as well.

Looks like there are no suggestions how to make -x useful for multiple workers.
Can we then have the single worker solution (original patch) merged for now?

-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
