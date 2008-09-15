Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 17:45:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F0j29u024145
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:45:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D153F129CD7F
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:32 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id PJdq1WeNIphBByIl for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:32 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8F0kVIF012245
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 02:46:32 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8F0kVJx012243
	for xfs@oss.sgi.com; Mon, 15 Sep 2008 02:46:31 +0200
Date: Mon, 15 Sep 2008 02:46:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/6] btree cleanups
Message-ID: <20080915004631.GA12213@lst.de>
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

-- 
