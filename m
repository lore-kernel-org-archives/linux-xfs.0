Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9C7Wcnd047110 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 02:32:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 213F714646A5
	for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 00:39:55 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	skSIA2EhZkFKusSk for <xfs@oss.sgi.com>;
	Wed, 12 Oct 2011 00:39:55 -0700 (PDT)
Date: Wed, 12 Oct 2011 03:32:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: split mapped writes vs direct I/O tests
	from 091
Message-ID: <20111012073232.GB5071@infradead.org>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
	<20111011224010.GG3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111011224010.GG3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 12, 2011 at 09:40:10AM +1100, Dave Chinner wrote:
> > +# creator
> > +owner=nathans@sgi.com
> 
> No point keeping an invalid email address as the owner of a new
> test.
> 
> FWIW, I'm considering removing this from the tests as the
> information is in the commit history, and the use of the field
> (emailing the owner when the automated test infrastructure SGI used
> 10 years ago failed) is no longer used...

We should really just kill it.  If anyone runs the test automated again
he should get the mails and/or cc the xfs lists.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
