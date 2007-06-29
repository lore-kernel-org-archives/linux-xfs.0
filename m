Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 23:38:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T6cPtL030460
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 23:38:26 -0700
Date: Fri, 29 Jun 2007 16:41:22 +1000
Subject: Re: xfs_fsr, performance related tweaks
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <4684A506.4030705@corky.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: xfs@oss.sgi.com

On Fri, 29 Jun 2007 16:21:58 +1000, Just Marc <marc@corky.net> wrote:

> Hi Eric,
>
> In my particular case, and I'm sure for many other people, files that  
> are stored never change again until they deleted.  I hinted that there  
> could be a command line switch to turn this functionality on, as it may  
> not be perfect for everyone's use cases.
>
> If nobody likes this still, I would appreciate some hints on how to mark  
> files as no-defrag from within fsr itself given that I only have the  
> file descriptor ... A hack like looking up the descriptor in  
> /proc/self/fd should work, but is linux specific and is too hackish in  
> my opinion.   I'd like to at least have a nice simple patch for my own  
> uses.

Eric,

You can use the xfs_io chattr command to mark known files as
nodefrag. Using the chattr -R option can be used to recurse
directories.

Regards,
Barry.
