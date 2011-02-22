Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MKfZRm257947 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:41:35 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17F31AC008
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 12:44:16 -0800 (PST)
Subject: [PATCH] xfs_repair: validate inode di_flaaags field
From: Alex Elder <aelder@sgi.com>
Date: Tue, 22 Feb 2011 14:43:39 -0600
Message-ID: <1298407419.1960.48.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

(I may have missed it, but I don't believe Dave posted
this patch so I'm doing it for him to get it on the
list.  -Alex)

xfs-reapir is not validating the di_flags field in the inode for
sanity. Block fuzzing indicates that we are not picking situations
like the RT bit being set on filesystems without realtime devices.
    
Signed-off-by: Dave Chinner <dchinner@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
