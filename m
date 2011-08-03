Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73C2u5Z151665 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 07:02:56 -0500
Date: Wed, 3 Aug 2011 08:02:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] xfsdump: convert to using the POSIX signal API
Message-ID: <20110803120245.GA25335@infradead.org>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<20110803105911.GA7226@infradead.org> <4E3937B1.7050207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E3937B1.7050207@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Aug 03, 2011 at 06:57:37AM -0500, Bill Kendall wrote:
> Christoph Hellwig wrote:
> >Bill,
> >
> >one thing I noticed looking over the code to understand your changes
> >is that there still is a lot of dead code in xfsdump.  One that
> >has a lot of implications and seems fairly useless for any non-IRIX
> >version is the miniroot mode.  Any chance we can rip that out?  There's
> 
> Yes, that's being used to disable multi-stream code in the Linux version.
> The end of my multi-stream patch series removes the miniroot code.

Ooops, I didn't notice miniroot is actually defined to true.  Now that
I look deeper that also answers my comment about the duplicate signal
setup in main - one it's done for the miniroot case, and once for the
!miniroot case.

Now that we uses EPIPE instead of SIGPIPE is there actually any good
reason to do this setup in two different places?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
