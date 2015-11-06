Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DAB7E7F7B
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 12:14:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB2B6304051
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 10:13:57 -0800 (PST)
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
	by cuda.sgi.com with ESMTP id 7sJAw8SuWAp3wxwv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Nov 2015 10:13:56 -0800 (PST)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [PATCH 0/6 V2] xfs: upfront block zeroing for DAX
Date: Fri, 6 Nov 2015 18:12:51 +0000
Message-ID: <80B02B5F638F054B8B1358323FECDE0A5EA64CFA@G1W3650.americas.hpqcorp.net>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1445225238-30413-1-git-send-email-david@fromorbit.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>

Hi,

I wrote a test tool that exercises page faults on hole-y portions of
an mmapped file.  The file is created, sized using various methods,
mmapped, and then two threads race to write a marker to different
offsets within each mapped page.  Once the threads have finished
marking each page, the pages are checked for the presence of the
markers.

The test easily exposes corruption on pmem-backed, DAX-mounted xfs
and ext4 file systems.

With 4.3 and this patch set, the data corruption is no longer seen.

The test code was posted to linux-ext4:
http://marc.info/?l=linux-ext4&m=144683276225574&w=2


For the series:
Tested-by: Brian Boylston <brian.boylston@hpe.com>


-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Sunday, October 18, 2015 11:27 PM
Subject: [PATCH 0/6 V2] xfs: upfront block zeroing for DAX

Hi folks,

This is an updated patch set that was first posted here:

http://oss.sgi.com/archives/xfs/2015-10/msg00006.html

I've dropped the DAX locking revert patch from it; that's on it's
way to Linus via other channels and is essentially independent to
this set of XFS changes.

The only real change in the XFS code between the two versions is the
addition of XFS_TRANS_RESERVE in the DAX path in
xfs_iomap_write_direct() to allow it to dip into the reserve block
pool for unwritten extent conversion rather than reporting ENOSPC.

Patches are against 4.3-rc5 + XFS for-next branch.

-Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
