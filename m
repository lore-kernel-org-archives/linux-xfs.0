Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0GM9avR004167 for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 16:09:37 -0600
Received: from qb-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECAEC96E16
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 14:09:35 -0800 (PST)
Received: from qb-out-1314.google.com (qb-out-1314.google.com [72.14.204.175])
	by cuda.sgi.com with ESMTP id Os5xMTU19OBByZEw for
	<xfs@oss.sgi.com>; Fri, 16 Jan 2009 14:09:35 -0800 (PST)
Received: by qb-out-1314.google.com with SMTP id e19so849205qba.8
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 14:09:34 -0800 (PST)
Message-ID: <8998fba30901161409m37058e10yc25e062fad425710@mail.gmail.com>
Date: Fri, 16 Jan 2009 14:09:34 -0800
From: "Adam Fried-Gintis" <xfs@icosm.net>
Subject: XFS without write barriers - safe on multipath device?
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

Hi,
I am just curious, if I see the warning that write barrier support is
disabled when mounting an XFS filesystem through md multipath, does XFS have
some OTHER provision for protecting the order of its writes to the
underlying device, or is it unsafe to run with write back caching at that
point? My underlying device is an active/active storage system - combined
with the multipath driver, we are seeing metadata corruption on the
filesystem, and I'm just trying to figure out if this is an invalid
configuration to test or if the storage device is doing something wrong.

Thanks!

---
Adam Fried-Gintis


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
