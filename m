Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 13:52:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LKpx2x000625
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:52:00 -0700
Received: from node2.t-mail.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29B346D1385
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:52:32 -0700 (PDT)
Received: from node2.t-mail.cz (node2.t-mail.cz [62.141.0.167]) by cuda.sgi.com with ESMTP id rLXMasrShgGSVSmW for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:52:32 -0700 (PDT)
Subject: Re: serious problem with XFS on nvidia IDE controller
From: Massimiliano Adamo <maxadamo@gmail.com>
In-Reply-To: <20080321190239.GF5433@josefsipek.net>
References: <1206125778.6867.14.camel@dasa-laptop>
	 <20080321190239.GF5433@josefsipek.net>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 21:51:55 +0100
Message-Id: <1206132715.6636.6.camel@dasa-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com


Il giorno ven, 21/03/2008 alle 15.02 -0400, Josef 'Jeff' Sipek ha
scritto:
> On Fri, Mar 21, 2008 at 07:56:18PM +0100, Massimiliano Adamo wrote:
> ...
> > My kernel is the one provided with Ubuntu 7.10: 2.6.22-14
> > 
> > At present, this controller is not managed by any driver in the linux
> > kernel, and in order to boot, I have to append the string
> > "all_generic_ide" into grub config file. Otherwise system doesn't boot.
> 
> I have no idea if a newer kernel does support it, but it might be worth a
> try.
> 

I've booted with a live-cd using a newer kernel (2.6.24), and the
controller is now recognized properly (and not unknown):

description: IDE interface
product: MCP67 IDE Controller
vendor: nVidia Corporation
....
configuration: driver=pata_amd


Anyway, the point is that with ata_generic my kernel is working properly
with reiser, and is not working with XFS. 

-- 
cheers
Massimiliano
