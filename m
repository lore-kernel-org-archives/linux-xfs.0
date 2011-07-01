Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619b8uE055694 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:37:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0EC714FC7FD
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:37:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kG9C2DM0u1FGJKkk for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:37:06 -0700 (PDT)
Date: Fri, 1 Jul 2011 05:37:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110701093702.GA28684@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110629065306.GC1026@dastard>
	<20110629074021.GA26086@infradead.org>
	<4E0B019E.8080800@draigBrady.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E0B019E.8080800@draigBrady.com>
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
To: P?draig Brady <P@draigBrady.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>

On Wed, Jun 29, 2011 at 11:42:38AM +0100, P?draig Brady wrote:
> There is the argument, that if this interface can distinguish
> these dirty unwritten extents, then why can't the fiemap interface too?
> The advantage of the fiemap interface is that it can distinguish
> empty extents vs holes. Empty extents will become increasingly common
> I think, given the fragmentation and space guarantee benefits they give.
> It would be cool for cp for example to be able to efficiently copy
> empty extents from source to dest.

That brings us back to square one.  FIEMAP is supposed to tell you about
the physical layout on disk.  Unwritten extents physically always are
there, but whether they might have to be copied depends entirely on
in-core state.  Finding that incore state in addition is not all that
easy compared to simply walking the extents.  People might decide it's
worth for an interface like SEEK_HOLE specificly asking for that, but
grafting it into FIEMAP through the backdoor is a horrible idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
