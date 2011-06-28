Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S8jtck204139 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 03:45:55 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F33B634CFD
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 01:45:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3u6OsWJJDc7mGgv7 for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 01:45:52 -0700 (PDT)
Date: Tue, 28 Jun 2011 18:45:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: don't hard code the shell binary
Message-ID: <20110628084535.GM32466@dastard>
References: <1309245348-12638-1-git-send-email-david@fromorbit.com>
	<20110628074137.GA6123@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110628074137.GA6123@infradead.org>
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

On Tue, Jun 28, 2011 at 03:41:37AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 28, 2011 at 05:15:48PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recent changes to debian unstable user space have caused the
> > xfsprogs build to break as certain shell functionality is being
> > assumed by libtool and friends.  The configure scripts test and
> > select the correct shell, but the input files ignore this and hard
> > code the shell to use and hence now break.
> > 
> > Fix this by using the shell that the configure scripts decide is the
> > right one to use.
> 
> Looks good.  The same fix should also be applied to xfsdump, xfstests
> and dmapi.

Yes, it should. I just haven't got to them yet ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
