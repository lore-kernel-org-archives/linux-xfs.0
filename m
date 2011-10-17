Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HMdnPk027263 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:39:49 -0500
Message-ID: <1318891184.17387.5.camel@doink>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
From: Alex Elder <aelder@sgi.com>
Date: Mon, 17 Oct 2011 17:39:44 -0500
In-Reply-To: <1318885528-7650-1-git-send-email-cmaiolino@redhat.com>
References: <1318885528-7650-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-10-17 at 19:05 -0200, Carlos Maiolino wrote:
> Fixes a possible memory corruption when the link is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> S_ISLNK assert, since the inode mode is checked previously in
> xfs_readlink_by_handle() and via VFS.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

I know this was discussed to death on IRC.  But I didn't
get a chance to be a part of that committee so I have
a suggested change:  use %llu format, not %lld.

Just to clarify, this is addressing something that could
happen if a corrupt filesystem led to an inode whose flags
indicate it's a symlink has a size that exceeds the maximum
path length.  And without your fix, the memcpy() in
xfs_readlink() could overflow the memory it's provided.

I can implement the format string fix before I commit your
change.  But I'll wait for your permission before doing so.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
