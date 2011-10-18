Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IDxW3S100051 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 08:59:32 -0500
Message-ID: <1318946368.3776.7.camel@doink>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
From: Alex Elder <aelder@sgi.com>
Date: Tue, 18 Oct 2011 08:59:28 -0500
In-Reply-To: <1318911538-9174-1-git-send-email-cmaiolino@redhat.com>
References: <1318911538-9174-1-git-send-email-cmaiolino@redhat.com>
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

On Tue, 2011-10-18 at 02:18 -0200, Carlos Maiolino wrote:
> Fixes a possible memory corruption when the link is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> S_ISLNK assert, since the inode mode is checked previously in
> xfs_readlink_by_handle() and via VFS.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

OK, looks good.  I'll commit it soon.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
