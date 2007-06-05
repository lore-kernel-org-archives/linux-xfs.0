Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 16:00:12 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l55N06Wt003482
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 16:00:07 -0700
Subject: Re: corruption bug in 2.6.17
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <alpine.DEB.0.99.0706052217320.21004@foobar-g4>
References: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
	 <alpine.DEB.0.99.0706022300140.16496@sheep.housecafe.de>
	 <5d96567b0706050127y7f5eap7b92cddb5cdae02d@mail.gmail.com>
	 <alpine.DEB.0.99.0706052217320.21004@foobar-g4>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:58:47 +1000
Message-Id: <1181084327.3176.4.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, xfs@oss.sgi.com

On Tue, 2007-06-05 at 22:24 +0200, Christian Kujau wrote:
> ...
>   2) generate some IO on the xfs-mounted partition...and wait until
> the
>      fs shut down. 

The problem was actually related to a particular form of btree
dir2 transition - so, certain combinations of file names in a
relatively large directory with size changes would trigger it.

"generate some IO" is a bit too vague to be helpful.

cheers.

--
Nathan
