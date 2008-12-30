Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU4NZNY003754 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 22:23:35 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B0DA1795387
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 20:23:34 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id KqDLla7ihVVOLT3o for <xfs@oss.sgi.com>;
	Mon, 29 Dec 2008 20:23:34 -0800 (PST)
Date: Tue, 30 Dec 2008 05:23:33 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20081230042333.GC27679@wotan.suse.de>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081223171259.GA11945@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com

On Tue, Dec 23, 2008 at 12:12:59PM -0500, Christoph Hellwig wrote:
> 
> Nick, I've seen various reports like this by Roman.  It seems to be
> caused by an interaction of the lockless pagecache with the xfs
> I/O code.  Any idea what might be wrong here:

Hmm, it could get into a loop here if there is a page in the pagecache
with a zero refcount, which might be a problem with XFS... other looping
conditions might indicate a problem iwth lockless pagecache or radix
tree. It would be very helpful to know what condition it is looping on...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
