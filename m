Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Oct 2007 11:02:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9SI21i8018117
	for <linux-xfs@oss.sgi.com>; Sun, 28 Oct 2007 11:02:02 -0700
From: Andreas Gruenbacher <agruen@suse.de>
Subject: acl and attr: libmisc linkage
Date: Sun, 28 Oct 2007 19:04:04 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281904.04818.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>
Cc: Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

Hello,

I noticed that in some cases, gcc is unhappy when libmisc.a is specified after 
libattr.so and libacl.so, and doesn't link in stuff from libmisc.a 
(specifically, walk_tree). I don't know the exact reason for this behavior, 
but putting libmisc.a before the dynamic libraries fixes the problem, i.e., 
like this:

  -LLDLIBS = $(LIBACL) $(LIBATTR) $(LIBMISC)
  -LTDEPENDENCIES = $(LIBACL) $(LIBMISC)
  +LLDLIBS = $(LIBMISC) $(LIBACL) $(LIBATTR)
  +LTDEPENDENCIES = $(LIBMISC) $(LIBACL)

Is that acceptable?

Thanks,
Andreas
