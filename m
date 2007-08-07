Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 14:14:49 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l77LEfbm006443
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 14:14:43 -0700
Date: Tue, 7 Aug 2007 21:49:09 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into individual setattr functions (RESEND)
Message-ID: <20070807204909.GA30159@infradead.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

First thanks a lot for doing this work, it's been long needed.

Second please don't send out that many patches.  We encourage people
to split things into small patches when the changes are logially
separated.  Which these are not - it's a flag day change (which btw
is fine despite the rants soe people spewed in reply to this), so it
should be one single patch. (Or one for all mainline filesystems +
one per fs only in -mm to make Andrew's life a little easier if you
really care.)
