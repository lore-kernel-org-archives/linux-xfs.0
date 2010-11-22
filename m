Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAM0AG5G158506 for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 18:10:16 -0600
Received: from mexforward.lss.emc.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60A6C1C63045
	for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 16:11:51 -0800 (PST)
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id BI8XXbF3HjwGxbEd for
	<xfs@oss.sgi.com>; Sun, 21 Nov 2010 16:11:51 -0800 (PST)
Received: from hop04-l1d11-si01.isus.emc.com (HOP04-L1D11-SI01.isus.emc.com
	[10.254.111.54])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	oAM0Bn3S013505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 19:11:50 -0500
Received: from mailhub.lss.emc.com (mailhub.lss.emc.com [10.254.221.251]) by
	hop04-l1d11-si01.isus.emc.com (RSA Interceptor) for
	<xfs@oss.sgi.com>; Sun, 21 Nov 2010 19:11:45 -0500
Received: from corpussmtp3.corp.emc.com (corpussmtp3.corp.emc.com
	[10.254.169.196])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	oAM0BU0M022891 for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 19:11:30 -0500
From: <Ivan.Novick@emc.com>
Date: Sun, 21 Nov 2010 19:12:38 -0500
Subject: clarifications on inode64 mount option
Message-ID: <C90EF576.118F%ivan.novick@emc.com>
Content-Language: en-US
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
Cc: Timothy.Heath@emc.com

Hi all,

My understanding from the documentation is that inode64 allows inode numbers to be 64 bits in size rather than the default of 32.

Is this correct?  Will the option work fine on 32 bit X86 builds?

The documentation also says:
"This is provided for backwards compatibility, but causes problems for backup applications that cannot handle large inode numbers."
Is this a current issue?  Any examples of backup applications that have trouble reading a file system that uses this option?

Cheers,
Ivan Novick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
