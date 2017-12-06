Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34018 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751610AbdLFXBL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 18:01:11 -0500
Subject: Re: [PATCH v7] generic: initial fiemap range query test
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
 <20171206174506.GI19219@magnolia>
 <0d1b5c25-9187-1405-17a2-1e44b65c53a8@suse.com>
 <20171206210659.GE6896@magnolia> <20171206215711.GG5858@dastard>
 <61675ab2-0943-e5d7-8c94-247d3ef68a05@sandeen.net>
 <20171206221603.GH5858@dastard> <20171206224627.GO19219@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <99fbcf74-7508-286e-590a-25e90ad904e1@sandeen.net>
Date: Wed, 6 Dec 2017 17:01:09 -0600
MIME-Version: 1.0
In-Reply-To: <20171206224627.GO19219@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: Nikolay Borisov <nborisov@suse.com>, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org



On 12/6/17 4:46 PM, Darrick J. Wong wrote:
> On Thu, Dec 07, 2017 at 09:16:03AM +1100, Dave Chinner wrote:
>> On Wed, Dec 06, 2017 at 04:01:58PM -0600, Eric Sandeen wrote:
>>> On 12/6/17 3:57 PM, Dave Chinner wrote:
>>>
>>>> There's a *simple answer* to this problem: fix the new command's
>>>> output.
>>>>
>>>> That is: the user asked for a specific range, so the command itself
>>>> should trim the map returned by the kernel to only display the exact
>>>> range the user asked for.  Then it doesn't matter if the underlying
>>>> filesystem trims the extents or not, because the we're going to do
>>>> that anyway in userspace.
>>>
>>> I have a different opinion:
>>>
>>> xfs_io is a debugging tool; the fiemap command sends an ioctl to the kernel.
>>>
>>> Ranged fiemap queries are a real thing; you put numbers into the kernel,
>>> and you get numbers out of the kernel.
>>>
>>> IMNSO, xfs_io should present to the user /what the kernel returned/,
>>> and not re-interpret it to fit some other notion of correctness if we
>>> don't like what the kernel told us.
>>
>> I hardly think "trimming to the range the user asked for" is
>> "re-interpreting what the kernel told us". It's limiting output
>> range to exactly what the user asked for - the output is still
>> correct regardless of how it's filtered to match what the user asked
>> for....
> 
> ...except that xfs_io is a tool we use to debug the garbage that FIEMAP
> sprays back at userspace, so it absolutely should not be hiding things
> like this from the test suite:

That's the point I was trying, I guess badly, to make.  If I send a patch
for xfs which essentially does this in fiemap:

if (ranged_query && last_block_in_range_allocated)
   last_extent.length += 42;

have I introduced a bug or not?

-Eric
