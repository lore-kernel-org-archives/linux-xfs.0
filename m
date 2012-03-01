Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21LCYND187311 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 15:12:35 -0600
Received: from mms2.broadcom.com (mms2.broadcom.com [216.31.210.18]) by
	cuda.sgi.com with ESMTP id bREHZ3inh24pUPNz for
	<xfs@oss.sgi.com>; Thu, 01 Mar 2012 13:12:33 -0800 (PST)
Received: from kdasu-VirtualBox.and.broadcom.com (
	dhcp-mhtb-6-210.and.broadcom.com [10.28.6.210]) by
	mail-irva-13.broadcom.com (Postfix) with ESMTP id 4081CBC395 for
	<xfs@oss.sgi.com>; Thu, 1 Mar 2012 13:12:23 -0800 (PST)
From: "Kamal Dasu" <kdasu.kdev@gmail.com>
Subject: [PATCH 0/2] xfsprogs: Replace deprecated ustat and
	sig(relse/hold) glibc APIs
Date: Thu, 1 Mar 2012 16:11:23 -0500
Message-ID: <1330636285-11200-1-git-send-email-kdasu.kdev@gmail.com>
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

Replacing deprecated APis with new ones.

[PATCH 1/2] xfsprogs: replace deprecated ustat call with statfs in libxfs/linux.c
[PATCH 2/2] xfsprogs: Use Posix signal API signprocmask instead of sigrelse/sighold in xfs_copy.c


Kamal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
