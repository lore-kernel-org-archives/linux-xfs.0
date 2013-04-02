Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D20DC7F61
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 01:08:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8BFA30406A
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 23:08:54 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id Lg8aN7bGOYsbWMzF for
	<xfs@oss.sgi.com>; Mon, 01 Apr 2013 23:08:50 -0700 (PDT)
Date: Tue, 2 Apr 2013 02:08:49 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <247719576.438259.1364882929749.JavaMail.root@redhat.com>
In-Reply-To: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
Subject: xfs deadlock on 3.9-rc5 running xfstests case #78
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: LKML <linux-kernel@vger.kernel.org>

Saw on almost all the servers range from x64, ppc64 and s390x with kernel
3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks like
something new broke this. Log is here with sysrq debug info.
http://people.redhat.com/qcai/stable/log

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
