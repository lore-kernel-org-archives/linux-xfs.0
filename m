Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALE7iCd050614 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 08:07:44 -0600
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous direct
	I/O requests
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074131.24645.38489.stgit@blackbox.djwong.org>
	<20121120100751.GB1408@quack.suse.cz>
	<x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
	<20121121005626.GC10507@quack.suse.cz>
Date: Wed, 21 Nov 2012 09:09:41 -0500
In-Reply-To: <20121121005626.GC10507@quack.suse.cz> (Jan Kara's message of
	"Wed, 21 Nov 2012 01:56:26 +0100")
Message-ID: <x49r4nnujx6.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> Just to be clear, are you saying you would like me to remove the
>> mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
>> the common code between this new code path and the fsync path in my tree.)
>   Yes, after some thinking I came to that conclusion. We actually need to
> keep i_mutex around ext4_flush_unwritten_io() to avoid livelocks but the
> rest doesn't need it. The change should be definitely a separate patch just
> in case there's something subtle I missed and we need to bisect in
> future... I've attached a patch for that so that blame for bugs goes my way
> ;) Compile tested only so far. I'll give it some more testing overnight.

Great, thanks Jan!  I'll include this in the next posting.

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
