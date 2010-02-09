Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19Hpr3u238557 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 11:51:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AC2E1BE0B1
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2010 09:53:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1qvGhlM5Y1zF4JvW for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2010 09:53:07 -0800 (PST)
Date: Tue, 9 Feb 2010 12:53:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests: fix up fs_perms test used by 126
Message-ID: <20100209175305.GA10833@infradead.org>
References: <4B6C4E81.6060201@sandeen.net>
	<20100208194058.GC9527@infradead.org>
	<4B71935E.7090907@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B71935E.7090907@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 09, 2010 at 10:54:54AM -0600, Eric Sandeen wrote:
> Test 126 was failing intermittently for Ted & I; it seems that
> this is because we were passing an unterminated string to
> fopen for the mode; I'm not certain why this made it fail,
> but it's pretty clearly not a good thing to do, and fixing
> it fixes the test.
> 
> Rather than passing around characters, do things string-wise,
> since that is what is ultimately used in fopen().
> 
> Reported-by: Theodore Tso <tytso@mit.edu>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
