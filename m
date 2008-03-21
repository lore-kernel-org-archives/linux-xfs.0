Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 12:22:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LJMavM029725
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:22:37 -0700
Received: from node2.t-mail.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6903E6D09F0
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:23:09 -0700 (PDT)
Received: from node2.t-mail.cz (node2.t-mail.cz [62.141.0.167]) by cuda.sgi.com with ESMTP id AUbH9cCoZMEYYARQ for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:23:09 -0700 (PDT)
Subject: Re: serious problem with XFS on nvidia IDE controller
From: Massimiliano Adamo <maxadamo@gmail.com>
In-Reply-To: <20080321190239.GF5433@josefsipek.net>
References: <1206125778.6867.14.camel@dasa-laptop>
	 <20080321190239.GF5433@josefsipek.net>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 20:22:24 +0100
Message-Id: <1206127344.6867.22.camel@dasa-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com


Il giorno ven, 21/03/2008 alle 15.02 -0400, Josef 'Jeff' Sipek ha
scritto:
> On Fri, Mar 21, 2008 at 07:56:18PM +0100, Massimiliano Adamo wrote:
> ...
> > My kernel is the one provided with Ubuntu 7.10: 2.6.22-14
> > 
> > At present, this controller is not managed by any driver in the linux
> > kernel, and in order to boot, I have to append the string
> > "all_generic_ide" into grub config file. Otherwise system doesn't boot.
> 
> I have no idea if a newer kernel does support it, but it might be worth a
> try.

I should have to do this ... but now I have my system installed with
reiser :(

Furthermore, I left Gentoo, and I am using ubuntu as I hate
recompiling... and I wouldn't recompile a kernel on it. What I can do,
is to boot with last "partimage live-cd" (which uses newer kernel), and
try to see if it loads some other driver.

> 
> ...
> > I have installed the system at least 3 times in one day, before
> > understanding that the problem was XFS filesystem.
> > After each reboot there were file missing, when running ldconfig I was
> > getting messages like: the file blabla_blabla.so is truncated, or is
> > corrupted...
> 
> Is there anything in dmesg?

As I can remember there was nothing really interesting...


> We have joy, we have fun, we have Linux on a Sun...

very nice signature :)

-- 
Massimiliano
