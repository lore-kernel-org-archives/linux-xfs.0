Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5JBP0pk032627 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 06:25:01 -0500
Received: from astoria.ccjclearline.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE126165E7
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 04:24:58 -0700 (PDT)
Received: from astoria.ccjclearline.com (astoria.ccjclearline.com
	[64.235.106.9]) by cuda.sgi.com with ESMTP id p8rR8oEVsG7YbCGp
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 04:24:58 -0700 (PDT)
Received: from cpec03f0ed08c7f-cm001ac318e826.cpe.net.cable.rogers.com
	([99.241.2.77] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <rpjday@crashcourse.ca>)
	id 1QYG7a-0000QM-9Q
	for xfs@oss.sgi.com; Sun, 19 Jun 2011 07:24:55 -0400
Date: Sun, 19 Jun 2011 07:24:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: XFS Kconfig variable XFS_TRACE not defined anywhere
Message-ID: <alpine.DEB.2.02.1106190628410.17930@localhost6.localdomain6>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


  just FYI:

===== XFS_TRACE =====
./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o

  as far as i can tell, there is no definition of the Kconfig variable
XFS_TRACE, so that Makefile entry is redundant.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
