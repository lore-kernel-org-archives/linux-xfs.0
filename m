Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4F2B7F4E
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 14:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 744C2AC002
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 12:20:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y7mhbRtrGfSOqSOZ for
	<xfs@oss.sgi.com>; Wed, 01 May 2013 12:20:42 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r41JKff8002354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 1 May 2013 15:20:42 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r41JKeYu019105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 1 May 2013 15:20:41 -0400
Message-ID: <51816B08.7060305@redhat.com>
Date: Wed, 01 May 2013 14:20:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: xfs_metadump of frozen fs?
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
To: xfs-oss <xfs@oss.sgi.com>

xfs_metadump(8)                                                xfs_metadump(8)

...
       xfs_metadump should only be used to copy unmounted filesystems,  read-only
       mounted  filesystems,  or  frozen filesystems (see xfs_freeze(8)).  Other-
       wise, the generated dump could be inconsistent or corrupt.
...

However, it doesn't work on a frozen fs.  There's no way to programatically
detect a frozen fs AFAIK...

Has this ever worked?  I see 3 potential solutions:

1) a --force option to proceed even if mounted
2) teach xfs_metadump to optionally freeze a mounted fs and proceed
3) fix the manpage

Thoughts?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
