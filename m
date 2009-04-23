Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHPC0S017213 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:25:12 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A1771CE2065
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:25:09 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id hQuZKGsaawCADNTK for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 10:25:09 -0700 (PDT)
Message-ID: <49F0A44F.9040603@sandeen.net>
Date: Thu, 23 Apr 2009 12:24:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enforce lazy-count=0 in log tests 018, 081, 082
References: <49EE28EA.4010409@sandeen.net>
	<20090423171151.GB11391@infradead.org>
In-Reply-To: <20090423171151.GB11391@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, Apr 21, 2009 at 03:13:30PM -0500, Eric Sandeen wrote:
>> I was experimenting w/ default lazy-count=1, and it broke a few tests.
>> Seems simplest to enforce lazy-count=0 in the common.log routines
>> for now, and fix up the output?  (vs. updating all the expected
>> output for these tests...)
> 
> Didn't you just send a patch to make lazy-count=1 the default? :)
> 
> I'd rather see either a filter dealing with both variants or make
> sure we always test the newer and more important case (lazy-count=1)
> here.

I don't think that a filter will be possible, it pretty fundamentally
changes log traffic doesn't it?  I could make 2 expected outputs,
perhaps, one for each...  I'll double check though.

I just made it forced to 0 because I don't think these tests are really
testing anything relevant to whether or not lazy-count is enabled...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
