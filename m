Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72AA67F37
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 02:06:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 511608F8050
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 00:06:53 -0700 (PDT)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id JaZ9yPqAlUdxWtDo for <xfs@oss.sgi.com>;
	Fri, 22 Mar 2013 00:06:51 -0700 (PDT)
Message-ID: <514C0309.1000104@jan-o-sch.net>
Date: Fri, 22 Mar 2013 08:06:49 +0100
From: Jan Schmidt <list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add execution of a custom command to fsstress
	(-x and -X options)
References: <1363863585-25598-1-git-send-email-list.xfs@jan-o-sch.net>
	<20130321195054.GO17758@dastard> <514B72B9.1010005@jan-o-sch.net>
	<20130321211218.GP17758@dastard>
In-Reply-To: <20130321211218.GP17758@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, March 21, 2013 at 22:12 (+0100), Dave Chinner wrote:> On Thu, Mar 21,
2013 at 09:51:05PM +0100, Jan Schmidt wrote:
>>
>>
>> On 21.03.2013 20:50, Dave Chinner wrote:
>>> On Thu, Mar 21, 2013 at 11:59:45AM +0100, Jan Schmidt wrote:
>>>> From: Jan Schmidt <list.btrfs@jan-o-sch.net>
>>>>
>>>> This patch adds execution of a custom command in the middle of all fsstress
>>>> operations. Its intended use is the creation of snapshots in the middle of a
>>>> test run.
>>>
>>> Why do you need fsstress to do this? Why can't you just run fsstress
>>> in the background and run a loop creating periodic snapshots in the
>>> control script?
>>
>> Because I want reproducible results. Same random seed should result in
>> the very same snapshots being created.
> 
> Why can't you run fsstress for N operations, run a snapshot,
> then run it again for M operations? That will give you exactly the
> same results, wouldn't it?

As far as I have understood what fsstress does, the second run would generate
different filenames, i.e. it would never rename / truncate / punch holes into /
... files  created by the first run - it cannot even know that they exist.

>>> Also, did you intend that every process creates a snapshot? i.e. it
>>> looks lik eif you run a 1000 processes, they'll all run a snapshot
>>> operation at X operations? i.e. this will generate nproc * X
>>> snapshots in a single run. This doesn't seem very wise to me....
>>
>> Agreed, I haven't thought of running more than one process. For the sake
>> of reproducibility, I wouldn't want multiple processes for my test case
>> either.
>>
>> I'm not sure if there are other applications than snapshot creation for
>> such a feature, so I cannot argue whether to have each process execute
>> such a command or not.
> 
> If such a feature is necessary, I'd suggest that implementing the
> snapshot ioctl as just another operation directly into fsstress is
> probably a better way to implement this functionality. That way you
> can control the frequency via the command line in exactly the same
> way as every other operation....

What I currently need is a function to make one reasonably weird snapshot. So my
plan goes like this: do n weird operations, make a snapshot (this is going to be
the base snapshot), do n weird operations (partly to the same files), make a
second snapshot (this is going to be the incremental snapshot, I create that one
myself after fsstress is done, currently). Having both snapshots with an equal
number of modification operations isn't required, however at least a fair number
of operations for each of them is desired.

Adding it as a normal fsstress operation would generate a whole lot of
snapshots. I could, for like 50k operations, scale all the factors for each
operation accordingly to get a single snapshot out of it. I still won't force it
anywhere near the middle that way, though. Also, going from 50k operation to 60k
operations gets cumbersome that way.

Plumbing that into fsstress the way I did is the only solution I could think of
to reach the mentioned goals. If nobody else needs it, I can of course keep it
local, here. However, I'd really like to make an xfstest out of it sooner or
later - currently, we've no test at all for (btrfs) send and receive.

-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
