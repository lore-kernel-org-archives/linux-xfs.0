Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F19207F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 05:23:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8E238F8039
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:23:24 -0700 (PDT)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id iOPjiYjYGRs8Ob6Y (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 03:23:21 -0700 (PDT)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N5900KGI3IVIE30@mailout3.samsung.com> for
	xfs@oss.sgi.com; Thu, 08 May 2014 19:23:19 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Thu, 08 May 2014 19:23:19 +0900
Message-id: <003601cf6aa7$883103b0$98930b10$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

In continuation of the work of making the process of non linear editing of
media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
for fallocate.

This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
in between the file within the range specified by offset and len. User can
write new data in this space. e.g. ads.
Like collapse range, currently we have the limitation that offset and len should
be block size aligned for both XFS and Ext4.

The semantics of the flag are :
1) It allocates new zeroed out on disk space of len bytes starting
   at offset byte without overwriting any existing data. All the data blocks
   from offset to EOF are shifted towards right to make space for inserting
   new blocks
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Insert range does not work for the case when offset is overlapping/beyond
   i_size. If the user wants to allocate space at the end of file they are
   advised to use either ftruncate(2) or fallocate(2) with mode 0.
5) It increses the size of file by len bytes.


Namjae Jeon (10):
 fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfsprogs: xfs_io: add finsert command for insert range via fallocate
 xfstests: generic/027: Standard insert range tests
 xfstests: generic/028: Delayed allocation insert range
 xfstests: generic/029: Multi insert range tests
 xfstests: generic/030: Delayed allocation multi insert
 xfstests: fsstress: Add fallocate insert range operation
 xfstests: fsx: Add fallocate insert range operation

-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
