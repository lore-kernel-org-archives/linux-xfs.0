Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69A5C7F67
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2015 08:38:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58528304039
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2015 06:38:48 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id PA6Kvay7ltHRydDi
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 15 Feb 2015 06:38:47 -0800 (PST)
Received: by mail-pa0-f43.google.com with SMTP id fa1so29504968pad.2
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2015 06:38:46 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Feb 2015 20:08:46 +0530
Message-ID: <CALJmpHP+PwdV1n8VLusxqz0Wb=1PLL52frEMBn8+4h0v5+7Ssg@mail.gmail.com>
Subject: [RFD] : Allowing xfs_fsr to defragment portions of a file
From: Dhruvesh Rathore <adrscube@gmail.com>
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
To: xfs@oss.sgi.com

Hi,

The xfs_fsr utility in its current state does not support defragmentation of
parts of file. Either the entire file is defragmented, or if free space is not
available then the operation is not performed.
We would like to enhance the utility allowing it to defragment parts
of the file, ins such a condition.
---------------------------------------------------------------------------------------------------------------

Our initial task was to understand how xfs_fsr currently defragments the file:

1) In /fsr/xfs_fsr.c from main() the control is passed to fsrfile().
In fsrfile(), we
open the original file and collect bstat information. A call is then made to
fsrfile_common()

2) In fsrfile_common() we check if sufficient free space is available to
defragment the file, and if not then we exit. If free space is available, then a
call is made to packfile()

3) In packfile(), read_fd_bmap() function provides us with the current number of
extents used by the file (cur_nextents) and the ideal number of extents needed
to save the file (nextents). In function read_fd_bmap() the the
outmap[ ] structure
is also populated.

4) packfile() will initially allocate new extents (nextents) to the
temporary file and
then copy(swap) extents form the existing file. We then fchown() the new temp
file and space occupied by the prev fragmented copy is then freed.

---------------------------------------------------------------------------------------------------------------

Our understanding to the approach of defragmenting portions of a file
is as follows:

1) In fsrfile_common(), a new function will be called when the code
determines that
there is insufficient free space to defragment the entire file.

2) The new function performs the following tasks:

---> Call read_fd_bmap() to get cur_nextents and nextents(ideal). Using
nextents we will
then have to determine how many extents can be defragmented against
the free space
available.

---> Creating a temp file will not be feasible as it will create a
problem when we want to
change owners.

---> The function will have to hence focus on swapping the existing
extents from the
fragmented file. For this a swap_extent() function will be needed,
which will take arguments
as the current extent and the location(in free space) where it needs
to be swapped to.

For the above functionality Dave suggested that we have a look at
EXT4_IOC_MOVE_EXT
and its usage.

We are however unsure of how to compress the extents which have been chosen for
defragmentation and keep the other extents untouched. We are also in
doubt about how to
proceed without creating a temp file for defragmentation.


Any thoughts, comments, opinions etc, are welcome
Thank you.

Regards
A-DRS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
