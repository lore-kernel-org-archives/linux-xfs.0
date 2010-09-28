Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8SIqlAU255396 for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 13:52:48 -0500
Received: from mexforward.lss.emc.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83FABAEA58
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 11:53:45 -0700 (PDT)
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id 2TpVACeoJ2PHq7FA for
	<xfs@oss.sgi.com>; Tue, 28 Sep 2010 11:53:45 -0700 (PDT)
Received: from hop04-l1d11-si04.isus.emc.com (HOP04-L1D11-SI04.isus.emc.com
	[10.254.111.24])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	o8SIrgSF025242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 14:53:43 -0400
Received: from mailhub.lss.emc.com (mailhub.lss.emc.com [10.254.221.253]) by
	hop04-l1d11-si04.isus.emc.com (RSA Interceptor) for
	<xfs@oss.sgi.com>; Tue, 28 Sep 2010 14:53:38 -0400
Received: from corpussmtp4.corp.emc.com (corpussmtp4.corp.emc.com
	[10.254.169.197])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	o8SIrK0p015364 for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 14:53:20 -0400
From: <Ivan.Novick@emc.com>
Date: Tue, 28 Sep 2010 14:53:46 -0400
Subject: allocsize mount option
Message-ID: <C8C787CA.44AA%ivan.novick@emc.com>
Content-Language: en
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

According to the documentation the allocsize mount option: "Sets the
buffered I/O end-of-file preallocation size when doing delayed allocation
writeout"

Will this value limit "extent" sizes to be be no smaller than the allocsize?

I have set the following mount options:
(rw,noatime,nodiratime,logbufs=8,allocsize=512m)

And yet, depending on the workload, the extent sizes are often 1 or 2 orders
of magnitude lower than 512 MB ...

If I wanted to do further reading on the subject, can someone point me to an
approximate location in the code where the size of a newly created extent is
determined?

Cheers,
Ivan Novick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
