Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHLFqfx014283 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 15:15:53 -0600
Date: Wed, 17 Dec 2008 13:15:50 -0800
From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [xfs-masters] [PATCH][RFC] fs: Add new pre-allocation ioctls to
	vfs for compatibility with legacy xfs ioctls
Message-ID: <20081217211550.GF8791@wotan.suse.de>
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
	<494969C6.4090500@sandeen.net>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <494969C6.4090500@sandeen.net>
Reply-To: Mark Fasheh <mfasheh@suse.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Wed, Dec 17, 2008 at 03:06:14PM -0600, Eric Sandeen wrote:
> >> There are some things that I'm not sure about:
> >> 1. Should the struct space_resv be exposed to user-space? If not,
> >> then what would be the right place to put it? And the ioctl
> >> definitions?
> > 
> > Yes. As far as where to put it, I'm not sure. Maybe falloc.h?
> 
> I'd sort of rather not; why should that legacy struct space_resv be
> available in a header... I thought this was for people already using the
> xfs ioctl, in which case they are already using the xfs header... and if
> they want preallocation in any new work, they should use fallocate()
> instead, yes?

Actually, yeah agreed - I take that back. Old users are already getting them
from file system headers, new ones should use fallocate. So there's no need
to expose the ioctls to userspace, at least not if all we're talking about
is the RESVP ioctls.
	--Mark

--
Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
