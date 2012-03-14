Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EMmvpA004321 for <xfs@OSS.SGI.com>; Wed, 14 Mar 2012 17:48:57 -0500
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	eypzWnZ5XjrI9Fyu for <xfs@OSS.SGI.com>;
	Wed, 14 Mar 2012 15:48:55 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4F58EC1A0025DCCE for xfs@OSS.SGI.com; Wed, 14 Mar 2012 22:48:53 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1S7qKq-0002QE-WA
	for <xfs@OSS.SGI.com>; Wed, 14 Mar 2012 15:41:57 +0000
MIME-Version: 1.0
Message-ID: <20320.48195.534958.734938@tree.ty.sabi.co.UK>
Date: Wed, 14 Mar 2012 15:41:55 +0000
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
In-Reply-To: <20120314073752.GA44708@nsrc.org>
References: <33498437.post@talk.nabble.com> <20120314073752.GA44708@nsrc.org>
From: pg_xf2@xf2.for.to.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... chunk sizes and relatively small random IO ... ]

> So the conclusion is: do you actually care about performance
> for this application?  If you do, I'd say don't use RAID5.

That's a general argument :-). http://WWW.BAARF.com/

The argument you make about RMW for relatively small random
transactions becomes even more relevant when considering parity
rebuilding in case of a drive failure.

> If you absolutely must use parity RAID then go buy a Netapp
> ($$$) or experiment with btrfs (risky).

The Netapp WAFL or BTRFS don't "solve" the RMW problem, they
just do parity with COW (object based in the case of BTRFS).

The COW does not do in-place RMW, but something that has the
same cost overall (depending on balance of read/writes and duty
cycle and temporal vs spatial locality).

The presence of parity chunks that must be kept in sync with the
other blocks in the same stripe turns the stripe into a a block
"cluster" for write purposes, and that's inescapable.

If *multithreaded* performance were not important there would
instead be a case for RAID2/3 with synchronous disks (to nullify
the disk alignment times), but suitable components are probably
not easy to source.

> The cost of another 10 disks for a RAID10 array is going to be
> small in comparison.

More wise words, but this is a discussion about a choice to use
an 11+1 RAID5, which is something that looks good to "management"
by saving money upfront by delaying trouble (decreasing speed and
higher risk) to later :-).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
