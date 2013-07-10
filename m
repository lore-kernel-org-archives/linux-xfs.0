Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6A357F56
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 04:06:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3049BAC005
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 02:06:38 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id wfxmNUxasWFAcvqU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 02:06:36 -0700 (PDT)
Date: Wed, 10 Jul 2013 11:06:34 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Corruption of root fs during git bisect of drm system hang
Message-ID: <20130710090634.GA356@x4>
MIME-Version: 1.0
Content-Disposition: inline
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

While bisecting a system hang, caused by the drm gpu subsystem, my root fs got
corrupted:

 # xfs_repair /dev/sdc2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 6 is 682886 in ag 3 (inode=101346182)
agi unlinked bucket 7 is 11335 in ag 3 (inode=100674631)
agi unlinked bucket 10 is 682890 in ag 3 (inode=101346186)
agi unlinked bucket 21 is 981 in ag 3 (inode=100664277)
agi unlinked bucket 23 is 5704343 in ag 3 (inode=106367639)
agi unlinked bucket 29 is 211421 in ag 3 (inode=100874717)
agi unlinked bucket 31 is 7681375 in ag 3 (inode=108344671)
agi unlinked bucket 34 is 3480162 in ag 3 (inode=104143458)
agi unlinked bucket 40 is 211432 in ag 3 (inode=100874728)
agi unlinked bucket 41 is 2704937 in ag 3 (inode=103368233)
agi unlinked bucket 45 is 594669 in ag 3 (inode=101257965)
agi unlinked bucket 62 is 11902 in ag 3 (inode=100675198)
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
7f560b7fe700: Badness in key lookup (length)
bp=(bno 46883808, len 16384 bytes) key=(bno 46883808, len 8192 bytes)
7f560b7fe700: Badness in key lookup (length)
bp=(bno 46888976, len 16384 bytes) key=(bno 46888976, len 8192 bytes)
7f560b7fe700: Badness in key lookup (length)
bp=(bno 46889264, len 16384 bytes) key=(bno 46889264, len 8192 bytes)
7f560b7fe700: Badness in key lookup (length)
bp=(bno 46989024, len 16384 bytes) key=(bno 46989024, len 8192 bytes)
7f560b7fe700: Badness in key lookup (length)
bp=(bno 47180640, len 16384 bytes) key=(bno 47180640, len 8192 bytes)
7f560b7fe700: Badness in key lookup (length)
bp=(bno 47224768, len 16384 bytes) key=(bno 47224768, len 8192 bytes)
7f560b7fe700: Badness in key lookup (length)
bp=(bno 48235776, len 16384 bytes) key=(bno 48235776, len 8192 bytes)
7f560b7fe700: Badness in key lookup (length)                                                                                                  
bp=(bno 48623392, len 16384 bytes) key=(bno 48623392, len 8192 bytes)                                                                         
7f560b7fe700: Badness in key lookup (length)                                                                                                  
bp=(bno 49735472, len 16384 bytes) key=(bno 49735472, len 8192 bytes)                                                                         
7f560b7fe700: Badness in key lookup (length)                                                                                                  
bp=(bno 50723984, len 16384 bytes) key=(bno 50723984, len 8192 bytes)                                                                         
        - agno = 3                                                                                                                            
        - process newly discovered inodes...                                                                                                  
Phase 4 - check for duplicate blocks...                                                                                                       
        - setting up duplicate extent list...                                                                                                 
        - check for inodes claiming duplicate blocks...                                                                                       
        - agno = 0                                                                                                                            
        - agno = 1                                                                                                                            
        - agno = 2                                                                                                                            
        - agno = 3                                                                                                                            
Phase 5 - rebuild AG headers and trees...                                                                                                     
        - reset superblock...                                                                                                                 
Phase 6 - check inode connectivity...                                                                                                         
        - resetting contents of realtime bitmap and summary inodes                                                                            
        - traversing filesystem ...                                                                                                           
        - traversal finished ...                                                                                                              
        - moving disconnected inodes to lost+found ...                                                                                        
disconnected inode 100664277, moving to lost+found                                                                                            
disconnected inode 100674631, moving to lost+found                                                                                            
disconnected inode 100675198, moving to lost+found                                                                                            
disconnected inode 100874717, moving to lost+found                                                                                            
disconnected inode 100874728, moving to lost+found                                                                                            
disconnected inode 101257965, moving to lost+found                                                                                            
disconnected inode 101346182, moving to lost+found                                                                                            
disconnected inode 101346186, moving to lost+found                                                                                            
disconnected inode 103368233, moving to lost+found                                                                                            
disconnected inode 104143458, moving to lost+found                                                                                            
disconnected inode 106367639, moving to lost+found                                                                                            
disconnected inode 108344671, moving to lost+found                                                                                            
Phase 7 - verify and correct link counts...                                                                                                   
cache_purge: shake on cache 0x12a6030 left 1 nodes!?                                                                                          
done

This happend twice in the last few days and thus appears to be reproducible.

My root fs lives on a small SSD:

/dev/root on / type xfs (rw,relatime,attr2,inode64,logbsize=256k,noquota)
/dev/root      xfs        30G   15G   16G  50% /

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
