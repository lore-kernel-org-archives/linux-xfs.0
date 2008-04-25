Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Apr 2008 07:54:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3PEro3R017823
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 07:53:56 -0700
Received: from rv-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C702FEB4BD
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 07:54:31 -0700 (PDT)
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233]) by cuda.sgi.com with ESMTP id JjUa3l0nuPfrsLaQ for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 07:54:31 -0700 (PDT)
Received: by rv-out-0506.google.com with SMTP id g37so1771745rvb.32
        for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 07:54:31 -0700 (PDT)
Message-ID: <c33e4330804250754w4445ab73h103df744378fd918@mail.gmail.com>
Date: Fri, 25 Apr 2008 10:54:30 -0400
From: "Michael Darling" <darlingm@gmail.com>
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid) and to 0.6% of EXT3 (3ware hardware raid)
In-Reply-To: <4810C0D3.1070107@sandeen.net>
MIME-Version: 1.0
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
	 <4810C0D3.1070107@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Apr 24, 2008 at 1:18 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Chris Mason reminded me that bonnie++ may not be creating enough files
> to actually cause much if any IO on ext3; you might play with the -n
> option to get it to the point where it's actually doing a significant
> number of creates (I don't know what the default is offhand... checks
> source... it's 16k maybe?) but more sustained creation might be
interesting.
>
> -Eric
>

That's definately a good point worth testing, the default 16k option
completes extremely quickly.  Increasing the number of files affected the
ext3 benchmarks by only a little bit below 256k.  I think the 128k benchmark
can be treated as representative especially since it puts the ext3
filesystem through a load for 23.67 seconds.  I think the 256k benchmark is
hitting a problem in the ext3 filesystem, because CPU usage is bottoming out
and correspondingly so the transactions per second is bottoming out as well.

Regardless, no matter which benchmark below is representative of the ext3
filesystem, it's still substantially faster than xfs on my 3ware
9650SE-4LPML (at least with barriers on.)

 _______------Sequential Create------ --------Random Create--------
_______-Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
___16 31771_ 95 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ (2.09
seconds)
___64 31544_ 97 +++++ +++ 52547_ 99 17424_ 53 +++++ +++ 53954 100 (8.76
seconds)
__128 30287_ 97 +++++ +++ 48493_ 95_ 9987_ 32 +++++ +++ 49988_ 99 (23.67
seconds)
__256 14709_ 49 323792 99_ 4211__ 8 14866_ 49 416920 99_ 1580__ 3 (4 minutes
27.46 seconds)


[[HTML alternate version deleted]]
