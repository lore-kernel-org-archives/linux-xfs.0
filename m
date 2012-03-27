Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RExJda097411 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:59:20 -0500
Date: Tue, 27 Mar 2012 10:59:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] repair: fix the variable-width nlink array
Message-ID: <20120327145917.GA31635@infradead.org>
References: <20120228174223.GA6148@infradead.org>
	<20120301212822.GM7762@sgi.com>
	<20120302074433.GA4117@infradead.org>
	<20120326174914.GR8451@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120326174914.GR8451@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Mar 26, 2012 at 12:49:14PM -0500, Ben Myers wrote:
> Hey Christoph,
> 
> On Fri, Mar 02, 2012 at 02:44:33AM -0500, Christoph Hellwig wrote:
> > On Thu, Mar 01, 2012 at 03:28:22PM -0600, Ben Myers wrote:
> > > On my machine test 030 has regressed.  It passed on 3.1.7.
> > 
> > That's an older change.  I have a fix in my local tree, but it needs
> > polishing so that it still works with older repair versions.
> 
> Have you had a chance to work on your fix for 030?

Sorry, I still haven't managed to get back to speed on xfstests,
we are still missing tons of external commits, and various testcases
seem to fail right now.  I'll get back to it this weekend hopefully.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
