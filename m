Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IHVuvG012999 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:31:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8B0D1818296
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 09:31:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fm10eEVCUeayQ45z for
	<xfs@oss.sgi.com>; Sun, 18 Jan 2009 09:31:55 -0800 (PST)
Date: Sun, 18 Jan 2009 12:31:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090118173144.GA1999@infradead.org>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jan 13, 2009 at 11:28:58PM -0500, Mikulas Patocka wrote:
> The result must not depend on magic timer values. If it does, you end up 
> with undebbugable nondeterministic failures.
> 
> Why don't you change that 500ms wait to "wait until the flush finishes"? 
> That would be correct.

Yes, this probably would better.  Could I motivate you to come up with
a patch for that?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
