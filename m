Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55MOOBx066788 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 17:24:24 -0500
Received: from mail.sigil.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3D07122A63A
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 15:24:40 -0700 (PDT)
Received: from mail.sigil.org (tx1-250.intrameta.com [69.13.51.250]) by
	cuda.sgi.com with ESMTP id 3EmCdUAOF3zOIpAc for
	<xfs@oss.sgi.com>; Fri, 05 Jun 2009 15:24:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.sigil.org (Postfix) with ESMTP id 3C67BB249
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 15:46:49 -0500 (CDT)
Received: from mail.sigil.org ([127.0.0.1])
	by localhost (mail.sigil.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id LB2lBfHeeqXv for <xfs@oss.sgi.com>;
	Fri,  5 Jun 2009 15:46:46 -0500 (CDT)
Received: from magus.portal.sigil.org (ip72-202-157-83.ks.ks.cox.net
	[72.202.157.83])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sigil.org (Postfix) with ESMTPSA id 9A833B256
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 15:46:45 -0500 (CDT)
Date: Fri, 5 Jun 2009 17:22:37 -0500
From: Richard Kolkovich <richard@intrameta.com>
Subject: Segmentation fault during xfs_repair
Message-ID: <20090605222236.GA39825@magus.portal.sigil.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We have a corrupted XFS partition on a storage server.  Attempting to run xfs_repair the first time yielded the message about a corrupt log file, so I have run xfs_repair with -L to clear that.  Now, xfs_repair segfaults in Phase 3.  I have tried -P and a huge -m to no avail.  It always seems to segfault at the same point:

bad directory block magic # 0 in block 11 for directory inode 341521797
corrupt block 11 in directory inode 341521797
        will junk block
Segmentation fault (core dumped)

Here is the backtrace:

(gdb) bt
#0  traverse_int_dir2block (mp=0x7fff4243c1d0, da_cursor=0x7fff4243bca0, rbno=0x7fff4243bd98)
    at dir2.c:358
#1  0x000000000041650e in process_node_dir2 () at dir2.c:1940
#2  process_leaf_node_dir2 (mp=0x7fff4243c1d0, ino=341521797, dip=0x27131600, ino_discovery=1, 
    dirname=0x46bdcd "", parent=0x7fff4243c080, blkmap=0x7f8828b5c060, dot=0x7fff4243be6c, 
    dotdot=0x7fff4243be68, repair=0x7fff4243be64, isnode=1) at dir2.c:2033
#3  0x00000000004182cc in process_dir2 (mp=0x7fff4243c1d0, ino=341521797, dip=0x27131600, 
    ino_discovery=1, dino_dirty=0x7fff4243c090, dirname=0x46bdcd "", parent=0x7fff4243c080, 
    blkmap=0x7f8828b5c060) at dir2.c:2086
#4  0x000000000040f9dc in process_dinode_int (mp=0x7fff4243c1d0, dino=0x27131600, agno=5, 
    ino=5977477, was_free=0, dirty=0x7fff4243c090, used=0x7fff4243c094, verify_mode=0, 
    uncertain=0, ino_discovery=1, check_dups=0, extra_attr_check=1, isa_dir=0x7fff4243c08c, 
    parent=0x7fff4243c080) at dinode.c:2668
#5  0x000000000040fbae in process_dinode (mp=0x7fff4254c438, dino=0x7fff4254c418, agno=939524166, 
    ino=5888, was_free=46501, dirty=0x3, used=0x7fff4243c094, ino_discovery=1, check_dups=0, 
    extra_attr_check=1, isa_dir=0x7fff4243c08c, parent=0x7fff4243c080) at dinode.c:2779
#6  0x00000000004088f6 in process_inode_chunk (mp=0x7fff4243c1d0, agno=5, 
    num_inos=<value optimized out>, first_irec=0x2198f60, ino_discovery=1, check_dups=0, 
    extra_attr_check=1, bogus=0x7fff4243c114) at dino_chunks.c:778
#7  0x0000000000408edd in process_aginodes (mp=0x7fff4243c1d0, pf_args=0x7f88284d97b0, agno=5, 
    ino_discovery=1, check_dups=0, extra_attr_check=1) at dino_chunks.c:1024
#8  0x000000000041bfdf in process_ag_func (wq=0x2003730, agno=5, arg=0x7f88284d97b0)
    at phase3.c:161
#9  0x000000000041c79b in process_ags () at phase3.c:200
#10 phase3 (mp=0x7fff4243c1d0) at phase3.c:239
#11 0x0000000000432435 in main (argc=<value optimized out>, argv=<value optimized out>)
    at xfs_repair.c:719

I can provide the full core file, if need be (956M).  The xfs_metadump can be found at:

http://files.intrameta.com/metadump.gz (735M)

Any suggestions/ideas on how to proceed are welcome.  Please Reply-All, as I'm not subscribed to the ML.

Thanks,

-- 

Richard Kolkovich
IntraMeta Corporation
richard@intrameta.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
