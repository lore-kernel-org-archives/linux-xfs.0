Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 18:00:41 -0700 (PDT)
Received: from buick.jordet.net (buick.jordet.net [217.8.143.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7P10RDW012338
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 18:00:27 -0700
Subject: Re: xfs bug in 2.6.17.9?
From: Stian Jordet <liste@jordet.net>
In-Reply-To: <200608241429.14277.Martin@lichtvoll.de>
References: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com>
	 <200608241429.14277.Martin@lichtvoll.de>
Content-Type: text/plain
Date: Fri, 25 Aug 2006 01:45:33 +0200
Message-Id: <1156463133.19666.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

tor, 24,.08.2006 kl. 14.29 +0200, skrev Martin Steigerwald:
> It looks to me that the directory corruption bug in kernel 2.6.17 upto 
> 2.6.17.6 hit you: Did you use a 2.6.17 kernel < 2.6.17.7 before? 
> 
> See 
> 
> http://oss.sgi.com/projects/xfs/faq.html#dir2
> http://bugzilla.kernel.org/show_bug.cgi?id=6757
> 
> Try xfs_check and if it finds errors xfs_repair. 
> 
> If xfs_repair cannot fix it, you will have to look out a version that 
> contains some fixes related to handling this kind of corruption:
> 
> http://oss.sgi.com/archives/xfs/2006-07/msg00374.html

Martin,

thanks for your help. I did use both 2.6.17.1 and 2.6.17.3 before
2.6.17.9... So I guess (hope) that's the problem, and not my memory... 

I have run xfs_repair 2.8.11 on two filesystems with errors (luckily,
neither my /home nor my backup partition seems to be hit), and it find
some errors, but if I run it again, I finds the same errors over and
over again... I seem to have it up and running again now, but I really
don't like that xfs_repair shows a lot of errors on each run. Don't like
that at all... It says it has fixed the errors, but I just never get rid
of them.

Is that normal? Guess not. And is it something that can happen with the
directory corruption bug? I read that I needed to have xfsprogs >2.8.10,
but that didn't help neither...

Best regards,
Stian
