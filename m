Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 06:48:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2HDmGMH002175
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 06:48:20 -0700
Received: from MTA002E.interbusiness.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5A426AE3A5
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 06:48:46 -0700 (PDT)
Received: from MTA002E.interbusiness.it (MTA002E.interbusiness.it [88.44.62.2]) by cuda.sgi.com with ESMTP id d8yfMHASZ32EfyFS for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 06:48:46 -0700 (PDT)
Received: from trinity.sv.lnf.it ([10.5.1.3])
	by tank.sv.lnf.it with esmtp (Exim 4.63)
	(envelope-from <gaio@sv.lnf.it>)
	id 1JbFhk-0001RZ-Nv
	for xfs@oss.sgi.com; Mon, 17 Mar 2008 14:48:44 +0100
Received: from [10.5.1.23] (helo=harry.sv.lnf.it)
	by trinity.sv.lnf.it with esmtp (Exim 4.63)
	(envelope-from <gaio@sv.lnf.it>)
	id 1JbFhk-00013q-3d
	for xfs@oss.sgi.com; Mon, 17 Mar 2008 14:48:44 +0100
Date: Mon, 17 Mar 2008 14:48:47 +0100
From: Marco Gaiarin <gaio@sv.lnf.it>
Subject: XFS check script on boot?
Message-ID: <20080317134847.GJ14510@sv.lnf.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I've recently suffered an XFS corruption on a remote server (intel,
debian etch, custom 2.6.X kernel): at some point some process hit an
XFS inconsistency on /var, so /var desappear and suddenly machine
refuse to work.

Being a remote machine with no full-knowledge people there, i've
rebooted it, entered in ssh and stopped all services and tasks,
arriving at the point where i can remount /var readonly.
So i was able to xfs_check the partition (that confirmed me the
corruption), but i was not able to unmount /var, so i was forced to use
'-d' options of xfs_repair. That indeed worked. ;)


This was the first tile i hit a xfs filesystem corruption, so i'm
asking why seems there's no /etc/init.d/checkfs.sh-like script that
check and repair XFS filesystem at boot.

Probably doing fully automatically it is a bit too dangerous, but an
approach like 'normal' fsck, eg if filesystem are too corrupt (it need
'-f' option) ask admin password and force to do it by hand, seems to me
simple and effective.


Someone can explain me? Thanks.

-- 
dott. Marco Gaiarin				    GNUPG Key ID: 240A3D66
  Associazione ``La Nostra Famiglia''                http://www.sv.lnf.it/
  Polo FVG  -  Via della Bontà, 7 - 33078  -  San Vito al Tagliamento (PN)
  marco.gaiarin(at)sv.lnf.it	  tel +39-0434-842711  fax +39-0434-842797
