Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 15:02:57 -0700 (PDT)
Received: from av8-1-sn3.vrr.skanova.net (av8-1-sn3.vrr.skanova.net [81.228.9.183])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5IM2qdo020190
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 15:02:54 -0700
Received: from smtp3-2-sn3.vrr.skanova.net (smtp3-2-sn3.vrr.skanova.net [81.228.9.102])
	by av8-1-sn3.vrr.skanova.net (Postfix) with ESMTP id 8DFCB38197
	for <xfs@oss.sgi.com>; Sun, 17 Jun 2007 14:22:09 +0200 (CEST)
Received: from cobra.e-626.net (h48n2fls32o1110.telia.com [217.209.79.48])
	by smtp3-2-sn3.vrr.skanova.net (Postfix) with ESMTP id 7CDA637E4A
	for <xfs@oss.sgi.com>; Sun, 17 Jun 2007 14:22:07 +0200 (CEST)
Received: from [192.168.1.201] (h48n2fls32o1110.telia.com [217.209.79.48])
	(authenticated bits=0)
	by cobra.e-626.net (8.14.0/8.14.0) with ESMTP id l5HCLxBO023538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Sun, 17 Jun 2007 14:22:04 +0200
Message-ID: <46752756.9070307@e-626.net>
Date: Sun, 17 Jun 2007 14:21:42 +0200
From: Johan Andersson <johan@e-626.net>
MIME-Version: 1.0
Subject: CVS server out of space for lock files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

Just noticed that the cvs server at oss.sgi.com seems to be out of disk 
space.
A "cvs -d :pserver:cvs@oss.sgi.com:/cvs co xfs-cmds" gives:
...
cvs checkout: failed to create lock directory for `/cvs/xfs-cmds/attr2' 
(/var/lock/cvs/xfs-cmds/attr2/#cvs.lock): No space left on device
cvs checkout: failed to obtain dir lock in repository `/cvs/xfs-cmds/attr2'
cvs [checkout aborted]: read lock failed - giving up


/Johan Andersson
