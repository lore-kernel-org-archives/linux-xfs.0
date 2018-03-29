Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp1.onthe.net.au ([203.22.196.249]:43353 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbeC2AQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 20:16:02 -0400
Date: Thu, 29 Mar 2018 11:15:59 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: file corruptions, 2nd half of 512b block
Message-ID: <20180329001559.GA21914@onthe.net.au>
References: <20180322150226.GA31029@onthe.net.au>
 <20180322180327.GI16617@bfoster.bfoster>
 <20180327223310.GA4461@onthe.net.au>
 <20180328180916.GC37735@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20180328180916.GC37735@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 28, 2018 at 02:09:16PM -0400, Brian Foster wrote:
> On Wed, Mar 28, 2018 at 09:33:10AM +1100, Chris Dunlop wrote:
>> On Thu, Mar 22, 2018 at 02:03:28PM -0400, Brian Foster wrote:
>>> On Fri, Mar 23, 2018 at 02:02:26AM +1100, Chris Dunlop wrote:
>>>> Hi,
>>>>
>>>> I'm experiencing 256-byte corruptions in files on XFS on 4.9.76.

>>> FWIW, the patterns that you have shown so far do seem to suggest
>>> something higher level than a physical storage problem. Otherwise, I'd
>>> expect these instances wouldn't always necessarily land in file data.
>>> Have you run 'xfs_repair -n' on the fs to confirm there aren't any other
>>> problems?
>>
>> I haven't tried xfs_repair yet. At 181T used and high but unknown at this
>> point number of dirs and files, I imagine it will take quite a while and the
>> filesystem shouldn't really be unavailable for more than low numbers of
>> hours. I can use an LVM snapshot to do the 'xfs_repair -n', but I need to
>> add enough spare capacity to hold the amount of data that arrives (at
>> 0.5-1TB/day) during life of the check / snapshot. That might take a bit of
>> fiddling because the system is getting short on drive bays.
>>
>> Is it possible to work out approximately how long the check might take?
>
> It will probably depend more on the amount of metadata than the size of
> the fs. That said, it's not critical if downtime is an issue. It's more
> something to check when convenient just to be sure there aren't other
> issues in play.

It's not looking too good in terms of how much metadata: I've had 
"dircnt" (https://github.com/ChristopherSchultz/fast-file-count) running 
for over 24 hours now and it's still going... (unfortunately it doesn't 
allow for SIGUSR1 to report current stats a la dd). I guess a simple 
directory scan like that is going to be significantly quicker than the 
'xfs_repair -n' - unless 'xfs_repair' uses optimisations not available 
to a simple directory scan?

>> I have a number of instances where it definitely looks like the file has
>> made it to the filesystem (but not necessarily disk) and checked ok, only to
>> later fail the md5 check, e.g.:
>>
>> 2018-03-12 07:36:56 created
>> 2018-03-12 07:50:05 check ok
>> 2018-03-26 19:02:14 check bad
>>
>> 2018-03-13 08:13:10 created
>> 2018-03-13 08:36:56 check ok
>> 2018-03-26 14:58:39 check bad
>>
>> 2018-03-13 21:06:34 created
>> 2018-03-13 21:11:18 check ok
>> 2018-03-26 19:24:24 check bad
>
> How much is known about possible events related to the file between the
> time the check passes and when the md5 goes bad? For example, do we know
> for certain nothing read or otherwise acted on the file in that time?
>
> If so, it certainly seems like the difference between check ok and check
> bad could be due to cache effects.

At least some of the files were read between the ok and bad checks. In 
at least one case the reader complained about a decompression error - in 
fact that that was what started me looking into this in detail.

>>                             ... Most of the time, 'vmtouch -e' clears the
>> file from buffers immediately, but sometimes it leaves a single page
>> resident, even in the face of repeated calls. ...
>>
>> Any idea what that impressively persistent page is about?
>
> Hm, not sure. I see that behavior on one file that was recently cached
> in my dev tree. A local copy of the same file shows the same thing. If I
> copy to a separate fs on another vm (with a newer kernel), I don't see
> that behavior. I'm not sure off hand what the difference is, perhaps it
> has something to do with the kernel. But this is all debug logic so I
> wouldn't worry too much about doing excessive numbers of loops and
> whatnot unless this behavior proves to be somehow relevant to the
> problem.
>
> FWIW, 'vmtouch -v' shows a little table of which pages are actually
> present in the file. In my test, the tail page is the one that persists.
> More importantly, it might be useful to use 'vmtouch -v' in your checks
> above. That way we actually have a record of whether the particular
> corrupted page was cached between a 'check ok' -> 'check bad'
> transition.

Tks, I'll add that to the check script.

>>>> "cmp -l badfile goodfile" shows there are 256 bytes differing, in the
>>>> 2nd half of (512b) block 53906431.
>>>
>>> FWIW, that's the last (512b) sector of the associated (4k) page. Does
>>> that happen to be consistent across whatever other instances you have a
>>> record of?
>>
>> Huh, I should have noticed that! Yes, all corruptions are the last 256b of a
>> 4k page. And in fact all are the last 256b in the first 4k page of an 8k
>> block. That's odd as well!
>
> Ok, that's potentially interesting. But what exactly do you mean by an
> 8k block? This is a 4k block filesystem, correct? Are you just saying
> that the pages that contain the corruption all happen to be at 8k
> aligned offsets?

Yes, I meant 8k aligned offsets. But it turns out I was wrong, they're 
not consistently placed within 8k aligned offsets - sorry for the false 
alarm. See also the file/source/corrupt table in email to Dave.

> Brian

Chris
