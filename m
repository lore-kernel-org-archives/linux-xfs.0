Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 08:07:24 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0OG7GHb023128
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 08:07:21 -0800
Received: from stlx01.stz-softwaretechnik.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F70B556F99
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 08:07:36 -0800 (PST)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211]) by cuda.sgi.com with ESMTP id nnrDqAVa4gEmnqlL for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 08:07:36 -0800 (PST)
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1JI4bs-0006U8-00
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 17:07:24 +0100
Date: Thu, 24 Jan 2008 17:07:14 +0100
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: xfs_rapair memory requirement per TB
Message-ID: <20080124160714.GB30433@p15145560.pureserver.info>
References: <1201042882.32649.256.camel@holwrs01.bp.com> <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080123085339.GB12435@p15145560.pureserver.info> <20080124002828.GC155259@sgi.com> <op.t5euakap3jf8g2@pc-bnaujok.melbourne.sgi.com> <1201189816.32649.358.camel@holwrs01.bp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201189816.32649.358.camel@holwrs01.bp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Rene Salmon schrieb:
> ...
> > Right now, I can repair a 9TB filesystem with ~150 million inodes
> > in 2GB of RAM without going to swap using xfs_repair 2.9.4 and
> > with no custom/tuning/config options.
> 
> Thanks. That is great news about the memory improvements.  We currently
> run SLES 10 SP1 which comes with:
> 
> hpcxe005:# xfs_repair -V
> xfs_repair version 2.8.16
> 
> others come with:
> 
> hpcxe001:~ # xfs_repair -V
> xfs_repair version 2.9.2
> 
> 
> Did the memory improvements make it into 2.8.16? How about 2.9.2? If not
> i take it we can download the latest source and just have the 2.9.4
> xfs_repair binary laying around in case we ever need to use it.  Would
> using a 2.9.4 xfs_repair binary on a 2.8.16 created xfs file system
> cause any problems?

I did this today. Compiled 2.9.5 on debian etch and put it in
/opt/xfsprogs. Just in case I need it.

On #xfs I got the answer that xfs_check and xfs_repair should be fine
for an fs that was created with an older mkfs.xfs. 

Ralf
