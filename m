Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD2487F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 12:57:40 -0500 (CDT)
Date: Thu, 30 May 2013 12:57:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 8/9] xfs: add fsgeom flag for v5 superblock support.
Message-ID: <20130530175740.GF20932@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-9-git-send-email-david@fromorbit.com>
	<51A75F83.90500@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A75F83.90500@redhat.com>
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

On Thu, May 30, 2013 at 10:17:39AM -0400, Brian Foster wrote:
> On 05/27/2013 02:38 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently userspace has no way of determining that a filesystem is
> > CRC enabled. Add a flag to the XFS_IOC_FSGEOMETRY ioctl output to
> > indicate that the filesystem has v5 superblock support enabled.
> > This will allow xfs_info to correctly report the state of the
> > filesystem.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
