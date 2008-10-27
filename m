Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 05:14:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RCE5XC014505
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 05:14:06 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F29754B459
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 05:14:03 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id TNNu4MfagFFhBVy3 for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 05:14:03 -0700 (PDT)
Date: Mon, 27 Oct 2008 23:14:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: does XFS supports hole punching ?
Message-ID: <20081027121400.GF4985@disturbed>
References: <5d96567b0810221040m17d73871iff00d56bf07479c2@mail.gmail.com> <20081022212034.GQ18495@disturbed> <5d96567b0810270457g70b63c77re8841ebd1959f7b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0810270457g70b63c77re8841ebd1959f7b7@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com, Asaf Moses <asafm@bitband.com>, Ofer Kruzel <ofer@bitband.com>, yaronp@bitband.com

On Mon, Oct 27, 2008 at 01:57:08PM +0200, Raz wrote:
> Dave Hello
> I would be grateful if you help me here. man xfsctl was not clear enough.
> I have written a small program that compares the behavior of FREESP
> and UNRESERVE.
> I create a file size 10M, each 1M is filled with aaa.. 2-nd MB filled with bbb
> 3-rd with ccc and so on. I am trying to punch a hole with the bellow program
> and then inspect the file content, size and block map.
> 
> 1.  XFS_IOC_FREESP64 seems to be truncating the file and does not
> create a hole.
> 2.  XFS_IOC_UNRESERVE64 creates a hole and leaves the file size
> unchanged. as the man
>     page says.
> /d1/holely:
>         0: [0..14335]: 96..14431 14336 blocks
>         1: [14336..16383]: hole 2048 blocks
>         2: [16384..20479]: 16480..20575 4096 blocks
> Do a hole blocks count as a the file-system free space  ?

There is no such thing as a "hole block". It's a sparse file - where
there is a hole there are no blocks. i.e. holes are free space.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
