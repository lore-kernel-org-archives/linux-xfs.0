Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD6DD7F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 00:43:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7211DAC003
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 22:43:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oNjQgqxDc61Nis59 for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 22:43:13 -0700 (PDT)
Date: Wed, 6 May 2015 15:43:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] percpu_counter: batch size aware
	__percpu_counter_compare()
Message-ID: <20150506054310.GA4327@dastard>
References: <1430863299-9341-1-git-send-email-david@fromorbit.com>
	<1430863299-9341-2-git-send-email-david@fromorbit.com>
	<20150506043636.GA10940@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150506043636.GA10940@infradead.org>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, May 05, 2015 at 09:36:36PM -0700, Christoph Hellwig wrote:
> This looks reasonable, but I miss Ccs to the authors of the
> percpu_counter code and linux-kernel.

linux-kernel was cc'd.

> On Wed, May 06, 2015 at 08:01:38AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> 
> And this looks wrong, too :)

That looks like a change of tool behaviour. I just upgraded guilt;
the old version stripped "from" lines in patch descriptions from the
git commit log as goes into the author field of the commit. The new
version does not appear to strip the from lines, and so when
git-send-email formats it, it puts a from line in the message, and
then the commit message has one too.

Thanks for pointing it out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
