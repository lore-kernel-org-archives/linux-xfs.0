Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:07:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NK7EbF015417
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:07:15 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0B2D31C26C
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:24 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Aozsi4BGBMxdRcyb for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:24 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NK8ENg007416
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:08:15 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NK8ERD007414
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 22:08:14 +0200
Date: Wed, 23 Jul 2008 22:08:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 00/15] Btree cleanups and unification
Message-ID: <20080723200814.GA7401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've started reviewing and reshuffling the common btree implementations
from Dave.  This patch series is a status of the patches I have run
successfully through XFSQA so far.  All the really hairy operations are
still missing, but I'm interested in some feedback on the approach.

Patches 1 and 2 are rather trivial cleanups that could probably be
applied ASAP.

-- 
