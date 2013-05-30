Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 817347F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 12:56:03 -0500 (CDT)
Date: Thu, 30 May 2013 12:56:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 6/9] xfs: disable swap extents ioctl on CRC enabled
	filesystems
Message-ID: <20130530175600.GE20932@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-7-git-send-email-david@fromorbit.com>
	<51A66DC0.10405@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A66DC0.10405@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, May 29, 2013 at 05:06:08PM -0400, Brian Foster wrote:
> On 05/27/2013 02:38 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently, swapping extents from one inode to another is a simple
> > act of switching data and attribute forks from one inode to another.
> > This, unfortunately in no longer so simple with CRC enabled
> > filesystems as there is owner information embedded into the BMBT
> > blocks that are swapped between inodes. Hence swapping the forks
> > between inodes results in the inodes having mapping blocks that
> > point to the wrong owner and hence are considered corrupt.
> > 
> > To fix this we need an extent tree block or record based swap
> > algorithm so that the BMBT block owner information can be updated
> > atomically in the swap transaction. This is a significant piece of
> > new work, so for the moment simply don't allow swap extent
> > operations to succeed on CRC enabled filesystems.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Pretty straightforward...
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
