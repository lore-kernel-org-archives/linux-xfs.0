Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBVAWiB9023014 for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 04:32:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67DD654B63
	for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 02:32:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id f4XZKxpHBB55BHWV for
	<xfs@oss.sgi.com>; Wed, 31 Dec 2008 02:32:43 -0800 (PST)
Date: Wed, 31 Dec 2008 04:30:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfstests: fix compiler warnings
Message-ID: <20081231093009.GA2120@infradead.org>
References: <20081230230810.986105000@bombadil.infradead.org>
	<20081230230912.986540000@bombadil.infradead.org>
	<495AD1EF.3080109@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495AD1EF.3080109@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 30, 2008 at 07:59:11PM -0600, Eric Sandeen wrote:
> Just in case this gets transplanted outside xfstests, where _GNU_SOURCE
> may not be defined on the make commandline, would it make sense to just
> put this #define inside
> 
> #ifndef _GNU_SOURCE?
> 
> Just a thought; otherwise looks good to me.

Yeah, we could.  OR we could expect people who take it outside add it
manually after some feature is missing as we do for all other programs
in xfsqa :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
