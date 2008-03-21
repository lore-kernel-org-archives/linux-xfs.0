Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 13:58:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LKwkkl001093
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:58:48 -0700
Received: from node2.t-mail.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBB7BFFE695
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:59:20 -0700 (PDT)
Received: from node2.t-mail.cz (node2.t-mail.cz [62.141.0.167]) by cuda.sgi.com with ESMTP id JlGa9AsH4Uii7QSt for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:59:20 -0700 (PDT)
Subject: Re: serious problem with XFS on nvidia IDE controller
From: Massimiliano Adamo <maxadamo@gmail.com>
In-Reply-To: <1206132715.6636.6.camel@dasa-laptop>
References: <1206125778.6867.14.camel@dasa-laptop>
	 <20080321190239.GF5433@josefsipek.net>
	 <1206132715.6636.6.camel@dasa-laptop>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 21:59:15 +0100
Message-Id: <1206133155.6636.9.camel@dasa-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com


Il giorno ven, 21/03/2008 alle 21.51 +0100, Massimiliano Adamo ha
scritto:

> I've booted with a live-cd using a newer kernel (2.6.24), and the
> controller is now recognized properly (and not unknown):
> 
> description: IDE interface
> product: MCP67 IDE Controller

ok, that was not a kernel problem.
It was enough to run update-pciids, even on my kernel :)

> configuration: driver=pata_amd

this driver does not exist on my kernel.
It may be the problem, but the problem is not arising with reiser.

-- 
Massimiliano
