Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Nov 2008 21:38:39 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA65cOGF011842
	for <xfs@oss.sgi.com>; Wed, 5 Nov 2008 21:38:26 -0800
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B41D1502666
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2008 21:38:26 -0800 (PST)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by cuda.sgi.com with ESMTP id Fqs5EeBslJXsBtsN for <xfs@oss.sgi.com>; Wed, 05 Nov 2008 21:38:26 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1KxxZZ-0007Si-GX
	for xfs@oss.sgi.com; Wed, 05 Nov 2008 21:38:25 -0800
Message-ID: <20355466.post@talk.nabble.com>
Date: Wed, 5 Nov 2008 21:38:25 -0800 (PST)
From: cyjoyp <cyjoyp@gmail.com>
Subject: Inode Core, di_format = 3 , with sb_inodesize=1024
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hello folks,
    Referring to the document "XFS File System Structure" by Silicon
Graphics ,page number 34 ....
    "* On disk, the B+tree node starts with the xfs_bmbr_block_t header
followed by an array of 
        xfs_bmbt_key_t  values and then an array of xfs_bmbt_ptr_t
values.The size of 
        both arrays is specified by the header's bb_numrecs value ."
   "* The root node in the inode can only contain up to 19 key/pointer pairs
for a standard 256 byte inode 
       before a new level of nodes is added between the root and the
leaves."

My query is,
      
       I do not see the header  xfs_bmbr_block_t anywhere else in the
documentation.Is it a 
       spelling a mistake? As far as I understand, bb_numrecs represents the
number of pointers present in 
       the Inode core and not the size of the key/pointer arrays.This
pointer value helps us reach the 
       block of extents having the signature BMAP. Please correct me if I am
wrong.

       If there are up to 19 key/pointer pairs for a standard 256 byte
Inode, do any one know how 
       may key/pointer pair does a Inode core of size 512 and 1024 will
have????
       Is there any way to calculate the offset of the pointer ??

  Pleas help me
       

      



-- 
View this message in context: http://www.nabble.com/Inode-Core%2C-di_format-%3D-3-%2C-with-sb_inodesize%3D1024-tp20355466p20355466.html
Sent from the Xfs - General mailing list archive at Nabble.com.
