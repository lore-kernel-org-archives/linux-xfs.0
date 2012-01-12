Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C4FqKo215804 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 22:15:52 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id wia3B0JPlegjxGci
	for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 20:15:51 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9AE826C129
	for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 22:15:50 -0600 (CST)
Message-ID: <4F0E5E73.9070308@hardwarefreak.com>
Date: Wed, 11 Jan 2012 22:15:47 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: sunit/swidth for HP P4500 Lefthand Networks storage arrays
Reply-To: stan@hardwarefreak.com
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


The Linux host will be Debian Squeeze with a very recent BPO kernel, but
running as a guest inside a VMware cluster.  The storage platform is a
dozen clustered HP P4500/Lefthand Networks "self load balancing" iSCSI
arrays.  The application is Dovecot IMAP using the mdbox mailbox storage
format, which is basically a hybrid mbox/maildir+dedup format.  Files
will be 32-64MB or so, each containing multiple emails, with multiple
files per mailbox directory.  Mail indexes are internal to the files.

What is the best mkfs.xfs configuration for this scenario?

I'm guessing it would be best to simply use mostly, if not completely,
the defaults, due to the way iSCSI packets are redirected on the fly to
any storage node depending on load, by the Lefthand special sauce.

What about mount options?

Should I use barriers with the P4500s or disable them?
TTBOMK the internal PCIe RAID controllers have BBWC, but the ~6GB of RAM
on the P4500 mobos isn't battery backed, but for the typical external
UPS.  In this setup, from a physical hardware standpoint, iSCSI packets
will be making at least 2 ethernet switch hops between the ESX nodes and
the P4500s, with redundant links between everything, if that's a factor
at all.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
