Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBI9p3gK012458 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 03:51:03 -0600
Received: from qb-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A0A4AC38AB
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 01:51:02 -0800 (PST)
Received: from qb-out-1314.google.com (qb-out-1314.google.com [72.14.204.171])
	by cuda.sgi.com with ESMTP id Q8ezpG1KkyObfEYJ for
	<xfs@oss.sgi.com>; Thu, 18 Dec 2008 01:51:02 -0800 (PST)
Received: by qb-out-1314.google.com with SMTP id e19so187057qba.8
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 01:51:01 -0800 (PST)
Message-ID: <494A1CE5.8020007@ankitjain.org>
Date: Thu, 18 Dec 2008 15:20:29 +0530
From: Ankit Jain <me@ankitjain.org>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH][RFC] fs: Add new pre-allocation ioctls
	to vfs for compatibility with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
	<494969C6.4090500@sandeen.net>
	<20081217211550.GF8791@wotan.suse.de>
In-Reply-To: <20081217211550.GF8791@wotan.suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mark Fasheh <mfasheh@suse.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Wed, Dec 17, 2008 at 03:06:14PM -0600, Eric Sandeen wrote:
> 
> Actually, yeah agreed - I take that back. Old users are already getting them
> from file system headers, new ones should use fallocate. So there's no need
> to expose the ioctls to userspace, at least not if all we're talking about
> is the RESVP ioctls.

Makes sense. So I can just keep them in falloc.h in a #ifdef __KERNEL__ ? Or
should this be in a new ioctl.h ?

-Ankit

> 	--Mark
> 
> --
> Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
