Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 04:37:08 -0700 (PDT)
Received: from chaos.egr.duke.edu (chaos.egr.duke.edu [152.3.195.82])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6IBarDW010742
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 04:36:56 -0700
Date: Tue, 18 Jul 2006 07:36:21 -0400 (EDT)
From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: oops with CentOS 4.3 / xfs / nfsd
In-Reply-To: <1153214961.6793.15.camel@x41ade>
Message-ID: <Pine.LNX.4.62.0607180735040.4795@chaos.egr.duke.edu>
References: <1153214961.6793.15.camel@x41ade>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Elwell <andrewe@epcc.ed.ac.uk>
Cc: linux-xfs@oss.sgi.com, maciej@epcc.ed.ac.uk

On Tue, 18 Jul 2006 at 10:29am, Andrew Elwell wrote

> using the 2.6.9-34 centosplus SMP kernel (3GHz P4 with hyperthreading
> enabled)
>
> what we normally (~once a day) is simply
>
> do_IRQ: stack overflow: 416
> [<c0107a27>]

You don't want to use the XFS in the centosplus kernel.  It has major 
known issues with 4K stacks (leading to overflows).  Use the 
kernel-module-xfs (or somesuch) RPM instead, and you should have better 
luck.

Or move to x86_64... ;)

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
