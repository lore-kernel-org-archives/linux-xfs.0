Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 18:22:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9J1MWVU005411
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 18:22:32 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47977AC4F5E
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 18:24:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id AzFNoX266PY3Nui9 for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 18:24:14 -0700 (PDT)
Message-ID: <48FA8C3D.5090202@sandeen.net>
Date: Sat, 18 Oct 2008 20:24:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel 2.6.27.2 (32bit) filesystem is read-only
References: <alpine.DEB.1.10.0810181926380.20575@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0810181926380.20575@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Justin Piszcz wrote:
> all 2.6.26.x kernels work ok,
> make oldconfig on 2.6.27.2, filesystem mounted read-only at boot 
> booted back to 2.6.26.x, back to normal
> barriers are on by default (single disk system)
> 
> 

You'll need:

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=review-2.6.27/xfs-fix-remount-rw-with-unrecognized-options.patch;h=4f93cbab85eb4c3b097065da3e13878d499b0d5a;hb=HEAD

s/b in 2.6.27.3 (pity it took 3 -stable releases, though)

-Eric
