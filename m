Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1AF629DFC
	for <xfs@oss.sgi.com>; Sat, 16 Jan 2016 15:22:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CFBB9304059
	for <xfs@oss.sgi.com>; Sat, 16 Jan 2016 13:22:54 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id puWzy3xlFXWhCtFi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Jan 2016 13:22:53 -0800 (PST)
Date: Sat, 16 Jan 2016 16:22:51 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] xfs: introduce per-inode DAX enablement
Message-ID: <20160116212251.GC26427@thunk.org>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1451886892-15548-4-git-send-email-david@fromorbit.com>
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

On Mon, Jan 04, 2016 at 04:54:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than just being able to turn DAX on and off via a mount
> option, some applications may only want to enable DAX for certain
> performance critical files in a filesystem.
> 
> This patch introduces a new inode flag to enable DAX in the v3 inode
> di_flags2 field. It adds support for setting and clearing flags in
> the di_flags2 field via the XFS_IOC_FSSETXATTR ioctl, and sets the
> S_DAX inode flag appropriately when it is seen.
> 
> When this flag is set on a directory, it acts as an "inherit flag".
> That is, inodes created in the directory will automatically inherit
> the on-disk inode DAX flag, enabling administrators to set up
> directory heirarchies that automatically use DAX. Setting this flag
> on an empty root directory will make the entire filesystem use DAX
> by default.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
