Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEC377CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 01:20:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51400AC002
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 23:20:56 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pBWVzAZOpMVrR6g8 for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 23:20:53 -0700 (PDT)
Date: Wed, 20 Jul 2016 16:20:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: implement 'copy_range' command
Message-ID: <20160720062051.GK16044@dastard>
References: <20160701194520.28088-1-Anna.Schumaker@Netapp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160701194520.28088-1-Anna.Schumaker@Netapp.com>
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
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2016 at 03:45:20PM -0400, Anna Schumaker wrote:
> Implements a new xfs_io command, named 'copy_range', which is supposed
> to be used to copy a range of data from one file to another.
> 
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

Hi Anna, I've just pulled this in, and I noticed that it's missing a
man page update. Can you send a patch for man/man8/xfs_io.8 that
documents the copy_range command?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
