Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 04:21:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JBLD5G007442
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 04:21:17 -0700
Received: from ventoso.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CD94FCEDCF
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 04:21:45 -0700 (PDT)
Received: from ventoso.org (61.pool85-52-226.static.orange.es [85.52.226.61]) by cuda.sgi.com with ESMTP id gBfyvZw4eDvzt5OQ for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 04:21:45 -0700 (PDT)
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by ventoso.org (Postfix) with ESMTP id 8FB30C1FA28
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 12:21:43 +0100 (CET)
Message-ID: <47E0F746.1090508@ventoso.org>
Date: Wed, 19 Mar 2008 12:21:42 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181649w507322e7mf1410b30a2621506@mail.gmail.com> <20080319002307.GA11349@josefsipek.net>
In-Reply-To: <20080319002307.GA11349@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

En/na Josef 'Jeff' Sipek ha escrit:


> Thanks for the heads up wrt ARM EABI.

Well, I have a linkstation lspro, even if it's running now "freelink" 
(i.e. debian, oabi, for the linkstation 
http://buffalo.nas-central.org/index.php/FreeLink), it's using the 
stock, eabi[*], kernel (Linux lspro 2.6.12.6-arm1 #2 Mon Jul 23 22:35:39 
CEST 2007 armv5tejl GNU/Linux) and xfs works just fine.

[*] though I think, but I'm not sure, it was not the real thing but 
something that marvell patched in.

However, any later kernel I tried "breaks" xfs (that's why I originally 
subscribed to this list), i.e. I cannot see the contents of some directories
(more details here: 
http://buffalo.nas-central.org/forums/viewtopic.php?p=35061#p35061)

The strange thing is that I can mount the failing image on i386, so it 
probably has the correct structures on disk.

Maybe looking at what marvell/buffalo patched in that kernel could give 
some insight on the xfs issues with arm.

Bye
-- 
Luca
