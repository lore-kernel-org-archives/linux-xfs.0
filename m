Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34910 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932109AbdHWRRu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:17:50 -0400
Subject: Re: [PATCH 3/4] fiemap: Simplify internals of fiemap_f.
From: Eric Sandeen <sandeen@sandeen.net>
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
 <1503501082-16983-3-git-send-email-nborisov@suse.com>
 <17826470-3112-248e-2d89-21c6d532e2ef@sandeen.net>
Message-ID: <bdccad2a-87c0-e90b-d2e2-794bec6e9e61@sandeen.net>
Date: Wed, 23 Aug 2017 12:17:49 -0500
MIME-Version: 1.0
In-Reply-To: <17826470-3112-248e-2d89-21c6d532e2ef@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org



On 8/23/17 10:51 AM, Eric Sandeen wrote:
> On 8/23/17 10:11 AM, Nikolay Borisov wrote:
>> So far fiemap used some rather convoluted logic to terminate the iteration and
>> calculate the number of extents to pass to fm_extent_count. Simplify this by:
>>
>> * Get the whole number of extents that this file has and keep iterating until
>> we've printed all extents
>>
>> * Always use a hard-coded batch of 32 extents so we don't have to worry about
>> any extra calculations
> 
> As discussed on IRC, these types of changes:
> 
>> -	if ((*cur_extent + 1) == max_extents)
>> +	if (*cur_extent == max_extents)
>>  		return;
> 
> are a functional change not described in the changelog above; they should be
> in their own patch with their own changelog, explaining why the test was off by one,
> and what this fixes.  This stuff is complex enough that it's not obvious to the
> casual reader now, and certainly won't be a few years later.  ;)

Ok, so this is fixing the "-n" argument, to actually print $ARG extents
instead of $ARG - 1 extents.

instead of today:

# xfs_io -c "fiemap -n 4" holefile
holefile:
	0: [0..7]: hole
	1: [8..15]: 172560120..172560127
	2: [16..23]: hole

now it does more expected:

# io/xfs_io -c "fiemap -n 4" holefile
holefile:
	0: [0..7]: hole
	1: [8..15]: 172560120..172560127
	2: [16..23]: hole
	3: [24..31]: 172560136..172560143

so it probably just needs a doc fix along w/ this behavior fix.

(note, bmap behaves the same way, except properly):

# xfs_io -c "bmap -n 4" holefile
holefile:
	0: [0..7]: hole
	1: [8..15]: 172560120..172560127
	2: [16..23]: hole
	3: [24..31]: 172560136..172560143

Thanks,
-Eric

 
> Thanks,
> -Eric
>
