Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 416357F96
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 05:30:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12D9230404E
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 03:30:07 -0800 (PST)
Received: from fftw.org (216.119.142.145.static.a2webhosting.com
	[216.119.142.145]) by cuda.sgi.com with ESMTP id
	D3sABzEfzVFX7xmU (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 03:30:06 -0800 (PST)
From: Matteo Frigo <athena@fftw.org>
Subject: Re: [BUG] pvmove corrupting XFS filesystems (was Re: [BUG] Internal
	error xfs_dir2_data_reada_verify)
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
Date: Tue, 26 Feb 2013 06:29:58 -0500
In-Reply-To: <20130226044039.GM5551@dastard> (Dave Chinner's message of "Tue,
	26 Feb 2013 15:40:39 +1100")
Message-ID: <87mwurpb2h.fsf@fftw.org>
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

> All of the evidence points of a problem caused by the pvmove
> operation. I'd suggest that you don't use it until we get to the
> bottom of the problem (i.e. where the EAGAIN is coming from and
> why)....

Dave,

thanks for your quick reply and detailed analysis.

For the benefit of other readers, I wish to add that the same problem
occurs when creating lvm mirrors (e.g. "lvconvert -m1 vg/lvol"), which
is not surprising since pvmove works itself by creating a mirror.
Consequently, mirror creation should also be avoided until the root
cause of the problem is eliminated.

Cheers,
Matteo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
