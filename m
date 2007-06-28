Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 03:38:58 -0700 (PDT)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SAcotL016642
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 03:38:53 -0700
Message-ID: <46838FB4.1040906@linworks.de>
Date: Thu, 28 Jun 2007 12:38:44 +0200
From: Ruben Porras <ruben.porras@linworks.de>
MIME-Version: 1.0
Subject: Re: XFS shrink (step 0)
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <1182291751.5289.9.camel@localhost> <20070619234248.GT86004887@sgi.com>
In-Reply-To: <20070619234248.GT86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com, iusty@k1024.org

David Chinner wrote:
> No, there isn't anything currently in existence to do this.
>
> It's not difficult, though. What you need to do is count the number of
> used blocks in the AGs that will be truncated off, and check whether
> there is enough free space in the remaining AGs to hold all the
> blocks that we are going to move.
>
> I think this could be done we a single loop across the perag
> array or with a simple xfs_db wrapper and some shell/awk/perl
> magic.
>   
Do you mind that is it ok to depend on shell/awk/perl? I'll do it in C 
looping through the perag array.
 

--
Rubén Porras
LinWorks GmbH
