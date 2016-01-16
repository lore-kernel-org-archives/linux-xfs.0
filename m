Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9682D7F37
	for <xfs@oss.sgi.com>; Sat, 16 Jan 2016 15:22:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7334E304059
	for <xfs@oss.sgi.com>; Sat, 16 Jan 2016 13:22:23 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id Oj1JmSF6WhwLt4vM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Jan 2016 13:22:19 -0800 (PST)
Date: Sat, 16 Jan 2016 16:22:16 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
	promotion
Message-ID: <20160116212216.GA26427@thunk.org>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1451886892-15548-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 04:54:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Hoist the ioctl definitions for the XFS_IOC_FS[SG]SETXATTR API from
> fs/xfs/libxfs/xfs_fs.h to include/uapi/linux/fs.h so that the ioctls
> can be used by all filesystems, not just XFS. This enables
> (initially) ext4 to use the ioctl to set project IDs on inodes.
> 
> Based-on-patch-from: Li Xi <lixi@ddn.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
