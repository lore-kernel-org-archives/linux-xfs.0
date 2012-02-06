Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16Gwddr150685 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 10:58:39 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id q9dHILZ3X33Lnzq2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 08:58:38 -0800 (PST)
Date: Mon, 6 Feb 2012 17:58:36 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous
	direct I/O requests
Message-ID: <20120206165836.GJ6890@quack.suse.cz>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-3-git-send-email-jmoyer@redhat.com>
	<20120202173120.GA6640@quack.suse.cz>
	<x49bopcq6gi.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49bopcq6gi.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Mon 06-02-12 11:20:29, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> +	/* workqueue for aio+dio+o_sync disk cache flushing */
> >> +	struct workqueue_struct *aio_dio_flush_wq;
> >> +
> >   Hmm, looking at the patch I'm wondering why did you introduce the new
> > workqueue? It seems dio_unwritten_wq would be enough? You just need to
> > rename it to something more appropriate ;)
> 
> I used a new workqueue as the operations are blocking, and I didn't want
> to hold up other progress.  If you think re-using the unwritten_wq is
> the right thing to do, I'm happy to comply.
  Ah, ok. Thinking about it, it's probably better to use a separate work
queue then.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
