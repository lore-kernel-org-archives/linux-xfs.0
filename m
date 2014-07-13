Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB6D37F5D
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 20:17:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92F14304032
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 18:16:59 -0700 (PDT)
Received: from mail-qa0-f52.google.com (mail-qa0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id hGTaG4I7NnoJJhx7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 12 Jul 2014 18:16:54 -0700 (PDT)
Received: by mail-qa0-f52.google.com with SMTP id j15so2132478qaq.11
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 18:16:54 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 12 Jul 2014 18:16:54 -0700
Message-ID: <CA+4uBUYg+81G2=sj3qXO4GGgA7pyjgVrGDCN+UQ32jnWgSbG5w@mail.gmail.com>
Subject: consequences of XFS_IOC_FSSETXATTR on non-empty file?
From: Samuel Just <sam.just@inktank.com>
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
To: xfs@oss.sgi.com, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>, Ilya Dryomov <ilya.dryomov@inktank.com>

Hi,

We are seeing reports of ceph-osd stores on xfs of files with some
garbage data (possibly misplaced from data elsewhere in the
filesystem).  There was a bug for a while where the ceph-osd process
would set a value for fsx_extsize on a non-empty (possibly sparse)
file using XFS_IOC_FSSETXATTR.  Could that plausibly result in a file
with garbage data?  Let me know if there is any additional information
or detail which might be valuable.  One report was on kernel versions
3.14.3 and 3.14.4.
-Sam

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
