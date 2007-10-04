Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 07:27:26 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94ERKZh003653
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 07:27:22 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IdRfb-0001f6-Vb
	for xfs@oss.sgi.com; Thu, 04 Oct 2007 07:27:19 -0700
Message-ID: <13040897.post@talk.nabble.com>
Date: Thu, 4 Oct 2007 07:27:19 -0700 (PDT)
From: cyjoyp <cyjoyp@gmail.com>
Subject: Reading directory entries from BMAP
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi there,
          I am a beginner in learning XFS file system.. I have a doubt, dont
know whether is silly..If you could help me with this...Thank you..

   An extent is 128 bit in size and uses the following struct,
  
        typedef struct xfs_bmbt_irec {
                      xfs_fileoff_t              br_startoff;
                      xfs_fsblock_t            br_startblock;
                      xfs_filblks_t              br_blockcount;
                      xfs_exntst_t             br_state;
                     }
     
     I have got in to the BMAP position after traversing the BTREE..
     The BMAP has a leaf and no other siblings..
     I have the extents for directory entries stored in the BMAP..
     This is where is struck badly..
   
    Now I have a 16 byte value from which I can calculate the block count
,AG number ,etc...
             00 00 00 01 00 00 02 00 00 00 00 00 02 A0 00 02
   In this case I lan up some where else instead going to the block of
directory entries..
   This br_startoff (logical offset) is causing a difference...I am going
wrong somwhere in this case..
      
     
     Could you please tell me br_startoff does really mean???
      
   
             
     

  
        

 
             
 
-- 
View this message in context: http://www.nabble.com/Reading-directory-entries-from-BMAP-tf4569129.html#a13040897
Sent from the Xfs - General mailing list archive at Nabble.com.


[[HTML alternate version deleted]]
