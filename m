Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 02:18:23 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAUAIICQ023664
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 02:18:21 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lAUAIPF3004454
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 11:18:25 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lAUAIOV5004452
	for xfs@oss.sgi.com; Fri, 30 Nov 2007 11:18:24 +0100
Date: Fri, 30 Nov 2007 11:18:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: current cvs doesn't compile
Message-ID: <20071130101824.GA4419@lst.de>
References: <20071130101153.GA4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130101153.GA4150@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, Nov 30, 2007 at 11:11:53AM +0100, Christoph Hellwig wrote:
> xfs_mark_inode_dirty_sync is used in xfs_inode_item_format but isn't
> actually declared anywhere.

Sorry, this was due to me having some old patch applied still.

> Btw, we also still have the bug that fs/xfs/Kbuild exists as an empty
> files and without removing it nothing is recompiled at all.

But this is still a real issue..
