Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Nov 2006 20:49:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAO4nPaG012798
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 20:49:26 -0800
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kAO4VmBb009394
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 23:31:48 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kAO4VmFZ004471
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 23:31:48 -0500
Received: from [127.0.0.1] (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kAO4VmHX026697
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 23:31:48 -0500
Message-ID: <456675B4.5050302@redhat.com>
Date: Thu, 23 Nov 2006 22:31:48 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: xfs problems with xen blktap driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=217098

Bugzilla Bug 217098: corruption of xen image if stored on XFS partition

apparently using xfs as backing store for xen guest block devices, using 
the blktap driver, is busted.

Ring any bells?  I need to read up on what blktap does (apparently large 
parts in userspace, O_DIRECT + aio....)

Thanks,

-Eric
