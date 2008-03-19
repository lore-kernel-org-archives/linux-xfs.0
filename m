Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 05:56:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JCu1Nj009737
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 05:56:02 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D98246BCDD5
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 05:53:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Fmc4wrz4U8I8OQpZ for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 05:53:16 -0700 (PDT)
Message-ID: <47E10CBA.9020904@sandeen.net>
Date: Wed, 19 Mar 2008 07:53:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181649w507322e7mf1410b30a2621506@mail.gmail.com> <20080319002307.GA11349@josefsipek.net> <47E0F746.1090508@ventoso.org>
In-Reply-To: <47E0F746.1090508@ventoso.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Luca Olivetti <luca@ventoso.org>
Cc: xfs@oss.sgi.com

Luca Olivetti wrote:
> En/na Josef 'Jeff' Sipek ha escrit:
> 
> 
>> Thanks for the heads up wrt ARM EABI.
> 
> Well, I have a linkstation lspro, even if it's running now "freelink" 
> (i.e. debian, oabi, for the linkstation 
> http://buffalo.nas-central.org/index.php/FreeLink), it's using the 
> stock, eabi[*], kernel (Linux lspro 2.6.12.6-arm1 #2 Mon Jul 23 22:35:39 
> CEST 2007 armv5tejl GNU/Linux) and xfs works just fine.

yeah, it should.  For my list of on-disk structures, arm eabi structure
layout is identical to ia64 - I don't think any heads up is needed.

> [*] though I think, but I'm not sure, it was not the real thing but 
> something that marvell patched in.
> 
> However, any later kernel I tried "breaks" xfs (that's why I originally 
> subscribed to this list), i.e. I cannot see the contents of some directories
> (more details here: 
> http://buffalo.nas-central.org/forums/viewtopic.php?p=35061#p35061)

do you still have that small fs image?  I'll take a look.  There was
also an arm get_unaligned issue which hit xfs in another spot,
http://marc.info/?l=git-commits-head&m=120433318323826&w=3

might be worth seeing if you still have trouble with that fix in place
(which is slated for 2.6.25)

-Eric

> The strange thing is that I can mount the failing image on i386, so it 
> probably has the correct structures on disk.
> 
> Maybe looking at what marvell/buffalo patched in that kernel could give 
> some insight on the xfs issues with arm.

> Bye
