Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATJHSWb092491 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 13:17:28 -0600
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 678431EA2112
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:17:27 -0800 (PST)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id ycUDX0QMfQ8liMmi
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:17:27 -0800 (PST)
Received: by ywm19 with SMTP id 19so7875539ywm.26
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:17:26 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 29 Nov 2011 14:17:26 -0500
Message-ID: <CAOO4vO6sSFBxXXK1z018=ekEZpcpnZ5NT_xe3d503NjN3aHF5A@mail.gmail.com>
Subject: sync() in 2.6.38.5
From: Paul Anderson <pha@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Hi all,

2.6.38.5 (x64 intel, in todays case a 40TiByte SAN volume) appears to
have a bug whereby not all active metadata will be flushed even on a
quiescent machine (one that has nonetheless in the past been under
very high load).

We have tried several variations of clean shutdowns, combined with for
example the "echo 3 >/proc/sys/vm/drop_caches" trick to no avail - we
still get lost files (well, 0 length files).

We have several big servers scheduled to go down shortly, and I was
wondering if there are other ideas besides just coping all recent data
to another server.

Thanks,

Paul

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
