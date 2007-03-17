Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 Mar 2007 08:40:41 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2HFeY6p012804
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 08:40:36 -0700
Date: Sat, 17 Mar 2007 16:40:28 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: HAVE_FORMAT32 never enabled in mainline
Message-ID: <20070317154028.GA18997@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: tes@melbourne.sgi.com, xfs@oss.sgi.com

Looks like the code for dealing with x86/amd64 logs is never actually 
enable in mainline because nothing defines HAVE_FORMAT32.
