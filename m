Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBDMNEI2016164 for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 16:23:14 -0600
Received: from mexforward.lss.emc.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D66CC1CBFEDB
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 14:25:05 -0800 (PST)
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id W8nYyGKEz6ASiEl5 for
	<xfs@oss.sgi.com>; Mon, 13 Dec 2010 14:25:05 -0800 (PST)
Received: from hop04-l1d11-si04.isus.emc.com (HOP04-L1D11-SI04.isus.emc.com
	[10.254.111.24])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	oBDMP4pG016177
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 17:25:04 -0500
Received: from mailhub.lss.emc.com (mailhub.lss.emc.com [10.254.221.145]) by
	hop04-l1d11-si04.isus.emc.com (RSA Interceptor) for
	<xfs@oss.sgi.com>; Mon, 13 Dec 2010 17:25:01 -0500
Received: from mxhub19.corp.emc.com (mxhub19.corp.emc.com [10.254.93.48])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id
	oBDMOmnl028856 for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 17:24:48 -0500
From: <Ivan.Novick@emc.com>
Date: Mon, 13 Dec 2010 17:24:46 -0500
Subject: inode64 mount option added after data exists
Message-ID: <C92BDD2E.1C75%ivan.novick@emc.com>
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

Hi all,

Quick question about the inode64 mount option.

Is it safe to add this mount option to a file system that was already created and wrote lots of data without it.

Will it still work as intended in this case (use 64 bit inodes)?

Cheers,
Ivan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
