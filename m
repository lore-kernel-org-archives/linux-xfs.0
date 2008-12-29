Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTNchiR009170 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 17:38:45 -0600
Received: from baerbel.szm.maschinenbau.tu-darmstadt.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BD8217949FD
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 15:38:42 -0800 (PST)
Received: from baerbel.szm.maschinenbau.tu-darmstadt.de
	(baerbel.szm.maschinenbau.tu-darmstadt.de [130.83.48.97]) by
	cuda.sgi.com with ESMTP id 2SIPHpmL2Wk79X1z for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 15:38:42 -0800 (PST)
Received: from baerbel.szm.maschinenbau.tu-darmstadt.de (localhost [127.0.0.1])
	by baerbel.szm.maschinenbau.tu-darmstadt.de (8.13.8/8.13.8) with ESMTP
	id mBTNTGkn006834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 00:29:18 +0100
Received: (from tacke@localhost)
	by baerbel.szm.maschinenbau.tu-darmstadt.de (8.13.8/8.13.8/Submit) id
	mBTNTFMb006833 for xfs@oss.sgi.com; Tue, 30 Dec 2008 00:29:15 +0100
Date: Tue, 30 Dec 2008 00:29:15 +0100
From: Elrond <elrond+xfs.oss.sgi.com@samba-tng.org>
Subject: xfsaild wakeups
Message-ID: <20081229232915.GA6724@memak.tu-darmstadt.de>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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


Hi,

The major issue of xfsaild wakeups was analyzed in
February. (see
http://oss.sgi.com/archives/xfs/2008-02/msg00169.html ).

A small issue persists. We're now at 1 wakeup per second
and mounted filesystem. I have three xfs on my box and the
number wants to grow. xfsaild is on place two of my
powertop wakeup list. Sometimes place one.

Is anyone working on reducing this to zero for an idle fs?


Cheers,


    Elrond

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
