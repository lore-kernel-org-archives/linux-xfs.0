Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76CHXwb163034 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 07:17:33 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F9DB12030A2
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 05:18:36 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id UbIbcUqQNaFOqV64 for
	<xfs@oss.sgi.com>; Sat, 06 Aug 2011 05:18:36 -0700 (PDT)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1Qpfom-0000pk-FH
	for xfs@oss.sgi.com; Sat, 06 Aug 2011 12:17:28 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1Qpfom-0003PC-9W
	for xfs@oss.sgi.com; Sat, 06 Aug 2011 12:17:28 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1Qpfom-0005II-90
	for xfs@oss.sgi.com; Sat, 06 Aug 2011 14:17:28 +0200
Date: Sat, 6 Aug 2011 14:17:28 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: xfs_repair 3.1.4/3.1.5: fatal error -- couldn't malloc dir2 buffer
	data
Message-ID: <20110806121728.GA20341@schmorp.de>
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

When trying to xfs_repair a 15GB image file, I get this:

Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...

fatal error -- couldn't malloc dir2 buffer data

this is 3.1.5 - 3.1.4 simply segfaults. using ltrace shows this as
last call to malloc:

   malloc(18446744073708732928)                                  = NULL

I think thats a bit unreasonable of xfs_repair :)

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
