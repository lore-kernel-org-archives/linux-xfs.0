Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ELnsvA076231 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 16:49:54 -0500
From: <Ivan.Novick@emc.com>
Date: Thu, 14 Oct 2010 17:50:15 -0400
Subject: Re: [RFC, PATCH 0/2] xfs: dynamic speculative preallocation for
	delalloc
Message-ID: <C8DCC927.48D3%ivan.novick@emc.com>
In-Reply-To: <20101014211626.GD4681@dastard>
Content-Language: en
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, aelder@sgi.com
Cc: xfs@oss.sgi.com

>> The reported numbers were a drop in read throughput of ~15% on a
>> GB/s class filesystem when the files interleaved.
I have seen ~50% performance improvement in read rate when changing from small extents to large extents with XFS. Essentially going from not using allocsize to setting 1gb allocsize.  Also GB/s class filesystem.

Cheers,
Ivan Novick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
