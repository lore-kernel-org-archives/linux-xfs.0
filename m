Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 010227FDA
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 05:39:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80911AC003
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 03:39:12 -0800 (PST)
Received: from fftw.org (216.119.142.145.static.a2webhosting.com
	[216.119.142.145]) by cuda.sgi.com with ESMTP id
	yFg3EeuKU3C8siQZ (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Mar 2013 03:39:11 -0800 (PST)
From: Matteo Frigo <athena@fftw.org>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re: [BUG]
	Internal error xfs_dir2_data_reada_verify)
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
	<87k3pjs908.fsf@fftw.org> <20130307223140.GU23616@dastard>
	<87hakmpxac.fsf@fftw.org> <20130308015723.GA23616@dastard>
Date: Fri, 08 Mar 2013 06:38:56 -0500
In-Reply-To: <20130308015723.GA23616@dastard> (Dave Chinner's message of "Fri,
	8 Mar 2013 12:57:23 +1100")
Message-ID: <87ppza5df3.fsf@fftw.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> Add the the patch below. If you still see errors, then they are real
> IO errors from the block device.

This patch fixes the problem for me.

The patch works both when dm-raid1 returns -EIO and when it returns
-EWOULDBLOCK.

Thanks for your help.

Cheers,
Matteo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
