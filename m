Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Sep 2006 04:51:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8MBpDaG019667
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 04:51:14 -0700
Received: from mail.moloch.sk (chrocht.moloch.sk [62.176.169.44])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 003C645BF10
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 03:44:38 -0700 (PDT)
Received: from dezo.moloch.sk (dezo.moloch.sk [62.176.172.4])
	by mail.moloch.sk (Postfix) with ESMTP id 979B6340F14D
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 12:44:18 +0200 (CEST)
Date: Fri, 22 Sep 2006 12:44:17 +0200
From: Martin Lucina <mato@kotelna.sk>
Subject: Write barrier support with LVM2/md
Message-ID: <20060922104417.GA4161@dezo.moloch.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

Having recently upgraded several systems to Linux 2.6.16/2.6.18 I learnt
about the issues with modern drives and write caching.  Thanks for the
excellent FAQ entry on this.

Unfortunately it seems that write barriers do not work when using XFS on
top of LVM2 (device-mapper).

Trying an explicit mount with -o barrier gives:

Filesystem "dm-4": Disabling barriers, not supported by the underlying device

Is anyone working on a fix for this?  It might be a good idea to add to
the FAQ that write barriers are not supported on dm devices.

-mato
