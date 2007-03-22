Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Mar 2007 10:41:49 -0700 (PDT)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2MHfi6p018498
	for <linux-xfs@oss.sgi.com>; Thu, 22 Mar 2007 10:41:46 -0700
Message-ID: <4602BF9A.2080402@exegy.com>
Date: Thu, 22 Mar 2007 12:40:42 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Subject: 2.6.20 (+2.6.21-rc4) write hang modifier
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Dave Lloyd <dlloyd@exegy.com>

If I set /proc/sys/vm/dirty_ratio to "5" the write lockup happens within
the first MilliSecond, at about 100MB per file system.
If I slew the dirty_ratio to 80, the lockup happens
at about 2GB per file system.

2.6.21-rc4 has the same symptoms, and same lockups.
It appears that mptsas is dropping something.

berkley

-- 

//E. F. Berkley Shands, MSc//

**Exegy Inc.**

3668 S. Geyer Road, Suite 300

St. Louis, MO  63127

Direct:  (314) 450-5348

Cell:  (314) 303-2546

Office:  (314) 450-5353

Fax:  (314) 450-5354

 

The Usual Disclaimer follows...
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
