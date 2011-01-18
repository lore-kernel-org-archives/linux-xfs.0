Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ICw52k129162 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 06:58:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A084271394
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:00:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oBHWfiXzue0GFN1J for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:00:23 -0800 (PST)
Date: Tue, 18 Jan 2011 08:00:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] xfs: kill xfs_fs_mount_cmn_err() macro
Message-ID: <20110118130023.GA23988@infradead.org>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294792553-8378-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 12, 2011 at 11:35:48AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xfs_fs_mount_cmn_err() hide a simple check as to whether the
> mount path should output an error or not. Remove the macro and open
> code the check.

I would be nice to just move the quite flag into the normal mount flags
and have a xfs_mount_warn that checks it based off the mp.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
