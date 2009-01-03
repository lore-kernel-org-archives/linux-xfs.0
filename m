Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n03LjIEo006225 for <xfs@oss.sgi.com>; Sat, 3 Jan 2009 15:45:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFDF55C990
	for <xfs@oss.sgi.com>; Sat,  3 Jan 2009 13:45:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qh3KSisi6FqvE0HN for
	<xfs@oss.sgi.com>; Sat, 03 Jan 2009 13:45:17 -0800 (PST)
Date: Sat, 3 Jan 2009 16:44:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20090103214443.GA6612@infradead.org>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org>
	<20081230042333.GC27679@wotan.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081230042333.GC27679@wotan.suse.de>
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
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Klotz <peter.klotz@aon.at>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com

On Tue, Dec 30, 2008 at 05:23:33AM +0100, Nick Piggin wrote:
> On Tue, Dec 23, 2008 at 12:12:59PM -0500, Christoph Hellwig wrote:
> > 
> > Nick, I've seen various reports like this by Roman.  It seems to be
> > caused by an interaction of the lockless pagecache with the xfs
> > I/O code.  Any idea what might be wrong here:
> 
> Hmm, it could get into a loop here if there is a page in the pagecache
> with a zero refcount, which might be a problem with XFS... other looping
> conditions might indicate a problem iwth lockless pagecache or radix
> tree. It would be very helpful to know what condition it is looping on...

See http://oss.sgi.com/bugzilla/show_bug.cgi?id=805

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
