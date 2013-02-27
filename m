Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB1A97CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 19:04:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95FE3304059
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 17:04:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uYDAMpAbf2rZIzyy for
	<xfs@oss.sgi.com>; Tue, 26 Feb 2013 17:04:19 -0800 (PST)
Date: Wed, 27 Feb 2013 01:04:14 +0000
From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re: [BUG]
	Internal error xfs_dir2_data_reada_verify)
Message-ID: <20130227010414.GD1514@agk.fab.redhat.com>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130226044039.GM5551@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Matteo Frigo <athena@fftw.org>, dm-devel@redhat.com, xfs@oss.sgi.com

(Quick pointers that might be relevant)

EAGAIN, I'm not aware of dm itself returning that on the i/o path.

For 3.8 issues, read dm-devel around https://www.redhat.com/archives/dm-devel/2013-February/msg00086.html
(I queued the dm-side fixes for linux-next earlier today)

For pvmove, check exactly which version and whether discards are enabled: there
was a userspace bug for a short period some time ago when discards were enabled.

Alasdair

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
