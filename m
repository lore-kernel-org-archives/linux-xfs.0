Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 15:16:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l77MGVbm026371
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 15:16:34 -0700
Date: Tue, 7 Aug 2007 18:13:49 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into
 individual setattr functions (RESEND)
Message-Id: <20070807181349.5d4175c7.jlayton@redhat.com>
In-Reply-To: <20070807204909.GA30159@infradead.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807204909.GA30159@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

On Tue, 7 Aug 2007 21:49:09 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> First thanks a lot for doing this work, it's been long needed.
> 
> Second please don't send out that many patches.  We encourage people
> to split things into small patches when the changes are logially
> separated.  Which these are not - it's a flag day change (which btw
> is fine despite the rants soe people spewed in reply to this), so it
> should be one single patch. (Or one for all mainline filesystems +
> one per fs only in -mm to make Andrew's life a little easier if you
> really care.)

Thanks. I debated about how best to split these up. A coworker
mentioned that Andrew had tossed him back a single patch that
touched several mainline filesystems and asked him to break it 
up. I took that to mean that the patches should generally be split
out, but I guess I took that too far ;-)

-- 
Jeff Layton <jlayton@redhat.com>
