Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 09:54:37 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QGsWTs022116
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 09:54:34 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1Iaa9W-0005WB-00
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 18:54:22 +0200
Date: Wed, 26 Sep 2007 18:54:12 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: [UNSURE] Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070926165412.GE30287@p15145560.pureserver.info>
References: <20070923093841.GH19983@p15145560.pureserver.info> <18166.25242.174049.175729@base.ty.sabi.co.UK> <20070926145417.GC30287@p15145560.pureserver.info> <Pine.LNX.4.64.0709261227260.15219@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709261227260.15219@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Justin Piszcz schrieb:
> > 
> >  /sbin/blockdev --setra 16384  /dev/sdc
> > 
> > was the key to ~400 MB/s read performance.
> 
> Nice, what do you get for write speed?

Still 170-200 MB/s. The command above just tunes the read ahead value.

Ralf
