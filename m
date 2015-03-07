Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 009A57F4E
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 01:52:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 64D79AC001
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 23:52:00 -0800 (PST)
Received: from mx-rz-2.rrze.uni-erlangen.de (mx-rz-2.rrze.uni-erlangen.de
	[131.188.11.21]) by cuda.sgi.com with ESMTP id 9IsoWF8773g9VMLs
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Mar 2015 23:51:52 -0800 (PST)
Received: from boeck1.rrze.uni-erlangen.de (boeck1.rrze.uni-erlangen.de
	[131.188.11.31])
	by mx-rz-2.rrze.uni-erlangen.de (Postfix) with ESMTP id 3kzdLb59zzzDL38
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 08:51:51 +0100 (CET)
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21])
	by boeck1.rrze.uni-erlangen.de (boeck1.rrze.uni-erlangen.de
	[131.188.11.31]) (amavisd-new, port 10026)
	with LMTP id 0dPfND6zOBMN for <xfs@oss.sgi.com>;
	Sat,  7 Mar 2015 08:51:50 +0100 (CET)
Received: from mx-rz-smart.rrze.uni-erlangen.de
	(mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
	by mx-rz-2.rrze.uni-erlangen.de (Postfix) with ESMTP id 3kzdLZ5XtczDL35
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 08:51:50 +0100 (CET)
Received: from [131.188.78.30] (legolas.rrze.uni-erlangen.de [131.188.78.30])
	by mailhub.rrze.uni-erlangen.de (Postfix) with ESMTP id
	3kzdLZ538LzFM6x
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 08:51:50 +0100 (CET)
Message-ID: <54FAAE16.6090505@fau.de>
Date: Sat, 07 Mar 2015 08:51:50 +0100
From: Michael Meier <michael.meier@fau.de>
MIME-Version: 1.0
Subject: XFS hangs with XFS: possible memory allocation deadlock in kmem_alloc
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We've recently upgraded the OS on one of our servers, and since then
have been experiencing frequent stalls of the XFS filesystem on it.
Other filesystems on the machine seem to still respond fine while XFS
hangs. The stalls sometimes last for around 30 minutes, during which all
attempts to access that filesystem hang completely - after that, the
filesystem suddenly responds instantly again, as if there had never been
any problem. The dmesg is full of these messages while it stalls:
 XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)
These also occour from time to time without the filesystem stalling (or
at least it's not noticeable) - the messages appear about once in two
hours, the stalls about once a day.

Google did point me to some reports of these messages occouring at the
end of 2013, but the kernels in question should all have had the fixes
proposed back then - although one message back then suggested there were
more places where this problem could occour that were not fixed yet.

Kernels used were:
- Ubuntu 3.13.0-44  - shows stalls, according to
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382333 has the fix
- Ubuntu 3.16.0-31  - shows stalls
- Ubuntu 3.2.0-various - no stalls in more than 1 year
We can actually still boot the machine with the 3.2.0 kernel, and it
will run absolutely fine, but as that kernel will not be supported
forever, I do not consider that a permanent solution.

The machine should not be low on memory, the disk array far from its
limits, and the I/O-load is mostly reads with very little writes, as
this is a public FTP server.

I have tried to collect some information, available at
https://grid.rrze.uni-erlangen.de/~unrz191/syslog-with-xfs-hangs.log

Regards,
-- 
Michael Meier, Zentrale Systeme
Friedrich-Alexander-Universitaet Erlangen-Nuernberg
Regionales Rechenzentrum Erlangen
Martensstrasse 1, 91058 Erlangen, Germany
Tel.: +49 9131 85-28973, Fax: +49 9131 302941
michael.meier@fau.de
www.rrze.fau.de

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
