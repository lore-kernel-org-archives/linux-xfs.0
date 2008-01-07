Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jan 2008 14:53:56 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m07MrnAB010479
	for <xfs@oss.sgi.com>; Mon, 7 Jan 2008 14:53:52 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 091D14F29E2
	for <xfs@oss.sgi.com>; Mon,  7 Jan 2008 14:54:05 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id bwrRLTP9HuGcd2fo for <xfs@oss.sgi.com>; Mon, 07 Jan 2008 14:54:05 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m07MrvF3024427
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 7 Jan 2008 23:53:57 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m07MrvMT024425
	for xfs@oss.sgi.com; Mon, 7 Jan 2008 23:53:57 +0100
Date: Mon, 7 Jan 2008 23:53:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix unaligned access in readdir
Message-ID: <20080107225357.GA24361@lst.de>
References: <20071226154857.GA3472@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071226154857.GA3472@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Dec 26, 2007 at 04:48:57PM +0100, Christoph Hellwig wrote:
> This patch should fix the issue seen on Alpha with unaligned accesses
> in the new readdir code.   By aligning each dirent to sizeof(u64) we'll
> avoid unaligned accesses.  To make doubly sure we're not hitting
> problems also rearrange struct hack_dirent to avoid holes.

If anyone in Melbourne is getting back from Holidays it would be nice
if we could get this patch into 2.6.24-final still..
