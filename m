Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 03:28:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIBSO3L016764
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 03:28:24 -0800
Received: from kraid.nerim.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C439117EFC9
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 03:28:36 -0800 (PST)
Received: from kraid.nerim.net (smtp-102-tuesday.nerim.net [62.4.16.102]) by cuda.sgi.com with ESMTP id gxf6Yf4Qya00MEvG for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 03:28:36 -0800 (PST)
Date: Tue, 18 Dec 2007 12:28:04 +0100
From: Damien Wyart <damien.wyart@free.fr>
Subject: Important regression with XFS update for 2.6.24-rc6
Message-ID: <20071218112804.GA3069@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

Hello,

As a follow-up to
<http://marc.info/?l=linux-kernel&m=119796120524618&w=2> (LKML seems
down right now so I am not linking to it), I have detected an important
problem with these two patches: after applying them by hand (downloaded
them raw from SGI's gitweb) on top of 2.6.24-rc5-git5 (they have not yet
been pulled into mainline by Linux as of this morning) for testing
purposes, I noticed upon reboot that "ls -l" on directories with many
files and subdirectories (around 5000 entries) takes several hundreds of
MB in RAM and then dies with "memory exhausted" error.

I also noticed that ldconfig takes a lot of time to complete, and
firefox seems also to eat much more memory than usual. Reverting the two
patches (going back to vanilla rc5-git5) makes these problems go away.
I am not able to test right now if only one of the patches is bogus or
if both of them are concerned.

As the symptoms are easy to reproduce, I guess this is some kind of
brown paper bag bug and will be easy for XFS experts to spot.


Best,

-- 
Damien Wyart
