Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:51850 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdAWJyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 04:54:01 -0500
Subject: Re: Quota-enabled XFS hangs during mount
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
 <20161101215803.GA14023@dastard>
 <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
 <20161103013153.GH9920@dastard>
 <7993e9b8-6eb8-6a0d-aa72-01346cca1b63@zoner.cz>
 <20161103204049.GA28177@dastard>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <43ca55d0-6762-d54f-5ba9-a83f9c1988f6@zoner.cz>
Date: Mon, 23 Jan 2017 10:44:20 +0100
MIME-Version: 1.0
In-Reply-To: <20161103204049.GA28177@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hello Dave,

Any updates on this? It's a bit annoying to workaround the bug by increasing RAM just because of the
initial quotacheck.

Thank you,
Martin

Dne 3.11.2016 v 21:40 Dave Chinner napsal(a):
> On Thu, Nov 03, 2016 at 01:04:39PM +0100, Martin Svec wrote:
>> Dne 3.11.2016 v 2:31 Dave Chinner napsal(a):
>>> On Wed, Nov 02, 2016 at 05:31:00PM +0100, Martin Svec wrote:
>>>>> How many inodes? How much RAM?
>>>> orthosie:~# df -i
>>>> Filesystem        Inodes   IUsed     IFree IUse% Mounted on
>>>> /dev/sdd1      173746096 5214637 168531459    4% /www
>>>>
>>>> The virtual machine has 2 virtual cores and 2 GB RAM. None of it is a bottleneck, I think.
>>> Even though you think this is irrelevant and not important, it
>>> actually points me directly at a potential vector and a reason as to
>>> why this is not a comonly seen problem.
>>>
>>> i.e. 5.2 million inodes with only 2GB RAM is enough to cause memory
>>> pressure during a quotacheck. inode buffers alone will require
>>> a minimum of 1.5GB RAM over the course of the quotacheck, and memory
>>> reclaim will iterate cached dquots and try to flush them, thereby
>>> exercising the flush lock /before/ the quotacheck scan completion
>>> dquot writeback tries to take it.
>>>
>>> Now I need to go read code....
>> Yes, that makes sense, I didn't know that quotacheck requires all inodes to be loaded in memory at
>> the same time.
> It doesn't require all inodes to be loaded into memory. Indeed, the
> /inodes/ don't get cached during a quotacheck. What does get cached
> is the metadata buffers that are traversed - th eproblem comes when
> the caches are being reclaimed....
>
>> I temporarily increased virtual machine's RAM to 3GB and the
>> problem is gone! Setting RAM back to 2GB reproducibly causes the
>> quotacheck to freeze again, 1GB of RAM results in OOM... So you're
>> right that the flush deadlock is triggered by a memory pressure.
> Good to know.
>
>> Sorry, I forgot to attach sysrq-w output to the previous response. Here it is:
> <snip>
>
> ok, nothing else apparently stuck, so this is likely a leaked lock
> or completion.
>
> Ok, I'll keep looking.
>
> Cheers,
>
> Dave.


