Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 21:15:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l784Fgbm020179
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 21:15:44 -0700
Date: Wed, 08 Aug 2007 14:19:00 +1000
Subject: Re: qa 166 failure on f8 kernel
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <46B91EBA.10407@sandeen.net>
Message-ID: <op.twp3lyi83jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46B91EBA.10407@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, 08 Aug 2007 11:39:06 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Posting this just in case it rings any bells, though I plan to
> investigate...
>
> [root@inode xfstests]# ./check  166
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 inode 2.6.23-0.71.rc2.fc8
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
> MOUNT_OPTIONS -- /dev/sdb6 /mnt/sdb6
>
> 166      - output mismatch (see 166.out.bad)
> 2,6c2,7
> < 0: [0..31]: XX..YY AG (AA..BB) 32
> < 1: [32..127]: XX..YY AG (AA..BB) 96 10000
> < 2: [128..159]: XX..YY AG (AA..BB) 32
> < 3: [160..223]: XX..YY AG (AA..BB) 64 10000
> < 4: [224..255]: XX..YY AG (AA..BB) 32
> ---
>> /mnt/sdb6/test_file:  XX..YY AG (AA..BB)
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I suspect this line is appearing in the output due to a number
in the mountpoint. I think the _filter_blocks() is only
extracting lines with numbers in it.

>> 0: [0..7]: XX..YY AG (AA..BB) 8
>> 1: [8..127]: XX..YY AG (AA..BB) 120 10000
>> 2: [128..135]: XX..YY AG (AA..BB) 8
>> 3: [136..247]: XX..YY AG (AA..BB) 112 10000
>> 4: [248..255]: XX..YY AG (AA..BB) 8
> Failures: 166
> Failed 1 of 1 tests
> [root@inode xfstests]# uname -a
> Linux inode.lab.msp.redhat.com 2.6.23-0.71.rc2.fc8 #1 SMP Sat Aug 4
> 01:21:06 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
>
> -Eric
>
>
