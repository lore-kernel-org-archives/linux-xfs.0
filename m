Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 11:43:21 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBJhEFs016566
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 11:43:17 -0800
Received: from pmx2.sophos.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 026DAB34BF3
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 11:43:25 -0800 (PST)
Received: from pmx2.sophos.com (pmx2.sophos.com [213.31.172.17]) by cuda.sgi.com with ESMTP id oJn59MDAsc36LzO5 for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 11:43:25 -0800 (PST)
Received: from pmx2.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id C38612DA94E
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 19:42:52 +0000 (GMT)
Received: from smtp22.ca.sophos.com (unknown [192.168.3.163])
	by pmx2.sophos.com (Postfix) with ESMTP id 3356C2DA929
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 19:42:52 +0000 (GMT)
Received: from ca-exchange.ca.sophos.com (ca-exchange.activestate.ca [192.168.3.140])
	by smtp.ca.sophos.com (8.13.1/8.13.1) with ESMTP id lBBJgoHQ009552
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 11:42:50 -0800
Content-Class: urn:content-classes:message
Message-ID: <475EE83A.3060607@ca.sophos.com>
Date: Tue, 11 Dec 2007 11:42:50 -0800
From: "David Sparks" <dave@ca.sophos.com>
Reply-To: "David Sparks" <dave@ca.sophos.com>
MIME-Version: 1.0
Subject: mkfs.xfs ... lazy-count=1 ... not mountable by older kernels?
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

Is it expected that filesystems made with lazy-count=1 are not mountable by
older kernels?

I'm installing a system based with install media based on 2.6.19 and mkfs.xfs
2.8.11 (its Gentoo 2007.0).  That mkfs.xfs is old so i copied over a 2.9.4
binary and used that to mkfs the filesystem but its unmountable.  Removing the
lazy-count=1 option makes it mountable.

Is this an expected incompatibility or is mix-n-matching xfsprogs a bad idea?

Thanks!
