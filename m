Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FHDL0b079970 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 12:13:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7058ABD7613
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:16:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FHLE8aUcvBuibo2N for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:16:45 -0700 (PDT)
Date: Fri, 15 Apr 2011 13:16:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110415171629.GA9088@infradead.org>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard> <87sjtjq4ir.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sjtjq4ir.fsf@rho.meyering.net>
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
To: Jim Meyering <jim@meyering.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, coreutils@gnu.org, linux-ext4@vger.kernel.org, P?draig Brady <P@draigBrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Fri, Apr 15, 2011 at 10:53:48AM +0200, Jim Meyering wrote:
> Can you or anyone else point to authoritative documentation
> (or even a summary of those "discussions") of FIEMAP semantics?

A large part of the problem is that there's none and the semantics
is a hode-podge of random flags that mostly make little sense
outside of fs developers debugging the layout that we created.  The
closest to a description is Documentation/filesystems/fiemap.txt
in the kernel tree, but that doesn't document most of the delicate
points.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
