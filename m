Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 21:18:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l784I5bm021705
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 21:18:07 -0700
Message-ID: <46B94402.5090801@sandeen.net>
Date: Tue, 07 Aug 2007 23:18:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: qa 166 failure on f8 kernel
References: <46B91EBA.10407@sandeen.net> <op.twp3lyi83jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.twp3lyi83jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Barry Naujok wrote:
> On Wed, 08 Aug 2007 11:39:06 +1000, Eric Sandeen <sandeen@sandeen.net>  
> wrote:
> 
>> Posting this just in case it rings any bells, though I plan to
>> investigate...
>>
>> [root@inode xfstests]# ./check  166
>> FSTYP         -- xfs (non-debug)
>> PLATFORM      -- Linux/x86_64 inode 2.6.23-0.71.rc2.fc8
>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
>> MOUNT_OPTIONS -- /dev/sdb6 /mnt/sdb6
>>
>> 166      - output mismatch (see 166.out.bad)
>> 2,6c2,7
>> < 0: [0..31]: XX..YY AG (AA..BB) 32
>> < 1: [32..127]: XX..YY AG (AA..BB) 96 10000
>> < 2: [128..159]: XX..YY AG (AA..BB) 32
>> < 3: [160..223]: XX..YY AG (AA..BB) 64 10000
>> < 4: [224..255]: XX..YY AG (AA..BB) 32
>> ---
>>> /mnt/sdb6/test_file:  XX..YY AG (AA..BB)
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> I suspect this line is appearing in the output due to a number
> in the mountpoint. I think the _filter_blocks() is only
> extracting lines with numbers in it.

Bingo.  Yep, changing it to /mnt/foo, plus my change to the test,
passes.  thanks!

-Eric
