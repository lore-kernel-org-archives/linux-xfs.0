Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AEBF37F37
	for <xfs@oss.sgi.com>; Sun, 28 Apr 2013 20:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 958508F8037
	for <xfs@oss.sgi.com>; Sun, 28 Apr 2013 18:46:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	X9NJQIjNpLLggdqC for <xfs@oss.sgi.com>;
	Sun, 28 Apr 2013 18:46:02 -0700 (PDT)
Date: Mon, 29 Apr 2013 11:46:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
Message-ID: <20130429014600.GZ10481@dastard>
References: <20130412145555.GF30622@dastard>
	<20130426061231.GA8338@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130426061231.GA8338@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Apr 26, 2013 at 02:12:31AM -0400, Christoph Hellwig wrote:
> Can you send out the libxfs resync separately?  I think that's something
> that should go in ASAP.

Yes, the next version of the tarball will be split up into 3 parts:

	1. - remove dirv1
	   - libxfs kernel resync
	   - add CRC infrstructure
	   - libxlog kernel resync

	2. add CRC support to libxfs

	3. Add CRC support to mkfs, repair, db, etc....

The plan is to do the resync (part 1) as soon as the current
xfsprogs RC is officially released as that gets the largest part of
the patchset into the upstream tree. I've already got this part of
it pretty much ready to go....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
