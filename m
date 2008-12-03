Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3LdsXQ020867 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 15:39:54 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 691DE16876EE
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 13:39:52 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	fIFGJ7iCBJB5KH7s for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2008 13:39:52 -0800 (PST)
Date: Thu, 4 Dec 2008 08:39:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Assertion failed: atomic_read(&mp->m_active_trans)
Message-ID: <20081203213950.GX18236@disturbed>
References: <492BB095.1000104@sgi.com> <4934AAA9.5090405@sgi.com>
	<20081203104849.GF15485@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203104849.GF15485@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 05:48:49AM -0500, Christoph Hellwig wrote:
> I'd rather fix it properly.

Sure, but in the mean time, I'd suggest changing it to a WARN_ON()
rather than an ASSERT(). That way we'll continue to have ppl bug us
about it until the VFS can support read-only remounts without racing
correctly.

Has that work been dropped on the floor, Christoph? We've
been holding off removing this ASSERT or adding the hack
I did to work around the common case of the assert triggering
based on the fact that the problem in the VFS would be fixed
in the next release. That was the case each release since
2.6.25 and there doesn't seem to be much progress...

> Do you guys have a somewhat reliable
> testcase hitting it?

I used to have one of the xfsqa tests hit it every so often,
but not what you'd call reliably....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
