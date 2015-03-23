Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1523029DFB
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 22:49:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00A9E304039
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 20:49:35 -0700 (PDT)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id jCB9sRiiAuTEpUmb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 22 Mar 2015 20:49:34 -0700 (PDT)
Received: by qgf74 with SMTP id 74so10761069qgf.2
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 20:49:34 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 22 Mar 2015 23:49:34 -0400
Message-ID: <CADa969g-jGyYc1ts+JamuD0Ze-Mcp+X8am7rAfDeY0wXC4A6gg@mail.gmail.com>
Subject: Question about GFP_KERNEL argument in radix_tree_preload
From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
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
To: david@fromorbit.com
Cc: taesoo@gatech.edu, "Kashyap, Sanidhya" <sanidhya@gatech.edu>, xfs@oss.sgi.com, csong@gatech.edu, blee@gatech.edu, changwoo@gatech.edu

Hello David,

We have been doing some analysis on file systems and have a question
regarding the GFP_KERNEL flag used in radix_tree_preload in
xfs_mru_cache_insert.

We think that this should be GFP_NOFS as it is related to the block
allocation and other file systems(eg btrfs,ext2) are also using
GFP_NOFS for the same.

It would be great if you can let us know your reason for using that
flag and which one is the correct option?

Thanks,
Sanidhya

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
