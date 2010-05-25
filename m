Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PMesT3045610 for <xfs@oss.sgi.com>; Tue, 25 May 2010 17:40:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E33FA4C0BD
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 15:44:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	JgW1z3Uy7u2n1kLo for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 15:44:55 -0700 (PDT)
Date: Wed, 26 May 2010 08:42:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] ext4: Use our own write_cache_pages()
Message-ID: <20100525224259.GM2150@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-4-git-send-email-david@fromorbit.com>
	<20100525130626.GD5556@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100525130626.GD5556@thunk.org>
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
To: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, jens.axboe@oracle.com

On Tue, May 25, 2010 at 09:06:26AM -0400, tytso@mit.edu wrote:
> On Tue, May 25, 2010 at 08:54:09PM +1000, Dave Chinner wrote:
> > From: Theodore Ts'o <tytso@mit.edu>
> > 
> > Make a copy of write_cache_pages() for the benefit of
> > ext4_da_writepages().  This allows us to simplify the code some, and
> > will allow us to further customize the code in future patches.
> 
> I'm going to be pushing this to Linus shortly, so it's likely you'll
> be able to drop this from your patch series.

Great!

> I just wanted to give
> you a heads up about what I was planning on doing, which hopefully
> simplified your life a little.

And that's appreciated. I included it to make sure everyone could
see how this all fitted together and others could test it if they so
desired. i.e. make sure I wasn't breaking ext4 by reverting the
changes to write_cache_pages. I'll leave it in the series until the
ext4 change is upstream, then I'll drop it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
