Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAI3r07f016548 for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 19:53:00 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2793F15924F0
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 19:52:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id w9tUiRU2PSFeditU for <xfs@oss.sgi.com>;
	Mon, 17 Nov 2008 19:52:53 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id BEF1BAC3591
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 21:52:51 -0600 (CST)
Message-ID: <49223C13.2080507@sandeen.net>
Date: Mon, 17 Nov 2008 21:52:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 0/7] xfs-cmds parallel build patches
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
To: xfs-oss <xfs@oss.sgi.com>

On a 4-way xeon, the build time for attr+acl+dmapi+xfsprogs+xfsdump (not
configure or package or whatnot time) goes from 2m12s to 42s for me; the
more processors the better ;)

Merge this, guys, and you'll spend less time waiting for builds & more
time merging other patches ;)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
