Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 20:46:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D3k3sX025191
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:46:03 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1B9722535C
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:46:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 7JrKy4o2hjiICQXo for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 20:46:59 -0700 (PDT)
Message-ID: <4851EDB3.1010601@sandeen.net>
Date: Thu, 12 Jun 2008 22:46:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com> <4851E774.2070401@sgi.com> <4851EC2D.6010504@melbourne.sgi.com>
In-Reply-To: <4851EC2D.6010504@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: markgw@sgi.com, Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Greg Banks wrote:

>> (and the plan for statically linked apps? ...)
> 
> Perhaps Fedora could enable the glibc magic for issuing warnings at link
> time when those symbols are used, like what happens today if you use the
> old unsafe gets() function:
> 
> gnb@inara 1058> gcc -o fmeh x.c
> /tmp/ccQhxIIo.o: In function `main':
> x.c:(.text+0x18): warning: the `gets' function is dangerous and should not be used.


It wouldn't help the automated builds (nobody'd see it) but for normal
user compilations that might be an option...

-Eric
