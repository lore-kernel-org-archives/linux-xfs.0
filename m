Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KBAQWt071462 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 06:10:26 -0500
Received: from srv2.trombetti.net (srv2.trombetti.net [65.254.53.252]) by
	cuda.sgi.com with ESMTP id Y43bB3woemPFuKWY for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 04:11:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id DFBF3543B7
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 07:11:37 -0400 (EDT)
Message-ID: <505AF9EA.7030603@shiftmail.org>
Date: Thu, 20 Sep 2012 13:11:38 +0200
From: Spelic <spelic@shiftmail.org>
MIME-Version: 1.0
Subject: Questions on RAID alignment
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello list
a few questions

1- Does XFS support alignment to concatenation RAIDs (e.g. linear over 
raid1) similarly to striped ones? I am guessing probably su and sw 
should not be specified and the agcount should be multiple of the number 
of the concatenated devices, is that correct?

2- Can mkfs parameters be altered after creation, e.g. after growing a 
RAID and then growing the XFS fs, can I also alter su, sw, agcount somehow?

3- I seem to remember there was an xattr that one could attach to /home 
(if /home was under XFS) so that every user (subdir of /home) would get 
a different AG in a different RAID device. I cannot find that 
information anymore on the internet; could you refresh my mind?

Thank you
Spelic

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
