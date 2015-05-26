Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7373E7F47
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 17:51:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4514E8F8084
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 15:51:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UBtBEEGG5JhEQesr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 15:51:30 -0700 (PDT)
Subject: [PATCH 0/5] xfsprogs May 2015 patchbomb
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 May 2015 15:51:26 -0700
Message-ID: <20150526225126.26434.69010.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Hi all,

This is a rollup of various fixes for xfsprogs 3.2.3-rc1.

The first patch makes repair stop when it encounters v5 feature bits
which it doesn't understand.  Without it, an old xfs_repair will
trash a filesystem it doesn't know how to fix.

The second patch adds to repair some missing metadata back pointer
checks.

Patch 3 ensures that the .. link in a dir being rebuilt points
to a sane inode number.

Patch 4 implements blockget for v5 filesystems.  This is a second try
at a previous patch which didn't quite catch all the new magic numbers
and had some problems iterating directory index data.

Patch 5 fixes up blocktrash to avoid verifier errors when writing
deliberately corrupted blocks to disk.  It also adds the xfsfuzz.sh
script which will create and populate an XFS image, corrupts it,
then tries to modify/repair/re-modify the image.  I'm not sure this
is appropriate for xfstests, since runs until the kernel crashes or
repair fails to repair or the user ^Cs it.

I've tested these xfsprogs changes against the -next branch as of
5/11.

Comments and questions are, as always, welcome.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
