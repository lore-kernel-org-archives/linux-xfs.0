Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Jul 2006 11:07:49 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6MI7aDW018671
	for <linux-xfs@OSS.SGI.com>; Sat, 22 Jul 2006 11:07:37 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G4Lv3-00044x-28
	for <linux-xfs@OSS.SGI.com>; Sat, 22 Jul 2006 19:09:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17602.27108.555049.327996@base.ty.sabi.co.UK>
Date: Sat, 22 Jul 2006 19:09:40 +0100
Subject: Re: stable xfs
In-Reply-To: <1153413481.2768.65.camel@localhost.localdomain>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
	<17597.27469.834961.186850@base.ty.sabi.co.UK>
	<1153272044.2669.282.camel@localhost.localdomain>
	<17598.2129.999932.67127@base.ty.sabi.co.UK>
	<1153314670.2691.14.camel@localhost.localdomain>
	<20060720061527.GB18135@tuatara.stupidest.org>
	<1153404502.2768.50.camel@localhost.localdomain>
	<20060720161707.GB26748@tuatara.stupidest.org>
	<1153413481.2768.65.camel@localhost.localdomain>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Thu, 20 Jul 2006 12:38:01 -0400, Ming Zhang
>>> <mingz@ele.uri.edu> said:

[ ... ]

>>> we mainly handle large media files like 20-50GB. so file
>>> number is not too much. but file size is large.

>> xfs_repair usually deals with that fairly well in reality
>> (much better than lots of small files anyhow)

> sounds cool. yes, large # of small files are always painful.

It is not just number of inodes, it is also number of
extents. That is total number of metadata items.

[ ... ]
