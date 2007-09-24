Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 21:18:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8O4HtQ3004118
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 21:17:57 -0700
Subject: Re: something very strange w/ filestreams...
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <46F49C80.60007@sandeen.net>
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 14:22:17 +1000
Message-ID: <op.ty443fx13jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46F49C80.60007@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Sat, 22 Sep 2007 14:39:28 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> if I do:
>
> for I in 173 174 178; do ./check $I; done
>
> it's not terribly interesting, things seem to go ok, just normal
> filestreams failures ;-)
>
> if I do:
>
> ./check 173 174 178
>
> things go very badly; the very first repair in 178 finds a horribly
> corrupted filesystem, and repair tips over (memory appears corrupted, as
> witnessed by):
>
>> xfs_repair: zone calloc failed (, 572662388 bytes): Cannot allocate  
>> memory
>
> hm, no zone name, length of 0x22222274?
>
> I already provided a metadump image to Barry, but I wonder why the
> timing(?) seems to make a difference here... first sign of things going
> awry in repair is:
>
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> bad length 131072 for agf 0, should be 4096
> bad length # 131072 for agi 0, should be 4096
> would reset bad agf for ag 0
> would reset bad agi for ag 0
> ....
>
> not sure what's going on here, but it only seems to happen if I do those
> 2 filestreams test immediately before 178...
>
> oh, and this is over LVM, just for fun.

Eric, you have this patch installed don't you?
http://oss.sgi.com/archives/xfs/2007-07/msg00139.html
