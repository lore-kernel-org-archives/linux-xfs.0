Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 19:40:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D2eEeD013429
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 19:40:14 -0700
Received: from mailgw3a.lmco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E04CA58DDF
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 19:41:49 -0700 (PDT)
Received: from mailgw3a.lmco.com (mailgw3a.lmco.com [192.35.35.7]) by cuda.sgi.com with ESMTP id 20e1m694HGXMJxR8 for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 19:41:49 -0700 (PDT)
Received: from emss09g01.ems.lmco.com (relay6.ems.lmco.com [166.17.13.59])by mailgw3a.lmco.com  (LM-6) with ESMTP id m9D2B03K000655for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 22:11:00 -0400 (EDT)
Received: from CONVERSION2-DAEMON.lmco.com by lmco.com (PMDF V6.3-x14 #31428)
 id <0K8N00A01NECCV@lmco.com> for xfs@oss.sgi.com; Sun, 12 Oct 2008 22:11:00 -0400 (EDT)
Received: from EMSS04I00.us.lmco.com ([166.17.13.135]) by lmco.com (PMDF V6.3-x14 #31428)
 with ESMTP id <0K8N002EMNE7NO@lmco.com> for xfs@oss.sgi.com; Sun, 12 Oct 2008 22:10:55 -0400 (EDT)
Date: Sun, 12 Oct 2008 22:10:54 -0400
From: "Ngo, Andrew" <andrew.ngo@lmco.com>
Subject: Stale XFS mount for Kernel 2.6.25.14
Message-id: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com>
MIME-version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: "Johnson, Je" <je.johnson@lmco.com>, "Ngo, Andrew" <andrew.ngo@lmco.com>

Hi,  
 
This is my first attempt to report a stale mount problem.  If this is
not the relevant mail list, please let me know.  I suspect that my
problem is xfs related, thus I select this mailing list.
 
I have a system that recently upgraded it's kernel to 2.6.25.14.  The
system's previous kernel was 2.6.18.-8.el5.  With the previous kernel, I
have no problem with executing the following commands when the system is
in operation.  Note that the /mnt/mountpoint is mounted on a XFS file
system.
 
mount -o rw,remount /mnt/mountpoint
mount -o ro,remount /mnt/mountpoint
 
With kernel 2.6.25.14, however, the mount command may be hang when
changing from rw to ro.  When this happen, system is very sluggish.
Even the "shutdown -r now" command is not taken.  The only way to get
out of this hang is by manually pressing the power button
 
Your sugguestion is greatly appreciated.
 
Andy Ngo


[[HTML alternate version deleted]]
