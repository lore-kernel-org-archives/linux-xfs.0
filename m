Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n46JWTIR140650 for <xfs@oss.sgi.com>; Wed, 6 May 2009 14:32:30 -0500
Received: from andrew.triumf.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 989911D13FEE
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 12:32:32 -0700 (PDT)
Received: from andrew.triumf.ca (andrew.triumf.ca [142.90.106.59]) by
	cuda.sgi.com with ESMTP id SS6XsVzIpk7tpRzB for
	<xfs@oss.sgi.com>; Wed, 06 May 2009 12:32:32 -0700 (PDT)
Date: Wed, 6 May 2009 12:32:25 -0700 (PDT)
From: Andrew Daviel <advax@triumf.ca>
Subject: Problems with XFS on iSCSI in RHEL4
Message-ID: <Pine.LNX.4.64.0905061149480.26440@andrew.triumf.ca>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, linux-iscsi-users@lists.sourceforge.net


A while back (2004) there was some discussion about problems with XFS
and iSCSI.

I wondered whether the issues had been fixed in later kernels, or whether 
there is an underlying issue that will not go away.

We have been using XFS for our mailstore both on local disks and on ATA 
Over Ethernet to a CORAID box with no problem.
We want to replace the CORAID with a Sun Storage 7410 box, using iSCSI 
instead of AOE.

When I create an ext3 volume on the Sun, things are OK.
When I create an XFS volume, after doing mkdir, I get e.g.
   kernel: Bad page state at free_hot_cold_page (in process 'iscsi-rx',
   page c1069a20)
   kernel: Trying to fix it up, but a reboot is needed
   kernel: Bad page state at free_hot_cold_page (in process 'syslogd',
   page c1069a20)

Scientific Linux SL release 4.6
kernel-smp-2.6.9-78.0.17.EL from kernel-2.6.9-78.0.17.EL.src.rpm
   includes scsi_transport_iscsi.ko,iscsi_sfnet.ko
kernel-module-xfs-2.6.9-78.0.17.ELsmp-0.4-1 from xfs-0.4-1.src.rpm
iscsi-initiator-utils-4.0.3.0-6

Also seen on:
Scientific Linux SL release 4.5
kernel-smp-2.6.9-55.0.6.EL.i686
kernel-module-xfs-2.6.9-55.0.6.ELsmp-0.1-1.i686

SL is basically the same as CENTOS (compiled from RHEL GPL'd sources)


-- 
Andrew Daviel, TRIUMF, Canada
Tel. +1 (604) 222-7376  (Pacific Time)
Network Security Manager

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
