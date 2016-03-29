Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3A327CA7
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:34:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE7798F8035
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 10:34:23 -0700 (PDT)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[81.169.146.160]) by cuda.sgi.com with ESMTP id
	uxrOQQVhKG7CBdy5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 10:34:21 -0700 (PDT)
Received: from probook (aftr-185-17-206-254.dynamic.mnet-online.de
	[185.17.206.254]) by smtp.strato.de (RZmta 37.22 DYNA|AUTH)
	with ESMTPSA id 602a6as2THYJtXP
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1
	with 521 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate) for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2016 19:34:19 +0200 (CEST)
Date: Tue, 29 Mar 2016 19:34:19 +0200
From: Olaf Hering <olaf@aepfle.de>
Subject: Re: BUG in xfs_trans_binval
Message-ID: <20160329173419.GA18970@aepfle.de>
References: <20160329171553.GA17885@aepfle.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160329171553.GA17885@aepfle.de>
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

On Tue, Mar 29, Olaf Hering wrote:

> "_xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000"


root@optiplex:~ # env -i /sbin/xfs_repair -n /dev/disk/by-label/WD15_optiplx
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 0 is 40829376 in ag 1 (inode=577700288)
sb_icount 3932864, counted 4365696
sb_ifree 3488, counted 96
sb_fdblocks 55910963, counted 53073251
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
entry contains illegal value in attribute named SGI_ACL_FILE or SGI_ACL_DEFAULT
bad security value for attribute entry 0 in attr block 0, inode 1710299980
problem with attribute contents in inode 1710299980
would clear attr fork
bad nblocks 2 for inode 1710299980, would reset to 1
bad anextents 1 for inode 1710299980, would reset to 0
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 577700288, would move to lost+found
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

Olaf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
