Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E53937F5A
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 23:52:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF4BB304064
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 21:52:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id s5tjqvbjdEy8fUNQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 21:52:14 -0700 (PDT)
Date: Wed, 24 Jul 2013 00:52:22 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v5 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
Message-ID: <20130724005222.2c687428@oracle.com>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>

Hi All,

This updated patchset is on top of ad81f054 of xfs git (3.11-rc1). The
patches do not convert the id's returned from bulkstat, since bulkstat
cannot be called from inside a userns right now anyway since the caller
must be CAP_SYS_ADMIN in init_user_ns.

Changes since v4 patchset (addressing Dave's comments):
 - add parenthesis in if with binary and logical and (EOFBLOCKS flags)
 - rename xfs_fs_eofblocks_to_internal -> xfs_fs_eofblocks_from_user and
   move conversion validation into it
 - fix negative error returns from XFS_IOC_FREE_EOFBLOCKS
 - add check for read-only filesystem to XFS_IOC_FREE_EOFBLOCKS

Changes since v3 patchset:
 - export inode_capable() for building xfs as a module
 - implement Brian's proposal for an internal flag to indicate to
   xfs_inode_free_eofblocks() that it should do a permission check.
   ioctl callers will always set this flag, which is simpler than
   making them specify XFS_EOF_FLAGS_UID or XFS_EOF_FLAGS_GID,
   internal callers can leave it unset so no permission checking is
   done
 - take Brian's suggestion on moving the policy from the conversion
   function into the ioctl code, and moving stuff to xfs_icache.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
