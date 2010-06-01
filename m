Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o51Fq88q004690 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 10:52:08 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4FA715828B9
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 08:56:52 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 8gPHGfDI5d5ot2FW for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 08:56:52 -0700 (PDT)
Date: Tue, 1 Jun 2010 17:54:17 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-ID: <20100601155417.GA7425@quack.suse.cz>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-7-git-send-email-david@fromorbit.com>
	<20100527143341.d4258798.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527143341.d4258798.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu 27-05-10 14:33:41, Andrew Morton wrote:
> On Tue, 25 May 2010 20:54:12 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > sync can currently take a really long time if a concurrent writer is
> > extending a file. The problem is that the dirty pages on the address
> > space grow in the same direction as write_cache_pages scans, so if
> > the writer keeps ahead of writeback, the writeback will not
> > terminate until the writer stops adding dirty pages.
> 
> <looks at Jens>
> 
> The really was a pretty basic bug.  It's writeback 101 to test that case :(
  The code has this live-lock since Nick fixed data integrity issues in
write_cache_pages which was (digging) commit 05fe478d ("mm:
write_cache_pages integrity fix") in January 2009. Jens just kept the code
as it was...

...
> That being said, I think the patch is insufficient.  If I create an
> enormous (possibly sparse) file with a 16TB hole (or a run of clean
> pages) in the middle and then start busily writing into that hole (run
> of clean pages), the problem will still occur.
> 
> One obvious fix for that (a) would be to add another radix-tree tag and
> do two passes across the radix-tree.
> 
> Another fix (b) would be to track the number of dirty pages per
> adddress_space, and only write that number of pages.
> 
> Another fix would be to work out how the code handled this situation
> before we broke it, and restore that in some fashion.  I guess fix (b)
> above kinda does that.
  (b) does not work for data integrity sync (see changelog of the above
mentioned commit). I was sending a patch doing (a) in February but in
particular you raised concerns whether it's not too expensive... Since
it indeed has some cost (although I was not able to measure any performance
impact) and I didn't know a better solution, I just postponed the patches.
But I guess it's time to revive the series and maybe we'll get further with
it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
