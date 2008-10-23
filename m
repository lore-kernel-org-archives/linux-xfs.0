Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 13:56:26 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NKuGms007274
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 13:56:17 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id 37F6D90889
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 13:58:00 -0700 (PDT)
Received: from [134.15.251.4] (melb-sw-corp-251-4.corp.sgi.com [134.15.251.4]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id HAA11969 for <xfs@oss.sgi.com>; Fri, 24 Oct 2008 07:57:58 +1100
Message-ID: <4900F34C.2090205@sgi.com>
Date: Fri, 24 Oct 2008 07:57:32 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: [Fwd: [xfs-masters] [Bug 11813] New: xfs filesystem exported via
 nfs don't work in 2.6.27.3]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

looks like we better do something urgently to fix this.
Any suggestions Christoph?

Cheers

-------- Original Message --------
Subject: [xfs-masters] [Bug 11813] New: xfs filesystem exported via nfs 
don't work in 2.6.27.3
Date: Thu, 23 Oct 2008 12:32:51 -0700 (PDT)
From: bugme-daemon@bugzilla.kernel.org
Reply-To: xfs-masters@oss.sgi.com
To: xfs-masters@oss.sgi.com

http://bugzilla.kernel.org/show_bug.cgi?id=11813

            Summary: xfs filesystem exported via nfs don't work in 2.6.27.3
            Product: File System
            Version: 2.5
      KernelVersion: 2.6.27.3
           Platform: All
         OS/Version: Linux
               Tree: Mainline
             Status: NEW
           Severity: normal
           Priority: P1
          Component: XFS
         AssignedTo: xfs-masters@oss.sgi.com
         ReportedBy: francois.valenduc@tvcablenet.be


Latest working kernel version: 2.6.27.2
Earliest failing kernel version: 2.6.27.3
Distribution: Gentoo
Hardware Environment:
Software Environment:
Problem Description:

With kernel 2.6.27.3, it's impossible to use a xfs filesystem  exported via
NFS. I am using gentoo and I share a portage tree mounted on an xfs 
filesystem
via NFS. Each time packages are fetched, the emerge process is blocked. It
seems the problematic commit is the following:

commit c068663ae65e507814545b59a8e2090f48a85613
Author: Christoph Hellwig <hch@lst.de>
Date:   Sun Oct 12 14:30:44 2008 +0200

     xfs: fix remount rw with unrecognized options

     commit 6c5e51dae2c37127e00be392f40842e08077e96a upstream

     When we skip unrecognized options in xfs_fs_remount we should just 
break
     out of the switch and not return because otherwise we may skip clearing
     the xfs-internal read-only flag.  This will only show up on some
     operations like touch because most read-only checks are done by the VFS
     which thinks this filesystem is r/w.  Eventually we should replace the
     XFS read-only flag with a helper that always checks the VFS flag to 
make
     sure they can never get out of sync.

     Bug reported and fix verified by Marcel Beister on #xfs.
     Bug fix verified by updated xfstests/189.

If I revert it, the problem doesn't occur.

Steps to reproduce:


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.



-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
