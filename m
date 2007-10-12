Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Oct 2007 06:35:18 -0700 (PDT)
Received: from smtp.aaisp.net.uk (smtp.aaisp.net.uk [81.187.81.52])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9FDZ97v009469
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 06:35:12 -0700
Date: Fri, 12 Oct 2007 14:28:47 +0100
From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: XFS regression?
Message-ID: <20071012142847.110a1110@zeus.pccl.info>
In-Reply-To: <20071012123601.291fee8a@zeus.pccl.info>
References: <20071010152742.1b2a7bce@zeus.pccl.info>
	<20071011010139.GT995458@sgi.com>
	<20071011151512.69f19419@zeus.pccl.info>
	<20071011215352.GX995458@sgi.com>
	<20071012002613.GL23367404@sgi.com>
	<20071012123601.291fee8a@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 12 Oct 2007 12:36:01 +0100, Andrew Clayton wrote:


Ignore the numbers below. under normal conditions the raid array and
single drive show basically the same numbers. The raid array numbers
were done over NFS.

> raid array
> 
> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.122943>
> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.021620>
> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.014963>
> 
> system disk
> 
> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000190>
> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000039>
> open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000191>

While we're talking number's...

raid array, strace over NFS

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.018330>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.026398>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <8.927449>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <1.284661>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.030078>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.021407>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.018660>

raid array, strace locally

open("test2", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000069>
open("test2", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000044>
open("test2", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <8.995286>
open("test2", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <1.258810>
open("test2", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <1.225763>
open("test2", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000056>
open("test2", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000092>


Those where running concurrently. I think that rules out networking.
I'm getting more convinced it's a raid5 problem...


Andrew
