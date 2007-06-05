Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 13:24:38 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l55KOWWt021662
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 13:24:33 -0700
Date: Tue, 5 Jun 2007 22:24:32 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: corruption bug in 2.6.17
In-Reply-To: <5d96567b0706050127y7f5eap7b92cddb5cdae02d@mail.gmail.com>
Message-ID: <alpine.DEB.0.99.0706052217320.21004@foobar-g4>
References: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
 <alpine.DEB.0.99.0706022300140.16496@sheep.housecafe.de>
 <5d96567b0706050127y7f5eap7b92cddb5cdae02d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: xfs@oss.sgi.com


[please reply on-list, so that everbody can help. and top-posting is
  evil;) ]

On Tue, 5 Jun 2007, Raz Ben-Jehuda(caro) wrote:
> It is unclear from the web page how can reproduce this bug. Can you
> think of a several steps that produces it so I will be able to know
> whether 2.7.17.7 fix had fixed it ?

I have been bitten by this one too and to "reproduce" it I only had to

  1) boot 2.6.17.x (x<17)
  2) generate some IO on the xfs-mounted partition...and wait until the
     fs shut down.

The fix is really to use a 2.7.17.7 or later kernel and check your
xfs with xfsprogs (version 2.8.10 or later) - if no corruptions are 
found, you should be fine.

C.
-- 
make bzImage, not war
