Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALLZNkg098959 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 15:35:24 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id UfzyZQ7Zl5yI4VQ7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 13:37:34 -0800 (PST)
Date: Wed, 21 Nov 2012 22:37:32 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
Message-ID: <20121121213732.GG30250@quack.suse.cz>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074123.24645.41965.stgit@blackbox.djwong.org>
	<20121121100809.GE23339@infradead.org>
	<x497gpevqoy.fsf@segfault.boston.devel.redhat.com>
	<20121121182901.GA4519@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121121182901.GA4519@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, tytso@mit.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, bpm@sgi.com, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

On Wed 21-11-12 13:29:01, Christoph Hellwig wrote:
> On Wed, Nov 21, 2012 at 11:58:05AM -0500, Jeff Moyer wrote:
> > > I'd like to use this as a vehicle to revisit how dio completions work.
> > 
> > I don't like the sound of that.  ;-)  It sounds like this bugfix may get
> > further delayed by the desire for unrelated code cleanup.
> 
> I've got a prototype that isn't much more invasive than the current
> series.  I'll finish it up and run it through QA and will post it
> tomorrow.
  Great, I wanted to have a look into it but you beat me to it ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
