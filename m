Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3D3A7FD4
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 05:16:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 94FEB8F8049
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 03:16:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jkmC9DUXUFrMi21F for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 03:16:27 -0700 (PDT)
Date: Fri, 15 Mar 2013 21:16:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3 V4] xfstests: btrfs tests for basic informational
	commands
Message-ID: <20130315101625.GE6369@dastard>
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<1363186623-1378-4-git-send-email-sandeen@redhat.com>
	<5140AB9D.2070001@redhat.com> <5140CB3F.5010704@redhat.com>
	<5140CD26.7050201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5140CD26.7050201@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 13, 2013 at 02:01:58PM -0500, Eric Sandeen wrote:
> Run basic btrfs information commands in various ways, performing
> sanity tests of: filesystem show, label, sync, and device stats
> (sync is included just because it's simple).  These are mostly
> just smoke tests, although for example show by label & UUID
> should verify that the correct fs was shown.
> 
> This also adds quite a few new filters to accommodate the output
> of the new commands.
> 
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: sort & uniq device stats output to account for variable
> nrs. of devices.  Optionally check that the proper nr. of
> devices was returned, as well.
> 
> V3: _filter_uuid needs to pay attention to $1, not hope
> that the caller has set $UUID.  Oops.
> 
> V4: fix stats filter to set UNIQ_OPT in both cases, ugh.

Something I just noticed in this commit:

> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./btrfs.filter

That should probably have been named "common.filter.btrfs".
I found this updating my patchset that moves all the common.* files
into a common/ directory....

I'll rename it to common/filter.btrfs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
