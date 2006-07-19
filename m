Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 17:20:15 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6K0JvDW022620
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 17:19:58 -0700
Received: by ug-out-1314.google.com with SMTP id h2so544207ugf
        for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 17:19:35 -0700 (PDT)
Message-ID: <68559cef0607191431m4b59e142v51e1c1dc12e60dc0@mail.gmail.com>
Date: Wed, 19 Jul 2006 23:31:15 +0200
From: "Luca Maranzano" <liuk001@gmail.com>
Subject: XFS: possible memory allocation deadlock in _pagebuf_lookup_pages (mode:0x250)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello all,

we have a CentOS 4.3 Server on an HP DL 380G3, 1 Xeon 2,8 Ghz (no
hyperthreading).
Kernel: 2.6.9-34.0.2.EL
Xfs:
xfsprogs-2.7.3-1
kernel-module-xfs-2.6.9-34.EL-0.1-3

modinfo xfs:
filename:       /lib/modules/2.6.9-34.0.2.EL/extra/xfs.ko
author:         Silicon Graphics, Inc.
description:    SGI-XFS CVS-2004-10-17_05:00_UTC with ACLs, security
attributes, realtime, large block numbers, no debug enabled
license:        GPL
vermagic:       2.6.9-34.EL 686 REGPARM 4KSTACKS gcc-3.4
depends:

The server has 1 Emulex Lp9002 with 3 LUNs of our SAN.
2 LUNs are forming a Striped LVM2 volume of 2,7 TB.
1 LUN is an LVM2 volume of 1,5 TB.

The message appeared during moderately heavy load copying 700GB from
one LVM to the other LVM (serveral thousands of I/O on the HBA).
Apparently it's still working fine, but we are a bit worried about this message.
Do you suggest some upgrade of the Kernel or the xfs modules?

TIA.
Kind regards,
Luca
