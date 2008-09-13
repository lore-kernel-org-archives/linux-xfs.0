Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 21:07:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8D46pTs002980
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:06:51 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D078D1067AD3
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:08:21 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id f9wC7ZR0XMIZTA7E for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:08:21 -0700 (PDT)
Date: Sat, 13 Sep 2008 14:08:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs bug/crash on
Message-ID: <20080913040818.GB5811@disturbed>
References: <20080910091340.rjubi6txm8s8088o@webmail.welho.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910091340.rjubi6txm8s8088o@webmail.welho.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: eerov@welho.com
Cc: xfs@oss.sgi.com

On Wed, Sep 10, 2008 at 09:13:40AM +0300, eerov@welho.com wrote:
> Backup3 2.6.26.3 #6 SMP Tue Sep 2 11:20:20 EEST 2008 x86_64 x86_64  
> x86_64 GNU/Linux
>
> xfs? crash with dollowing error messages.

That's not a crash - it's a hang. And it's the low memory problem
w.r.t. allocation of the in-core extent list being reallocated
and memory reclaim being allowed to re-enter the filesystem.

This was recently fixed by this commit:

http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6785073ba138a2f0dc575c332c1812b713670b6a

in 2.6.27-rc4.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
