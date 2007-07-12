Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 08:28:56 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6CFSibm025540
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 08:28:46 -0700
Received: from hch by pentafluge.infradead.org with local (Exim 4.63 #1 (Red Hat Linux))
	id 1I90DX-00013I-Pz
	for xfs@oss.sgi.com; Thu, 12 Jul 2007 16:04:31 +0100
Date: Thu, 12 Jul 2007 16:04:31 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsqa 144 is failing now
Message-ID: <20070712150431.GA3763@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I'm trying to fix up dmapi for the patch that uses filldir internally,
and 144 is the xfsqa test for this functionality.  It worked fine a
few weeks ago when I started that work but fails with plain TOT linux-xfs
now with errors like:


< report: get #0 had no errors.
< report: get #1 had no errors.
---
> ERROR: get #0, expected mode 35034, but found 33188
> ERROR: get #0, expected uid -756063452, but found 0
> ERROR: get #0, expected gid 323693819, but found 0
> ERROR: get #0, expected mtime -424339458, but found 1184248449
> ERROR: get #0, expected ctime -862739105, but found 1184248449
> ERROR: get #0, expected dtime -862739105, but found 1184248449
> ERROR: get #0, expected size 1125898004553757, but found 29696
> report: 1 tests correct for get #0.
> ERROR: get #1, expected mode 34544, but found 33188
> ERROR: get #1, expected uid -1407127963, but found 0
> ERROR: get #1, expected gid 1043573623, but found 0
> ERROR: get #1, expected mtime -1589334486, but found

does anyone have an idea what might be causing this?

The only recent changes to xfs_dm.c are the hole punching fixes which
seem rather unrelated.
