Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4AK4aA2057357 for <xfs@oss.sgi.com>; Thu, 10 May 2012 15:04:36 -0500
Date: Thu, 10 May 2012 15:08:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support v9
Message-ID: <20120510200832.GP16881@sgi.com>
References: <4FABC2AD.2030609@oracle.com>
 <4FAC1C33.5050508@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FAC1C33.5050508@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: jeff.liu@oracle.com, xfs@oss.sgi.com

On Thu, May 10, 2012 at 02:51:15PM -0500, Mark Tinguely wrote:
> On 05/10/12 08:29, Jeff Liu wrote:
> >Hello,
> >
> >This is the revised patch according to Mark's comments.
> >Is it possible to get it to accept if there are no other issues,
> >so that I can continue to work on the unwritten part based on that.
> >
> >Thanks,
> >-Jeff
> >
> >Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> >
> >---
> 
> >+
> >+STATIC loff_t
> >+xfs_seek_hole(
> >+	struct file		*file,
> >+	loff_t			start,
> >+	u32			type)
> >+{
> >+	struct inode		*inode = file->f_mapping->host;
> >+	struct xfs_inode	*ip = XFS_I(inode);
> >+	struct xfs_mount	*mp = ip->i_mount;
> >+	loff_t			uninitialized_var(offset);
> >+	loff_t			holeoff;
> >+	xfs_fsize_t		isize;
> >+	xfs_fileoff_t		fsbno;
> >+	uint			lock;
> >+	int			error;
> >+
> >+	if (XFS_FORCED_SHUTDOWN(mp))
> >+		return -XFS_ERROR(EIO);
> 
> I think xfs_bmapi_read() returns just a XFS_ERROR(EIO), not negative.
> Ben can fix up if you agree.

Looks like error is negated at the bottom of the function and is not a problem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
