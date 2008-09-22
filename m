Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 04:04:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MB4oFh017972
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:04:52 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C2AC46B082
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:24 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id rcBF5ZpItJQkb9qH for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:24 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8MB6NIF026026
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 13:06:23 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8MB6NxH026023
	for xfs@oss.sgi.com; Mon, 22 Sep 2008 13:06:23 +0200
Date: Mon, 22 Sep 2008 13:06:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/6] btree cleanups V2
Message-ID: <20080922110623.GA26007@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Here's a set of a few small btree cleanup patches.  Most of them are in
preparation of adding CRC support to the btree blocks.  All these
require the generic btree patchset to be applied first.

Compared to version 1 I've addressed Dave's review comments.  I decided to
keep XFS_BMAP_BROOT_PTR_ADDR because it's used a few times and already in
long enough lines that would start to get unreadable if we expanded it. I've
also left the odd boolean arguments to the maxrecs functions as is for now,
but I have some plans to tackle that from a higher level view later.

-- 
