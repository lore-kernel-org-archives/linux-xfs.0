Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 648127F50
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 10:49:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6592AC003
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 08:49:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6TFHBJaiTFY2AqZd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 08:49:10 -0700 (PDT)
Date: Thu, 25 Jul 2013 11:49:15 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v6 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
Message-ID: <20130725114915.6cda13c6@oracle.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>

Hi All,

This updated patchset is on top of ad81f054 of xfs git (3.11-rc1). The
patches do not convert the id's returned from bulkstat, since bulkstat
cannot be called from inside a userns right now anyway since the caller
must be CAP_SYS_ADMIN in init_user_ns.

Changes since v5 patchset (addressing Brian's comments,
only 0005 and 0006 are changed):
 - 0005 put all eofblocks validation in xfs_fs_eofblocks_from_user()
 - 0006 don't export internal flag, add K to internal flag name,
   start internal flags bits at msb (with the intention that other internal
   flags would be in descending order) and ensure that it doesn't accidentally
   collide with external flags

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
