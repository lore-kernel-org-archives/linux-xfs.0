Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 942EE7CB9
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:20:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 039DFAC008
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:20:12 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id xJMCRPraFs22McHj (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 09:20:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] fs: Avoid premature clearing of file capabilities
Date: Thu, 26 May 2016 18:19:55 +0200
Message-Id: <1464279600-13009-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Hello,

this patch series is my attempt to fix an issue when user can clear capabilites
of arbitrary file he can look up for example by running chown on it (this got
assigned CVE-2015-1350). The problem is that we call security_inode_killpriv()
before checking permissions in inode_change_ok(). This patch set moves
that call into inode_change_ok() after permissions are checked - the only
trouble is that we need to give dentry instead of inode there and that is
not completely trivial in some cases - I'd like to have a review from XFS,
Ceph, and FUSE people to verify I didn't miss anything. Anyway, have a look
how the result looks like...

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
