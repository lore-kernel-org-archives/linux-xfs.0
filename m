Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALGqVZ7073813 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 10:52:31 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id YAKOBkG4892yLirJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 08:54:42 -0800 (PST)
Date: Wed, 21 Nov 2012 17:54:36 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous
	direct I/O requests
Message-ID: <20121121165436.GB30250@quack.suse.cz>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074131.24645.38489.stgit@blackbox.djwong.org>
	<20121120100751.GB1408@quack.suse.cz>
	<x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
	<20121121005626.GC10507@quack.suse.cz>
	<x49r4nnujx6.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49r4nnujx6.fsf@segfault.boston.devel.redhat.com>
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
Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org

On Wed 21-11-12 09:09:41, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> Just to be clear, are you saying you would like me to remove the
> >> mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
> >> the common code between this new code path and the fsync path in my tree.)
> >   Yes, after some thinking I came to that conclusion. We actually need to
> > keep i_mutex around ext4_flush_unwritten_io() to avoid livelocks but the
> > rest doesn't need it. The change should be definitely a separate patch just
> > in case there's something subtle I missed and we need to bisect in
> > future... I've attached a patch for that so that blame for bugs goes my way
> > ;) Compile tested only so far. I'll give it some more testing overnight.
> 
> Great, thanks Jan!  I'll include this in the next posting.
  OK, patch passed xfstests and a test banging one file with random IO and
fsyncs from 8 processes (in data=ordered, data=journal, and nojournal
modes). So it seems I didn't miss anything substantial. So ship it! ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
