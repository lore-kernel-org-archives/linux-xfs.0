Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48B857F50
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 03:13:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D725A8F8064
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 01:13:25 -0800 (PST)
Received: from volubilis.easter-eggs.com (volubilis.easter-eggs.com
	[37.9.136.135]) by cuda.sgi.com with ESMTP id kFGrB33yQGNUxqem
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 01:13:24 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by volubilis.easter-eggs.com (Postfix) with ESMTP id 743EC15E49
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 10:13:23 +0100 (CET)
Received: from datura.easter-eggs.fr (coquelicot-a.easter-eggs.com
	[82.235.59.105])
	by volubilis.easter-eggs.com (Postfix) with ESMTPSA id 2B8C915E27
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 10:13:23 +0100 (CET)
Date: Thu, 28 Nov 2013 10:13:22 +0100
From: Emmanuel Lacour <elacour@easter-eggs.com>
Subject: XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
Message-ID: <20131128091322.GC5337@easter-eggs.com>
MIME-Version: 1.0
Content-Disposition: inline
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


Dear XFS users,


I run a Ceph cluster using XFS on Debian wheezy servers and Linux 3.10
(debian backports). I see the following line in our logs:

XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

does this reveal a problem in my setup or may I ignore it? If it's a
problem, can someone give me any hint on solving this?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
