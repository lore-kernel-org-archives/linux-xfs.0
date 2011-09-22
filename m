Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MLEnLF259923 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 16:14:49 -0500
Subject: Re: [PATCH] xfstests: Assume yes when test device is not partitioned
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
References: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
Date: Thu, 22 Sep 2011 16:14:44 -0500
Message-ID: <1316726084.2009.85.camel@doink>
MIME-Version: 1.0
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
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: linux-ext4@vger.kernel.org, Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>, xfs@oss.sgi.com

On Sat, 2011-09-03 at 14:03 +0530, Prasad Joshi wrote:
> If an entire device used for file system creation, the mkfs.ext2/3/4
> asks for confirmation before proceeding. Since the device is
> configured for testing it is safe to assume positive response
> during mkfs.
> 
> The patch also replaces hard coded mkfs path with MKFS_PROG variable.
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>
> Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>

Thanks for submitting a patch, Prasad (and Chaitanya).

Can you please re-submit this?  Based on feedback what
we're looking for would be:
[PATCH 0/2] description e-mail
[PATCH 1/2] patch that substitutes /sbin/mkfs with ${MKFS_PROG}
[PATCH 2/2] patch that adds a '-f' flag to ${MKFS_PROG}.${FSTYP}
            for all ext* filesystem types.

Thanks.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
