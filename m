Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGLroRY123961 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 15:53:51 -0600
Received: from mexforward.lss.emc.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDB00186DB4
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 13:55:23 -0800 (PST)
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id 4U3TAK0W53xOF4jV for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 13:55:23 -0800 (PST)
Received: from hop04-l1d11-si02.isus.emc.com (HOP04-L1D11-SI02.isus.emc.com
	[10.254.111.55])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	oAGLtMGo017482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 16:55:22 -0500
Received: from mailhub.lss.emc.com (mailhub.lss.emc.com [10.254.222.226]) by
	hop04-l1d11-si02.isus.emc.com (RSA Interceptor) for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 16:55:14 -0500
Received: from corpussmtp3.corp.emc.com (corpussmtp3.corp.emc.com
	[10.254.169.196])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	oAGLt28x003825 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 16:55:02 -0500
From: <Ivan.Novick@emc.com>
Date: Tue, 16 Nov 2010 16:56:00 -0500
Subject: allocsize mount option behavior
Message-ID: <C9083DF0.FCE%ivan.novick@emc.com>
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Timothy.Heath@emc.com

Hello,

I am using the allocsize mount option to reduce fragmentation, by ensuring =
extents are of a minimum size.

Under a workload with heavy concurrency we noticed that disk space usage we=
nt up noticeably.

Can someone clarify the expected behavior of allocsize.  Does it force file=
s to be at least the allocsize size on disk, or is the allocsize size reser=
ved for each open file and then freed up if it is not used and the file is =
closed, or does it work some other way.

For example if allocsize=3D1g and I open 1000 files and start writing a sma=
ll amount of data to each file =85. Would the device show as using 1000* 1g=
 of disk space while the files are opened and after they are closed then on=
ly the amount of space actually written by the user would be shown as used =
on disk?

Cheers,
Ivan Novick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
