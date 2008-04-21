Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 23:08:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L67vOl006066
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 23:08:00 -0700
Date: Mon, 21 Apr 2008 02:08:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PARTIAL TAKE 976035 - kill usesless IHOLD calls in xfs_rename
Message-ID: <20080421060836.GA31296@infradead.org>
References: <20080421052419.E52E458C4C15@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421052419.E52E458C4C15@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Any reason you didn't commit:

  [PATCH 1/2] kill parent == child checks in xfs_remove and xfs_rmdir
  [PATCH 2/2] kill usesless IHOLD calls in xfs_remove and xfs_rmdir

in this round, it's pretty much the equivalent treatment to remove and
rmdir that we did to rename in this and the previous patch.
