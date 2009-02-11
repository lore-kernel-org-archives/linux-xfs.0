Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BMdxVS160157 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 16:40:00 -0600
Date: Wed, 11 Feb 2009 17:39:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: fix error handling in xfs_log_mount
Message-ID: <20090211223923.GA25252@infradead.org>
References: <20090210194422.767988000@bombadil.infradead.org>
	<20090210194515.509547000@bombadil.infradead.org>
	<A482AB92-6E29-43EA-A671-43D86E041335@sgi.com>
	<20090210195756.GA7569@infradead.org>
	<1E52072E-CA98-430B-9B2F-FDD0FDD1A7A4@sgi.com>
	<49920CB5.1020103@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49920CB5.1020103@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 11, 2009 at 10:24:37AM +1100, Lachlan McIlroy wrote:
> I'd prefer both fixes go in so we have maximum defence against
> this problem happening again but I'm really not fussed.

I disagree.  All these weird error checks for things that can't happen
just make the code big, bloated and unreadable.  And they make people
sloppy by not enforcing the same unwind order thus leading to more
bugs (as seen by the historic xfs mount path before we started unwinding
it)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
