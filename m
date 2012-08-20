Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KMluOn010308 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 17:47:56 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Zga2QXaYoyzaHmql for
	<xfs@oss.sgi.com>; Mon, 20 Aug 2012 15:47:55 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KMltr3007704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:47:55 -0400
Received: from orion.usersys.redhat.com (vpn1-6-42.gru2.redhat.com
	[10.97.6.42])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q7KMlq9Z029367
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:47:54 -0400
Date: Mon, 20 Aug 2012 19:47:51 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: fix race while discarding buffers [V4]
Message-ID: <20120820224751.GA22096@orion.usersys.redhat.com>
References: <1344621711-8049-1-git-send-email-cmaiolino@redhat.com>
	<20120820205134.GB29979@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120820205134.GB29979@sgi.com>
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

Hi Ben,
> 
> 
Thanks for the comments.
> 
> What was the symptom that led to the discovery of this problem?
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>
> 

It started with the messages like the example below being logged by syslog:

shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-61993820
shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-146
shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-240601220
shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-152
shrink_slab: xfs_buftarg_shrink+0x0/0x160 [xfs] negative objects to delete nr=-2921236993

These messages came from shrink_slab().

After that I've added a second counter into the xfs_buftarg_shrink() to check
the amount of elements in list (via list_for_each() macro) to confirm the
discrepancy between the counter and the real number of elements in list, and
last, Eric added a second and local counter to xfs_buftarg_shrink, to account
the number of buffers being added and removed from the dispose list into each
call to xfs_buftarg_shrink(), where, when the problem started, we could see a
wrong number of buffers beind added and/or removed from the dispose list.

Cheers.

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
