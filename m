Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9AF957CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 17:48:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F2AD304032
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 15:48:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NCBSl5LhXeKCTAXX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 15:48:05 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id D6A06C069B2A
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 22:48:04 +0000 (UTC)
Received: from localhost (ovpn-204-74.brq.redhat.com [10.40.204.74])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2HMm3Ns025953
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 18:48:04 -0400
Date: Thu, 17 Mar 2016 22:48:03 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: xfs_growfs causing "Metadata corruption detected at
	xfs_agf_read_verify"
Message-ID: <20160317224803.GA8856@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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


With recent kernels (or maybe xfsprogs?) we've noticed strange
filesystem corruption after using xfs_growfs.

Examples:

https://bugzilla.redhat.com/show_bug.cgi?id=1315895 (on aarch64)
https://www.redhat.com/archives/libguestfs/2016-March/msg00113.html (x86_64)
https://rwmj.wordpress.com/2015/11/04/virt-builder-fedora-23-image/#comment-15668 (x86_64)

Do these errors look familiar?  I don't yet have a simple test case,
still working on that.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
