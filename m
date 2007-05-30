Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 09:49:40 -0700 (PDT)
Received: from oss.sgi.com (localhost [127.0.0.1])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4UGncWt027407
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 09:49:38 -0700
Date: Wed, 30 May 2007 09:49:38 -0700
Message-Id: <200705301649.l4UGnckA027406@oss.sgi.com>
From: "Michael Nishimoto" <miken@stanfordalumni.org>
Subject: Reducing memory requirements for high extent xfs files
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

Has anyone done any work or had thoughts on changes required
to reduce the total memory footprint of high extent xfs files?

Obviously, it is important to reduce fragmentation as files
are generated and to regularly defrag files, but both of these 
alternatives are not complete solutions.

To reduce memory consumption, xfs could bring in extents
from disk as needed (or just before needed) and could free 
up mappings when certain extent ranges have not been recently
accessed.  A solution should become more aggressive about 
reclaiming extent mapping memory as free memory becomes limited.

   Michael


____________________________________________________________________
   
