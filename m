Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 931B67F3F
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 16:17:48 -0500 (CDT)
Date: Thu, 20 Jun 2013 16:17:47 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 39/48] mkfs.xfs: validate options for CRCs up front.
Message-ID: <20130620211747.GB7800@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-40-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-40-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:26:02AM +1000, Dave Chinner wrote:
| From: Dave Chinner <dchinner@redhat.com>
| 
| With CRC enabled filesystems, certain options are now not optional
| and so are always enabled. Validate these options up front and
| abort if options are specified that cannot be set.
| 
| Signed-off-by: Dave Chinner <dchinner@redhat.com>
| ---
|  mkfs/xfs_mkfs.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
|  1 file changed, 56 insertions(+), 5 deletions(-)
| 
| diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
| index 291bab4..9987dde 100644
| --- a/mkfs/xfs_mkfs.c
| +++ b/mkfs/xfs_mkfs.c
...
| @@ -1754,6 +1754,57 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
|  		logversion = 2;
|  	}
|  
| +	/*
| +	 * Now we have blocks and sector sizes set up, check parameters that are
| +	 * no longer optional for CRC enabled filesystems.  Catch them up front
| +	 * here before doing anything else.
| +	 */
| +	if (crcs_enabled) {
| +		/* minimum inode size is 512 bytes, ipflag checked later */
| +		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
| +			fprintf(stderr,
| +_("Minimum inode size for CRCs is %d bytes\n"),
| +				1 << XFS_DINODE_DFL_CRC_LOG);
| +			usage();
| +		}

I am not satisfied with the explanation for not allowing 256 byte inodes
with CRCs, and I am requesting that this limitation not be implemented.
I have no issue with making the default inode size 512 bytes, but
removing the option for 256 byte inodes is an issue, especially with the
initial implementation.  Making the minimum inode size 256 is fine.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
