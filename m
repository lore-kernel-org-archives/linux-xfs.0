Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7226E7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 14:58:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58DEF304051
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 12:58:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UOoOhX5MmV5tGhrg for
	<xfs@oss.sgi.com>; Mon, 15 Jul 2013 12:58:11 -0700 (PDT)
Date: Mon, 15 Jul 2013 15:58:00 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
	fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130715195800.GD1706@redhat.com>
References: <20130712023930.GA6473@redhat.com> <20130713020030.GG3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130713020030.GG3438@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Jul 13, 2013 at 12:00:30PM +1000, Dave Chinner wrote:
 
 > > [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
 > ....
 > 
 > So, it's not clear what has caused this yet. Is it reproducable?

Just hit it again on the same machine.

 > would be good to get a trace of lookup vs addname events from XFS,
 > too (i.e. all the xfs_dir* and xfs_da* events) so we can see if the
 > correct lookups were done prior to the failing addname operation...
 
<- xfs tracing noob. Got a recipe I can cut-n-paste ?
Or a patch if that's necessary..

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
