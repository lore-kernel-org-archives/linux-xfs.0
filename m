Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E06A7F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 00:53:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61C698F8081
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 22:53:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fUP9Dn6NV47OJT4M for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 22:53:51 -0700 (PDT)
Date: Wed, 6 May 2015 15:53:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] percpu_counter: batch size aware
	__percpu_counter_compare()
Message-ID: <20150506055349.GC4327@dastard>
References: <1430863299-9341-1-git-send-email-david@fromorbit.com>
	<1430863299-9341-2-git-send-email-david@fromorbit.com>
	<20150506043636.GA10940@infradead.org>
	<20150506054310.GA4327@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150506054310.GA4327@dastard>
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

On Wed, May 06, 2015 at 03:43:10PM +1000, Dave Chinner wrote:
> On Tue, May 05, 2015 at 09:36:36PM -0700, Christoph Hellwig wrote:
> > This looks reasonable, but I miss Ccs to the authors of the
> > percpu_counter code and linux-kernel.
> 
> linux-kernel was cc'd.
> 
> > On Wed, May 06, 2015 at 08:01:38AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > 
> > And this looks wrong, too :)
> 
> That looks like a change of tool behaviour. I just upgraded guilt;
> the old version stripped "from" lines in patch descriptions from the
> git commit log as goes into the author field of the commit. The new
> version does not appear to strip the from lines, and so when
> git-send-email formats it, it puts a from line in the message, and
> then the commit message has one too.

Ok, so I remembered it the wrong way around, but it is a tool bug:

$ guilt patchbomb -s d480578..cd83c77
cd83c773 xfs: inode counter needs to use __percpu_counter_compare
1e41b5ad percpu_counter: batch size aware __percpu_counter_compare()
Are these what you want to send? [Y/n]
....

Note the use of "-s". from the man page:

       -s
	   Don't add additional repository committer sign-offs to
	   the patch.  This allows the sign-off chain to be fully
	   expressed in the commit messages and not changed by the
	   act of sending a patchbomb.

It would appear that the "-s" option is not working properly. I'll
fix that before sending the next round of patches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
