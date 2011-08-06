Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76CPxKm163387 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 07:25:59 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E59A151CA8A
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 05:27:03 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id l5YDuDMB4j4YYyWp for
	<xfs@oss.sgi.com>; Sat, 06 Aug 2011 05:27:03 -0700 (PDT)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1Qpfwy-0000sK-Nl
	for xfs@oss.sgi.com; Sat, 06 Aug 2011 12:25:56 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1Qpfwy-0003Zz-I8
	for xfs@oss.sgi.com; Sat, 06 Aug 2011 12:25:56 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1Qpfwy-0005JE-HY
	for xfs@oss.sgi.com; Sat, 06 Aug 2011 14:25:56 +0200
Date: Sat, 6 Aug 2011 14:25:56 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110806122556.GB20341@schmorp.de>
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

I get frequent (for servers) lockups and crashes when using 2.6.39. I saw the
same problems using 3.0.0rc5, 5 and 6, and I think also 2.6.38. I don't see
this lockups on 2.6.30 or 2.6.26 (all the respetcive latest debian kernels).

The symtpom slightly differs - sometimes I get thousands of backtraces
before the machine locks up, usually I get only one, and either the
machine locks up completely, or only the processes using the filesystem in
question (presumably) lock - all unkillable.

The backtraces look all very similar:

   http://ue.tst.eu/85b9c9f66e36dda81be46892661c5bd0.txt

this is from a desktop system - it tends to be harder to get these from
servers.

all the backtraces crash with a null pointer dereference in xfs_iget, or
in xfs_trans_log_inode, and always for process xfs_fsr.

I haven't seen a crash without xfs_fsr.

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
