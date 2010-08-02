Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o72HlSah199734 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 12:47:28 -0500
Subject: Re: [PATCH] xfstests: have getfacl(1) report numeric id's
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100801141549.GB10192@infradead.org>
References: <201007302154.o6ULsNdm008915@stout.americas.sgi.com>
	<20100801141549.GB10192@infradead.org>
Date: Mon, 02 Aug 2010 12:47:44 -0500
Message-ID: <1280771264.2236.61.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2010-08-01 at 10:15 -0400, Christoph Hellwig wrote:
> On Fri, Jul 30, 2010 at 04:54:23PM -0500, Alex Elder wrote:
> > This patch arranges for calls to getfacl(1) to be given the "-n"
> > flag, which requests that user and group id's be listed numerically
> > rather than using names.  The affected test output files are also
> > updated to indicate the effect of the change.
> > 
> > This eliminates some spurious output differences I was seeing, due
> > to the presence of NIS in my test environment.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> Looks good,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I wonder if this usage should be documented somewhere for future tests.
> 

Same goes for the use of _cat_passwd and _cat_group.
I'll add something to the "README" file in the "Test
script environment" section and will post that shortly.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
