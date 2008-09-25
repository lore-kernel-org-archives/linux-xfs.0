Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 06:47:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PDl7OY005140
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 06:47:07 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C528C97DD19
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 06:48:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id eOuQq2dNfPKeE35b for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 06:48:42 -0700 (PDT)
Message-ID: <48DB96B8.6050503@sandeen.net>
Date: Thu, 25 Sep 2008 08:48:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.27-rc7 no init found on the root partition?
References: <20080924192227.GC31582@ics.muni.cz> <20080924230326.GM5448@disturbed> <20080925111239.GF31582@ics.muni.cz>
In-Reply-To: <20080925111239.GF31582@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Lukas Hejtmanek wrote:

> this is a grub record:
> 
> title Linux 2.6.26.3
> root (hd0,0)
> kernel /boot/vmlinuz-2.6.26.3 root=/dev/sda1 ro console=tty0
> 
> title Linux 2.6.27-rc7
> root (hd0,0)
> kernel /boot/vmlinuz-2.6.27-rc7 root=/dev/sda1 ro 

Is it possible that device ordering has changed?  what if you do:

> title Linux 2.6.27-rc7
> root (hd0,0)
> kernel /boot/vmlinuz-2.6.27-rc7 root=LABEL=$WHATEVER ro

and try mounting root by label? (or UUID ...)

-Eric
