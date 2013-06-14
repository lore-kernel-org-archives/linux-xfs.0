Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 622FF7CBF
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 00:33:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C91B304043
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 22:33:28 -0700 (PDT)
Received: from labridge.com (perches-mx.perches.com [206.117.179.246]) by
	cuda.sgi.com with ESMTP id oVAwHBEIe2NvcFPn (version=SSLv3
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 22:33:27 -0700 (PDT)
Message-ID: <1371188006.31941.45.camel@joe-AO722>
Subject: Re: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to
	struct ctl_table
From: Joe Perches <joe@perches.com>
Date: Thu, 13 Jun 2013 22:33:26 -0700
In-Reply-To: <20130614052104.GX29338@dastard>
References: <cover.1371177118.git.joe@perches.com>
	<1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
	<20130614052104.GX29338@dastard>
Mime-Version: 1.0
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
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 2013-06-14 at 15:21 +1000, Dave Chinner wrote:
> On Thu, Jun 13, 2013 at 07:37:50PM -0700, Joe Perches wrote:
> > This typedef is unnecessary and should just be removed.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Looks fine, Joe.
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>
> 
> How do you want us to handle this? Push it through the XFS tree or
> are you going to send it on up yourself?

Hi Dave.

I'd prefer you pick it up.

These are all pretty trivial patches, but Jiri
typically doesn't pick them up for months.

I expect I'll have to resend whatever maintainers
don't pick up in 6 months or so.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
