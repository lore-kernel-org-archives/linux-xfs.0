Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C9357F51
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 10:32:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F286AC010
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 08:32:39 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id OKQi6DOH1Sxn36Us (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 08:32:38 -0700 (PDT)
Date: Fri, 10 Oct 2014 17:32:35 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] block: free q->flush_rq in blk_init_allocated_queue
	error paths
Message-ID: <20141010153235.GA8705@quack.suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
	<1412951028-4085-3-git-send-email-jack@suse.cz>
	<20141010151906.GB8874@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141010151906.GB8874@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Jones <davej@redhat.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Jens Axboe <axboe@fb.com>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri 10-10-14 11:19:06, Dave Jones wrote:
> On Fri, Oct 10, 2014 at 04:23:07PM +0200, Jan Kara wrote:
>  > From: Dave Jones <davej@redhat.com>
>  > 
>  > Commit 7982e90c3a57 ("block: fix q->flush_rq NULL pointer crash on
>  > dm-mpath flush") moved an allocation to blk_init_allocated_queue(), but
>  > neglected to free that allocation on the error paths that follow.
>  > 
>  > Signed-off-by: Dave Jones <davej@fedoraproject.org>
>  > Acked-by: Mike Snitzer <snitzer@redhat.com>
>  > Signed-off-by: Jens Axboe <axboe@fb.com>
>  > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Um, This got applied months ago.
  Yes, I mistakenly used git-send-email on a wrong directory. Sorry for
confusion...
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
