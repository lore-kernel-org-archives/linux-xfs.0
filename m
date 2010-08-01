Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5B6bC1Z138487 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 01:37:14 -0500
Date: Sun, 1 Aug 2010 10:15:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: include NIS databases
Message-ID: <20100801141507.GA10192@infradead.org>
References: <201007302152.o6ULqdcK008761@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007302152.o6ULqdcK008761@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 04:52:39PM -0500, Alex Elder wrote:
> If NIS is active on a test target system, additional password and
> group file information is available via their respective databases
> in NIS.  Currently, some tests assume that /etc/passwd and /etc/group
> are the only places to find this information.
> 
> This patch causes both the local database and the NIS database (if
> one is likely to be present) to be consulted for needed information.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
