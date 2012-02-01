Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11AOleG238808 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 04:24:47 -0600
Date: Wed, 1 Feb 2012 05:24:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: remove calls to XFS_QSYNC
Message-ID: <20120201102436.GB26638@infradead.org>
References: <20120130115024.GA884@infradead.org>
	<CAAp5ZgNKsY-OrWyDNU70KUKYCZUX_EvzngAvBsBTgrgkK6KyMA@mail.gmail.com>
	<20120131162617.GF7762@sgi.com> <20120131210110.GN9090@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131210110.GN9090@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

On Wed, Feb 01, 2012 at 08:01:10AM +1100, Dave Chinner wrote:
> So effectively what that says to me is that quota only exports the
> real block usage, even though it internally tracks delalloc
> reservations. Perhaps an additionaly change to make in this case is
> to fold the reserved blocks into what is reported to the quota
> utilities?
> 
> Indeed, what is exported to userspace via xfs_qm_export_dquot() is
> the information in the dquot core - the on-disk information - so
> perhaps all we need to do is export dqp->q_res_bcount (the count of
> real + reserved blocks) instead of the on-disk info?

That seems like a good idea, given that enforcement takes the
reservation into account.  To retain compatbility for the case of new
userspace and an old kernel I'd have to disable Q_XQUOTASYNC in the
kernel intead of in the tool, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
