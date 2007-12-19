Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 08:23:36 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBJGNQQA029551
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 08:23:30 -0800
Received: from chef.nerp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A333B70314
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 08:23:37 -0800 (PST)
Received: from chef.nerp.net (chef.nerp.net [199.199.210.160]) by cuda.sgi.com with ESMTP id hPsMrTSgDB4lKHUo for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 08:23:37 -0800 (PST)
Received: from chef.nerp.net (localhost [127.0.0.1])
	by chef.nerp.net (Postfix) with ESMTP id 1BD1B14023C3
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 10:23:52 -0600 (CST)
Received: from webmail.nerp.net (localhost [127.0.0.1])
	by chef.nerp.net (Postfix) with ESMTP id 055C21402673
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 10:23:52 -0600 (CST)
Message-ID: <3136.132.250.11.79.1198081432.squirrel@webmail.nerp.net>
Date: Wed, 19 Dec 2007 08:23:52 -0800 (PST)
Subject: Real time volume free space
From: "Dan" <dan@nerp.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I've been trying to figure out how to determine the free space of a real
time volume.  It seems xfs_db might hold the key but no luck so far... 
Simply running df -h tells me the free space of the meta-data drive only
which basically doesn't change even after Terabyte data collections.

I created the filesystem like this:

mkfs.xfs -r rtdev=/dev/md0 /dev/sda

How would I tell how much space is left on /dev/md0?

Thank you,

Dan
