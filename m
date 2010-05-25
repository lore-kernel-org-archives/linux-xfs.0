Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PD48Pb249826 for <xfs@oss.sgi.com>; Tue, 25 May 2010 08:04:08 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A631436DEA4
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 06:06:30 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id xDgktCoyxyMskGA9 for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 06:06:30 -0700 (PDT)
Date: Tue, 25 May 2010 09:06:26 -0400
From: tytso@mit.edu
Subject: Re: [PATCH 3/6] ext4: Use our own write_cache_pages()
Message-ID: <20100525130626.GD5556@thunk.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274784852-30502-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, May 25, 2010 at 08:54:09PM +1000, Dave Chinner wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> Make a copy of write_cache_pages() for the benefit of
> ext4_da_writepages().  This allows us to simplify the code some, and
> will allow us to further customize the code in future patches.

I'm going to be pushing this to Linus shortly, so it's likely you'll
be able to drop this from your patch series.  I just wanted to give
you a heads up about what I was planning on doing, which hopefully
simplified your life a little.

      	       	      	  	   	      - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
