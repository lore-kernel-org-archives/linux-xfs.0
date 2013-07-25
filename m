Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D619F7F59
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 16:48:46 -0500 (CDT)
Date: Thu, 25 Jul 2013 16:48:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 20/48] xfs: add CRC checks to the superblock
Message-ID: <20130725214842.GH3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-21-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-21-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:43AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the addition of CRCs, there is such a wide and varied change to
> the on disk format that it makes sense to bump the superblock
> version number rather than try to use feature bits for all the new
> functionality.
> 
> This commit introduces all the new superblock fields needed for all
> the new functionality: feature masks similar to ext4, separate
> project quota inodes, a LSN field for recovery and the CRC field.
> 
> This commit does not bump the superblock version number, however.
> That will be done as a separate commit at the end of the series
> after all the new functionality is present so we switch it all on in
> one commit. This means that we can slowly introduce the changes
> without them being active and hence maintain bisectability of the
> tree.
> 
> This patch is based on a patch originally written by myself back
> from SGI days, which was subsequently modified by Christoph Hellwig.
> There is relatively little of that patch remaining, but the history
> of the patch still should be acknowledged here.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

corresponds to commit 04a1e6c5b222b

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
