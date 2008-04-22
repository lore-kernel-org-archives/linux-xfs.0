Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 21:27:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M4RJig032604
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 21:27:22 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA11786; Tue, 22 Apr 2008 14:27:57 +1000
Message-ID: <480D694D.8010809@sgi.com>
Date: Tue, 22 Apr 2008 14:27:57 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Wrong patch checked in....
References: <20080422023533.GS103491721@sgi.com>
In-Reply-To: <20080422023533.GS103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Folks,
> 
> I just noticed my builds were coming up with warnings inside
> QUOTADEBUG code. I never saw a patch go past that enabled it
> for debug kernels, so I was kinda confused until I found this:
> 
...
> Seeing as this mod has already made it to Linus, we can't revert it easily.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e687330b5ed1ea899fdaf0dea50aba196b6e019a
> 
> Donald, can you do another checkin that returns xfs.h to it's previous
> state and removes the HAVE_SPLICE stuff correctly?

Definitely, just checked it in.

Thanks for picking this up Dave,

Don
