Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 853087F47
	for <xfs@oss.sgi.com>; Sat, 16 Jan 2016 15:22:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A2CDAC001
	for <xfs@oss.sgi.com>; Sat, 16 Jan 2016 13:22:37 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id GgO93F2ARYu7k6YL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Jan 2016 13:22:33 -0800 (PST)
Date: Sat, 16 Jan 2016 16:22:31 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] xfs: use FS_XFLAG definitions directly
Message-ID: <20160116212231.GB26427@thunk.org>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1451886892-15548-3-git-send-email-david@fromorbit.com>
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

On Mon, Jan 04, 2016 at 04:54:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the ioctls have been hoisted up to the VFS level, use
> the VFs definitions directly and remove the XFS specific definitions
> completely. Userspace is going to have to handle the change of this
> interface separately, so removing the definitions from xfs_fs.h is
> not an issue here at all.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

						- Ted
						

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
