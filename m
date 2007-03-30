Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 06:24:05 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2UDO06p013024
	for <linux-xfs@oss.sgi.com>; Fri, 30 Mar 2007 06:24:01 -0700
Received: from localhost (dslb-084-056-071-160.pools.arcor-ip.net [84.56.71.160])
	by mail.lichtvoll.de (Postfix) with ESMTP id A639F5AD2C
	for <linux-xfs@oss.sgi.com>; Fri, 30 Mar 2007 15:23:58 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: write barrier and USB devices
Date: Fri, 30 Mar 2007 15:23:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703301523.58027.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello!

Does the usb mass storage driver support write barriers?

I think it does, since XFS doesn't complain:

---------------------------------------------------------------------
shambala:~> mount -o barrier /dev/sdb2 /mnt/daten
(note barrier is default since 2.6.17, but anyway)

shambala:~> tail -f /var/log/syslog
[...]
Mar 30 15:11:59 shambala kernel: XFS mounting filesystem sdb2
Mar 30 15:11:59 shambala kernel: Ending clean XFS mount for filesystem: 
sdb2
---------------------------------------------------------------------

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
