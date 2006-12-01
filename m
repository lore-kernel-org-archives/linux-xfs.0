Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Dec 2006 12:13:17 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB1KD8aG008420
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 12:13:09 -0800
Message-ID: <45708CA1.5090100@sgi.com>
Date: Fri, 01 Dec 2006 20:12:17 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com> <20061201004112.GW37654165@melbourne.sgi.com>
In-Reply-To: <20061201004112.GW37654165@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> On Fri, Dec 01, 2006 at 09:38:11AM +1100, David Chinner wrote:
> 
>>On Thu, Nov 30, 2006 at 06:03:40PM +0000, Lachlan McIlroy wrote:
>>
>>
>>>These changes wouldn't apply cleanly to tot (3 hunks failed in
>>>xfs_mount.c) but I couldn't see why.
>>
>>Whitespace issue? Try setting:
>>
>>$ export QUILT_PATCH_OPTS="--ignore-whitespace"
>>
>>I'll apply the patch to a separate tree and see if I hit the same
>>problem....
> 
> 
> I see the problem - the next patch I am going to send out for
> review which is earlier in my series....
> 
> The growfs fix changes the delta parameter to xfs_icsb_modify_counters()
> from int to int64_t, and that is why the hunks don't apply.
> 
> The attached patch should apply (with a 6 line offset to most hunks).
> 

That's even worse - now it loses track of which file it's patching.

[lachlan@linux (2.6.x-xfs)2.6.x-xfs]$ patch -p1 -l -i ENOSPC.patch.eml
patching file fs/xfs/xfs_mount.c
Hunk #2 succeeded at 543 (offset 5 lines).
Hunk #3 succeeded at 1485 (offset 6 lines).
Hunk #4 succeeded at 1523 (offset 6 lines).
Hunk #5 succeeded at 1736 (offset 6 lines).
Hunk #6 succeeded at 1758 (offset 6 lines).
Hunk #7 succeeded at 1794 (offset 6 lines).
Hunk #8 succeeded at 1901 (offset 6 lines).
Hunk #9 succeeded at 2021 (offset 6 lines).
Hunk #10 succeeded at 2060 (offset 6 lines).
Hunk #11 FAILED at 2087.
1 out of 11 hunks FAILED -- saving rejects to file fs/xfs/xfs_mount.c.rej
missing header for unified diff at line 256 of patch
can't find file to patch at input line 256
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|               break;
|
--------------------------
File to patch:
Skip this patch? [y]
Skipping patch.
3 out of 3 hunks ignored
patching file fs/xfs/xfs_mount.h

It seems to have a problem with line 256 of the patch:

@@ -2081,7 +2121,7 @@ again:          <---- line 256
  		lcounter = icsbp->icsb_ifree;
  		lcounter += delta;
  		if (unlikely(lcounter < 0))
-			goto slow_path;
+			goto balance_counter;
  		icsbp->icsb_ifree = lcounter;
  		break;

I can't see what's wrong.  Don't sweat over it - it's not that important
now that the review is done.  I'll leave it to you to merge it with tot.

Lachlan
