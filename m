Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 08:46:18 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1BGk9Qu026003
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 08:46:11 -0800
Received: from out4.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3D67DE165E
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 08:46:33 -0800 (PST)
Received: from out4.smtp.messagingengine.com (out4.smtp.messagingengine.com [66.111.4.28]) by cuda.sgi.com with ESMTP id FD304JH0CRMSQPvU for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 08:46:33 -0800 (PST)
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id A4AEB8834C
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 11:46:29 -0500 (EST)
Message-Id: <1202748389.28320.1236240801@webmail.messagingengine.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Subject: Data safety horror stories?
Date: Mon, 11 Feb 2008 17:46:29 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

I heard that, in case of a power failure, XFS may lose data, even data
that was already existing on the disk. For example, I heard horror
stories of files being overwritten with zeros.

Are those stories true?

If so:

* Do you recommend not using XFS on devices that may frequently fail due
  to power failure?

* Is it possible to find out what files have been damaged? If not,
  will only files be affected that have been changed during the last
  couple of hours?

* Are there options to increase data safety? Should one run a regular
  "sync" in a cron job?

* Is it unsafe to use XFS in a virtual machine which may sometimes be
  terminated without proper shutdown? Suppose the virtual machine is
  running under Windows, and Windows may sometimes be terminated without
  proper shutdown.

I currently am using XFS under Ubuntu 7.10 (Kernel 2.6.22), running in a
virtual machine (VMware) under Windows.  The XFS file system is in a
native partition on a second HDD.

-- 
Felix E. Klee
Jabber/Google Talk: feklee@jabber.org, SIP: 9779619@sipgate.de
ICQ: 158124695, Yahoo!: feklee, AIM: felix.klee@inka.de
Gizmo: felixklee, Skype: felix.klee
