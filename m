Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 18:40:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5B1dvnF009773
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 18:39:59 -0700
Message-ID: <484F2CD7.9070506@sgi.com>
Date: Wed, 11 Jun 2008 11:39:35 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz>
In-Reply-To: <484F0998.90306@sauce.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

Hi Richard,

Richard Scobie wrote:
> Timothy Shimmin wrote:
> 
>> BTW, Sam Vaughan wrote some tutorial notes on the allocator and in
>> particular
>> filestreams which I've pasted below:
>> (I thought it might be here:
>>  http://oss.sgi.com/projects/xfs/training/ but I can't see it
>>  in the allocator lab and slides).
> 
> I did actually find an entry for filestreams in slide 6.
> 
Yes, so did I but on a quick scan it didn't have the same detail.

> While there I also found the information on 64bit inodes.
> 
> My filesystem is 9.6TB and could well end up with a large quantity of
> 1-15MB files stored and the statement:
> 
>  "Operating system interfaces and legacy software products often mandate
> the use of 32 bit inode numbers even on systems that support 64 bit
> inode numbers."
> 
> makes me wonder how common this still is in practice - the slide was
> written in 2006)?
> 
> My initial preference would be to go with 64 bit inodes for performance
> reasons, but as one cannot revert the fs back to 32 bit inodes once
> committed, I am somewhat hesitant.
> 
> Or am I worrying unecessarily about the negative impact of 32 bit
> inodes, given 9.6TB full of 1 to 15MB files?
> 
Ah, the 32 bit inode versus 64 bit inode question :)
I don't have any definitive answers and I'm sure there will be people
on the list with their opinions and experiences.
So just some thoughts...

Firstly, XFS' current support for 32 bit inode numbers was added as
an afterthought I think primarily at the time on IRIX for 32 bit backup
clients such as Legato Networker.
It is only a compatibility thing with performance downsides.
So the question then becomes (1)what exactly is the compatibility matrix
and (2)under what conditions are there performance problems and by how much.
The other thing (3) is then a conversion tool for moving back from 64 bit inodes
to 32 bit inodes if you have a compat problem.

(3) There is a conversion tool called xfs_reno on IRIX. Barry has ported and modified
it for Linux but I believe has not checked it in and has some outstanding
Agami review points to address. Ideally, it would be nicer if we had more
kernel support (as suggested by Dave (dgc)) for swapping all the inode's metadata
(instead of just extents as we currently do).
So in other words, it is not there yet and there is the question of whether
we should update the kernel first (or maybe the tool should go in anyway for
use on older kernels).

(1) It would be nice to know what the state of the apps really are.
There is also the question of interaction with CXFS and NFS.
Greg Banks has a compat matrix for NFS. It looks like the main
things is to get something half recent - linux 2.6, nfs v3,
apps which use 64 bit sys calls (eg. stat64) etc...
Would need to do investigating.

There is also the possibility of other 32bit/64bit mapping schemes for xfs
but I won't go there.

--Tim
