Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q298NBLj184450 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 02:23:11 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id HpGXgQDk85BJYiZS (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Mar 2012 00:23:09 -0800 (PST)
Date: Fri, 9 Mar 2012 09:23:06 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120309082306.GB21038@quack.suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-12-git-send-email-jack@suse.cz>
	<20120308232041.GU3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308232041.GU3592@dastard>
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
Cc: sandeen@redhat.com, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org

On Fri 09-03-12 10:20:41, Dave Chinner wrote:
> On Mon, Mar 05, 2012 at 05:01:09PM +0100, Jan Kara wrote:
> > Generic code now blocks all writers from standard write paths. So we block all
> > writers coming from ioctl and replace blocking of transactions on frozen
> > filesystem with a debugging check. As a bonus, we get a protection of ioctl
> > against racing remount read-only. We also convert xfs_file_aio_write() to a
> > non-racy freeze protection.
> ....
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 329b06a..6468a2a 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -577,7 +577,6 @@ xfs_trans_alloc(
> >  	xfs_mount_t	*mp,
> >  	uint		type)
> >  {
> > -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> >  	return _xfs_trans_alloc(mp, type, KM_SLEEP);
> >  }
> 
> So what is there to stop internal XFS threads from starting
> transactions when the filesystem is frozen? Previously this
> SB_FREEZE_TRANS would guarantee even internal fucntions would get
> stopped, but now there's nothing?
> 
> I do beleive that ext4 has the same problem (the issue reported with
> the lazy inode init background thread), and I can see that any other
> filesystem that can make modifications via internal triggers will
> see the same problem - freeze doesn't block them any more...
  Yes, I'll have to audit filesystem internal threads. I forgot about these
in the first round. Most of them shouldn't have anything to do because the
filesystem is clean but there are exceptions as ext4 lazyinit has shown.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
