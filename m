Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p330DetW069889 for <xfs@oss.sgi.com>; Sat, 2 Apr 2011 19:13:41 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 402AA1E015B5
	for <xfs@oss.sgi.com>; Sat,  2 Apr 2011 17:16:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	x75hlkGC7QTJtQmt for <xfs@oss.sgi.com>;
	Sat, 02 Apr 2011 17:16:52 -0700 (PDT)
Date: Sun, 3 Apr 2011 10:16:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix xfs_debug warnings
Message-ID: <20110403001648.GH6957@dastard>
References: <20110402181340.GA12639@infradead.org>
	<20110402220905.GA1861@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110402220905.GA1861@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sat, Apr 02, 2011 at 06:09:05PM -0400, Christoph Hellwig wrote:
> Err, the subject should have been:
> 
> [PATCH] xfs: fix xfs_debug warnings
> 
> On Sat, Apr 02, 2011 at 02:13:40PM -0400, Christoph Hellwig wrote:
> > For a CONFIG_XFS_DEBUG=n build gcc complains about statements with no
> > effect in xfs_debug:
> > 
> > fs/xfs/quota/xfs_qm_syscalls.c: In function 'xfs_qm_scall_trunc_qfiles':
> > fs/xfs/quota/xfs_qm_syscalls.c:291:3: warning: statement with no effect
> > 
> > The reason for that is that the various new xfs message functions have a
> > return value which is never used, and in case of the non-debug build
> > xfs_debug the macro evaluates to a plain 0 which produces the above
> > warnings.  This can be fixed by turning xfs_debug into an inline function
> > instead of a macro, but in addition to that I've also changed all the
> > message helpers to return void as we never use their return values.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, though I don't get those warnings using gcc-4.4.4. I
guess it's gcc-4.6 issuing the warnings?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
