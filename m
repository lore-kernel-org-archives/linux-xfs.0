Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 20:27:49 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D3RjQn023668
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:27:46 -0700
Message-ID: <4851E86E.6030203@melbourne.sgi.com>
Date: Fri, 13 Jun 2008 13:24:30 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com> <4851E41C.6050108@sandeen.net>
In-Reply-To: <4851E41C.6050108@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Eric Sandeen wrote:
>
> Heh :)  At first I was just going to correlate with st_ino users to cut
> it down, but then I learned that glibc will actually give you an
> EOVERFLOW if, say st_ino overflows, even if you were only going to check
> st_mode.  :(  So pretty much everything needs fixing.
>   
Of course. There's no way for the app to tell glibc that the app doesn't
care about st_ino, so glibc must assume that glibc needs to return an
accurate st_ino.  The alternative is to return the lower 32 bits of
st_ino, thus causing silent subtle failures in the very small number of
applications which actually do something with st_ino.  This is what
glibc used to do back when I first started tracking the issue.
> (FWIW I gathered statfs/statvfs calls, too...)
>
>   
Yes.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.
