Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Sep 2007 23:33:46 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l836Xe4p005069
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 23:33:43 -0700
Date: Mon, 3 Sep 2007 08:33:36 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: lockdep annotations?
In-Reply-To: <46DB7586.7040309@sgi.com>
Message-ID: <alpine.DEB.0.999.0709030829470.7103@sheep.housecafe.de>
References: <alpine.DEB.0.999.0709012300030.6640@sheep.housecafe.de>
 <46DB7586.7040309@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 3 Sep 2007, Lachlan McIlroy wrote:
> This is a locking inversion between the iolock and iprune_mutex.  I
> hadn't seen this one before.  Was your system running low on memory
> at the time?

Usually, this might be the case, as lockdep reports only once and when 
it does it's usually the morning after the last reboot, when a script 
runs the backups (so the box is under load, probably memory pressure 
involved). However, this time I don't remember memory consuming tasks 
running. Unfortunately, I cannot reproduce this yet...

thanks for your explanations,
Christian.
-- 
BOFH excuse #321:

Scheduled global CPU outage
