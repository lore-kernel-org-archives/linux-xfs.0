Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3Aq7NO010880 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 04:52:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCC221A73A09
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 02:52:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YraYFyBlVtMYEw8W for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 02:52:06 -0800 (PST)
Date: Wed, 3 Dec 2008 05:51:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 08/22] reduce l_icloglock roundtrips
Message-ID: <20081203105136.GH15485@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160650.663976000@bombadil.infradead.org>
	<20081203025614.GG18236@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203025614.GG18236@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 01:56:14PM +1100, Dave Chinner wrote:
> On Tue, Dec 02, 2008 at 11:04:38AM -0500, Christoph Hellwig wrote:
> > All but one caller of xlog_state_want_sync drop and re-acquire
> > l_icloglock around the call to it, just so that xlog_state_want_sync can
> > acquire and drop it.
> 
> Not really a performance problem, though, because the one caller
> that doesn't already hold the lock is the common path (i.e.
> xlog_write()); the others are in the  unmount path, so lock traffic
> is not there is not performance critical....
> 
> Hence I'm not sure this is really necessary.

I don't think it's absolutely nessecary, but it's a lot cleaner this
way..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
