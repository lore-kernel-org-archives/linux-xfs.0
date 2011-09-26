Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8Q0SIFZ092353 for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 19:28:18 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 699E11825F9
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 17:28:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FRo8a1cYngRGlDfK for <xfs@oss.sgi.com>;
	Sun, 25 Sep 2011 17:28:16 -0700 (PDT)
Date: Mon, 26 Sep 2011 10:28:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Directory fsync
Message-ID: <20110926002811.GA3159@dastard>
References: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
	<20110923163354.GA24319@infradead.org> <201109240109.45532@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201109240109.45532@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Zhu Han <schumi.han@gmail.com>, xfs@oss.sgi.com

On Sat, Sep 24, 2011 at 01:09:44AM +0200, Michael Monnerie wrote:
> On Freitag, 23. September 2011 Christoph Hellwig wrote:
> > As far as standards are concerned it is.  As far as the current XFS
> > implementation is concerned you don't need it as the file fsync will
> > also force out all transactions that belong to the create.
> 
> Aren't you giving O_PONIES to the users? ;-)
> 
> I understand your description, but we should always tell people to use a 
> directory fsync to be sure. Their applications might run on other 
> filesystems, or run for 10 years, and maybe XFS's implementation changes 
> in between. And maybe in historical kernels even XFS's implementation 
> wasn't like it's now?

XFS's journalling has always behaved this way - *all* transactions
prior to the fsync() triggered log force are guaranteed to be on
disk once the fsync completes. There are no plans to change this
behaviour, either, because we rely on this architectural
characteristic to provide strong ordering of metadata operations in
many places.

All it means is that the directory fsync() is a no-op that only
costs CPU time.

> @schumi: If your application should be able to run in a safe way on 
> other filesystems, or other kernel releases, or other unixes, it's best 
> to fsync the directory inode too. It's better to use it always, then 
> nothing won't break.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
