Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6718929DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 17:03:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4711E8F8054
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:03:04 -0700 (PDT)
Received: from chaos.caltech.edu (chaos.caltech.edu [131.215.34.119]) by
	cuda.sgi.com with ESMTP id GeCfvKZEcy0TT04h (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 15:02:59 -0700 (PDT)
Received: from [50.1.221.254] (helo=myrada.localnet)
	by chaos.caltech.edu with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80) (envelope-from <diane@caltech.edu>) id 1XWYAl-0005CP-3e
	for xfs@oss.sgi.com; Tue, 23 Sep 2014 15:02:59 -0700
From: Diane Trout <diane@caltech.edu>
Subject: Corrupted file system
Date: Tue, 23 Sep 2014 15:02:57 -0700
Message-ID: <5839367.DyqsVHbRuQ@myrada>
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
To: xfs@oss.sgi.com

Hi,

I had a raid failure at work that ended up corrupting an xfs filesystem the 
tail of the xfs_repair command looks like the below. I was able to generate a 
metadata dump but is there a point to making it available? 

It does crash repeatedly at the same place

(I'm not subscribed to the list, so could you reply directly as well?)

disconnected inode 15276, moving to lost+found
disconnected inode 15277, moving to lost+found
disconnected inode 15278, moving to lost+found
disconnected inode 15279, moving to lost+found
disconnected inode 15280, moving to lost+found
disconnected inode 15281, moving to lost+found
disconnected inode 15282, moving to lost+found
disconnected inode 15283, moving to lost+found
disconnected inode 15284, moving to lost+found
disconnected inode 15286, moving to lost+found
disconnected inode 15287, moving to lost+found
disconnected inode 15288, moving to lost+found
disconnected inode 15289, moving to lost+found
disconnected inode 15290, moving to lost+found
disconnected inode 15291, moving to lost+found
disconnected inode 15292, moving to lost+found
disconnected inode 15293, moving to lost+found
disconnected inode 15294, moving to lost+found
disconnected inode 15295, moving to lost+found
disconnected inode 15360, moving to lost+found
corrupt dinode 15360, extent total = 1, nblocks = 0.  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0x7f369883e6f0)

fatal error -- 117 - couldn't iget disconnected inode


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
