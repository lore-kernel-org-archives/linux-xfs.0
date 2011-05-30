Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4U5uI8k226912 for <xfs@oss.sgi.com>; Mon, 30 May 2011 00:56:20 -0500
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C3B0D56679
	for <xfs@oss.sgi.com>; Sun, 29 May 2011 22:56:12 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id wo3Zh12JSptpAUE1 for
	<xfs@oss.sgi.com>; Sun, 29 May 2011 22:56:12 -0700 (PDT)
Date: Mon, 30 May 2011 06:56:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [git pull] dentry_unhash() breakage
Message-ID: <20110530055601.GK11521@ZenIV.linux.org.uk>
References: <20110530020604.GC561@dastard> <20110530034741.GD561@dastard>
	<Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

A couple of dentry_unhash fallout fixes

Please, pull from usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Al Viro (1):
      autofs4: bogus dentry_unhash() added in ->unlink()

Sage Weil (1):
      vfs: shrink_dcache_parent before rmdir, dir rename

 fs/autofs4/root.c |    2 --
 fs/namei.c        |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
