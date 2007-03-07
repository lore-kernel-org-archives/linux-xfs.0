Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Mar 2007 02:13:16 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l27ADA6p031333
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 02:13:12 -0800
Date: Wed, 7 Mar 2007 11:13:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/2] xfs: only use refcounted pages for I/O
Message-ID: <20070307101302.GA30587@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org

Many block drivers (aoe, iscsi) really want refcountable pages in
bios, which is what almost everyone send down.  XFS unfortunately
has a few places where it sends down buffers that may come from
kmalloc, which breaks them.  The patches in this series fix this
issue up.
