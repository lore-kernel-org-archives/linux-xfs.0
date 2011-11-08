Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8HItB8135683 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 11:18:55 -0600
Date: Tue, 8 Nov 2011 11:19:08 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [BUG] assert in xfs_imap_to_bp, line 185
Message-ID: <20111108171908.GN20464@sgi.com>
References: <20111108163932.GA22095@sgi.com>
	<20111108170606.GA17457@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111108170606.GA17457@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 12:06:07PM -0500, Christoph Hellwig wrote:
> On Tue, Nov 08, 2011 at 10:39:32AM -0600, Ben Myers wrote:
> > Hi XFS Folks,
> > 
> > I am able to hit this assert consistently when running test 111 on recent
> > (commit 9e4c109a) oss xfs bits:
> 
> That's expected - the test must only be run on non-debug kernels.  It
> corrupt the inode, and then we read it.  A normal kernel shouldn't
> panic, but for the debug kernel we settled on an assert for it.
> 
> I'm not sure it's a smart idea, and WANT_CORRUPTED_GOTO might be
> better in the end.

Thanks Christoph!  Sorry for the extra noise.. I'll remember use the
'auto' group next time.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
