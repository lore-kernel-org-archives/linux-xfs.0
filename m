Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FHMhwZ080559 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 12:22:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBF6D1BDB964
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:26:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ISxTzgVe9ButwIbD for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:26:06 -0700 (PDT)
Date: Fri, 15 Apr 2011 13:26:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110415172603.GA20086@infradead.org>
References: <20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard> <87sjtjq4ir.fsf@rho.meyering.net>
	<20110415171629.GA9088@infradead.org> <4DA87F43.5040807@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DA87F43.5040807@redhat.com>
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
To: Eric Blake <eblake@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jim Meyering <jim@meyering.net>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, coreutils@gnu.org, linux-ext4@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>

On Fri, Apr 15, 2011 at 11:24:19AM -0600, Eric Blake wrote:
> Would it be worth borrowing from Solaris' semantics and adding SEEK_HOLE
> and SEEK_DATA to lseek(2), as a higher level (less-detailed, but easier
> to define and easier to use) interface for discovering the regions of a
> file that only contain NUL bytes?

Yes, I've already suggested that both in this thread and on IRC.

For efficient copies it's the only usable interface.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
