Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFCBF29E06
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 10:47:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8113730408B
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 08:47:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wgrS7HehmHtBdMyg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jul 2013 08:47:26 -0700 (PDT)
Date: Wed, 17 Jul 2013 11:47:05 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v4 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
Message-ID: <20130717114705.60d87987@oracle.com>
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
