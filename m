Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2E7qNrC143628 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 02:52:24 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id atInUZeL7K98MEaI for
	<xfs@oss.sgi.com>; Wed, 14 Mar 2012 00:52:22 -0700 (PDT)
Date: Wed, 14 Mar 2012 07:52:15 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
Message-ID: <20120314075215.GA44756@nsrc.org>
References: <33498437.post@talk.nabble.com> <20120314073752.GA44708@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120314073752.GA44708@nsrc.org>
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
To: troby <Thorn.Roby@harlandfs.com>
Cc: xfs@oss.sgi.com

> So the conclusion is: do you actually care about performance for this
> application?  If you do, I'd say don't use RAID5.  If you absolutely must
> use parity RAID then go buy a Netapp ($$$) or experiment with btrfs (risky). 
> The cost of another 10 disks for a RAID10 array is going to be small in
> comparison.

Or you could switch to another database like couchdb which only appends to
its database and index files - it never goes back and overwrites existing
blocks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
