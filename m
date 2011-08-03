Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73BvfI3151458 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 06:57:41 -0500
Message-ID: <4E3937B1.7050207@sgi.com>
Date: Wed, 03 Aug 2011 06:57:37 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] xfsdump: convert to using the POSIX signal API
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<20110803105911.GA7226@infradead.org>
In-Reply-To: <20110803105911.GA7226@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Bill,
> 
> one thing I noticed looking over the code to understand your changes
> is that there still is a lot of dead code in xfsdump.  One that
> has a lot of implications and seems fairly useless for any non-IRIX
> version is the miniroot mode.  Any chance we can rip that out?  There's

Yes, that's being used to disable multi-stream code in the Linux version.
The end of my multi-stream patch series removes the miniroot code.

> also a lot of code under #ifdef HIDDEN - it would be good to go through
> these and see we can just be removed, and if anything is still useful
> moved under more self-explaining ifdefs.

Will add it to my list.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
