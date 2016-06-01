Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 368487CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:36:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE411304059
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 05:36:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Qke0lanyciLDnkGk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 05:36:54 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 721C23B71B
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 12:36:54 +0000 (UTC)
Received: from redhat.com (vpn-61-114.rdu2.redhat.com [10.10.61.114])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u51CaoQK011039
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 1 Jun 2016 08:36:53 -0400
Date: Wed, 1 Jun 2016 14:36:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: XFS_IOC_FSEMAP (old XFS_IOC_FIEMAPFS)
Message-ID: <20160601123650.GC7967@redhat.com>
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

Howdy folks,

I've talked to Dave about moving forward XFS_IOC_FIEMAPFS ioctl, and
consequently their users, such as xfs_spaceman tool.

For now, I'm porting the old stuff to the current code, doing code cleanups,
etc.

If someone wants to take a look, I've made the patches available here:

https://github.com/cmaiolino/linux/tree/fsemap

For now, I just did the port forward of the patches, but still need to clean up
a few stuff, and also port forward xfs_spaceman.

As per Dave suggestion (as you can see in $SUBJ), the ioctl has been renamed to
XFS_IOC_FSEMAP.

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
