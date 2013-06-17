Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5731629DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:39:59 -0500 (CDT)
Date: Mon, 17 Jun 2013 17:39:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to
	struct ctl_table
Message-ID: <20130617223958.GI20932@sgi.com>
References: <cover.1371177118.git.joe@perches.com>
	<1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
	<20130614052104.GX29338@dastard>
	<1371188006.31941.45.camel@joe-AO722>
	<20130614061807.GY29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130614061807.GY29338@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Perches <joe@perches.com>, Alex Elder <elder@kernel.org>, Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hey Fellas,

On Fri, Jun 14, 2013 at 04:18:07PM +1000, Dave Chinner wrote:
> On Thu, Jun 13, 2013 at 10:33:26PM -0700, Joe Perches wrote:
> > On Fri, 2013-06-14 at 15:21 +1000, Dave Chinner wrote:
> > > On Thu, Jun 13, 2013 at 07:37:50PM -0700, Joe Perches wrote:
> > > > This typedef is unnecessary and should just be removed.
> > > > 
> > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > 
> > > Looks fine, Joe.
> > > 
> > > Acked-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > How do you want us to handle this? Push it through the XFS tree or
> > > are you going to send it on up yourself?
> > 
> > Hi Dave.
> > 
> > I'd prefer you pick it up.
> > 
> > These are all pretty trivial patches, but Jiri
> > typically doesn't pick them up for months.
> > 
> > I expect I'll have to resend whatever maintainers
> > don't pick up in 6 months or so.
> 
> No worries, I'll add it to my current 3.11 patchset.

Applied it. No need to repost. Thanks Joe!

Reviewed-by: Ben Myers <bpm@sgi.com>

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
