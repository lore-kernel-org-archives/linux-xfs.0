Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35Ji3q9015031 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 14:44:03 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7071C29C702
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 12:45:53 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id tXz1ejyaHHB0Pvu1 for <xfs@oss.sgi.com>;
	Mon, 05 Apr 2010 12:45:53 -0700 (PDT)
Date: Mon, 5 Apr 2010 15:45:47 -0400
From: tytso@mit.edu
Subject: Re: [PATCH] xfstests: don't use -s option to repquota
Message-ID: <20100405194547.GA23670@thunk.org>
References: <20100405190428.GA3807@infradead.org>
	<4BBA3CA7.8000206@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BBA3CA7.8000206@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Apr 05, 2010 at 02:40:23PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > The -s option to repquota used to be a no-op, but actually changes
> > output to different units in quota tools 4.0.  Remove it from the
> > repquota invocation in test 219.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks, Ted was hitting this too.
> 
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Thanks, I had submitting the patch on my todo list, and you just saved
me the effort of sending it.  :-)

I already had this change in my tree, and it works fine for me.

Tested-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
