Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 16:52:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5ANqSA2031776
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 16:52:29 -0700
Date: Wed, 11 Jun 2008 09:53:40 +1000
Subject: Re: XFS directory entries sort order
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <200806101245.09950.dizzy@roedu.net> <87prqpp5q7.fsf@basil.nowhere.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ucj4nqkv3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <87prqpp5q7.fsf@basil.nowhere.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>, dizzy <dizzy@roedu.net>
Cc: xfs@oss.sgi.com

On Wed, 11 Jun 2008 03:20:00 +1000, Andi Kleen <andi@firstfloor.org> wrote:

> dizzy <dizzy@roedu.net> writes:
>
>> Can someone tell me (in English or C :) ) the algorithm of the sorting  
>> order
>> of the entries in an XFS directory as I would get them with a readdir()  
>> (or
>> shell "find" command)?
>>
>> I am trying to figure it out by reading linux/fs/xfs/xfs_dir2*.c code  
>> but I
>> don't seem to be doing much progress and I was hoping maybe someone that
>> knows these details can help.
>
> I believe it computes a hash over the name and then sorts by the hash
> numerical value. At least the b*tree large directories do, small inline
> directories might be different (XFS uses different algorithms for
> different directory sizes)

readdir order is not dependant on the hashes. The order depends on the
order of files being created, unlinked and the length of the filenames
being unlinked/created.

> The hash function is in xfs_da_btree.c:xfs_da_hashname()
>
> With the recent case insensitive support there are also differences
> on the file systems which have that enabled.
>
> Also better don't rely on it never changing.

Yes :)

Barry.
