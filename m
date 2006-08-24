Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 13:12:36 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7OKCSDW003524
	for <linux-xfs@oss.sgi.com>; Thu, 24 Aug 2006 13:12:28 -0700
Subject: how to understand allocsp
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
Content-Type: text/plain
Date: Thu, 24 Aug 2006 16:11:50 -0400
Message-Id: <1156450310.2700.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi All

Play with xfs_io and feel confused about this allocsp.

Starting with a empty file.

xfs_io> bmap
/t/x: no extents

I assumed this will allocate space from 0 with 1048576 bytes. but seems
this is wrong.

xfs_io> allocsp 0 1048576
xfs_io> bmap
/t/x: no extents


Do this from a non-zero start, found file filled with 0.
xfs_io> allocsp 1048576 0
xfs_io> bmap
/t/x:
        0: [0..2047]: 2147745792..2147747839


XFS_IOC_ALLOCSP64

Alter storage space associated with a section of the ordinary file
specified. The section
~~~~no idea what this "alter" mean here.

 is specified by a variable of type xfs_flock64_t, pointed to by the
final argument. The data type xfs_flock64_t contains the following
members: l_whence is 0, 1, or 2 to indicate that the relative offset
l_start will be measured from the start of the file, the current
position, or the end of the file, respectively. l_start is the offset
from the position specified in l_whence. l_len is the size of the
section. An l_len value of zero frees up to the end of the file; in this
case, the end of file (i.e., file size) is set to the beginning of the
section freed. Any data previously written into this section is no
longer accessible. If the section specified is beyond the current end of
file, the file is grown and filled with zeroes. The l_len field is
currently ignored, and should be set to zero.

this "currently ignored" is ONLY when "section is beyond the current end
of file" or for any l_start?


Thanks!

Ming
