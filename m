Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GHwSii049590 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 12:58:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4607DC959F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 10:58:27 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AEs06z4b7Im2CP1P for <xfs@oss.sgi.com>;
	Thu, 16 Jun 2011 10:58:27 -0700 (PDT)
Date: Thu, 16 Jun 2011 13:58:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]: [xfstests] test 032: Run mkfs.xfs only if the prior
	mkfs.${fs} succeded
Message-ID: <20110616175823.GB20570@infradead.org>
References: <1308243671.5505.4.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1308243671.5505.4.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>, XFS Mailing List <xfs@oss.sgi.com>

On Thu, Jun 16, 2011 at 10:01:11AM -0700, Chandra Seetharaman wrote:
> This test fails when mkfs of a different filesystem fails, which is not
> a failure case for this specific test.
> 
> Hence, change the test to run mkfs.xfs only if the prior mkfs.${fs} on 
> different filesystem succeded.
> 
> Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good, I'll put it in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
