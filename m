Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Sep 2007 19:44:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l832iA4p030748
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 19:44:15 -0700
Message-ID: <46DB7586.7040309@sgi.com>
Date: Mon, 03 Sep 2007 12:46:30 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: lockdep annotations?
References: <alpine.DEB.0.999.0709012300030.6640@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.0.999.0709012300030.6640@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

This is a locking inversion between the iolock and iprune_mutex.  I
hadn't seen this one before.  Was your system running low on memory
at the time?

We can't drop the iolock in the write path so we'll have to avoid
acquiring the iolock in xfs_ireclaim() which means we'll need another
way to synchronise with xfs_sync_inodes().

Thanks for pointing this one out.

Lachlan

Christian Kujau wrote:
> Hi,
> 
> I try to follow -rc kernels and just upgraded to 2.6.23-rc5 and I still 
> see: "INFO: possible circular locking dependency detected". Out of 
> curiosity: (when) will these warnings be addressed? I mean, suits me for 
> enabling CONFIG_LOCKDEP in the first place, but the only warnings I get 
> is still xfs :)
> 
> FWIW, full log is here: 
> http://nerdbynature.de/bits/2.6.23-rc5/messages_2.6.23-rc5
> 
> Thanks,
> Christian.
