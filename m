Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF3F77F52
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 18:04:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D2D88F8040
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 16:04:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2aHCsModGu6UdJw3 for <xfs@oss.sgi.com>;
	Sat, 17 Oct 2015 16:04:39 -0700 (PDT)
Date: Sun, 18 Oct 2015 10:02:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-dev: Richacl support
Message-ID: <20151017230224.GU27164@dastard>
References: <CAHc6FU65zy+rDCWapURLr-cApi7b40OhfB7bQK0iC0r_6Wn_qg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU65zy+rDCWapURLr-cApi7b40OhfB7bQK0iC0r_6Wn_qg@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 16, 2015 at 05:44:42PM +0200, Andreas Gruenbacher wrote:
> Hello,
> 
> could the richacl feature flag please be added to xfsprogs so that we
> won't end up with incompatible file systems?
> 
>   https://github.com/andreas-gruenbacher/xfsprogs-dev

Can you post patches so we can review them in the normal manner?

> Also, should this really be an incompatible feature flag? Mounting a
> richacl filesystem on a kernel without richacl support would otherwise
> work but it could grant unwanted access to files.

You answered that question yourself here: :)

http://oss.sgi.com/archives/xfs/2015-10/msg00357.html

i.e. INCOMPAT is fine, becuse RO_INCOMPAT results in unpredictable and
incompatible behaviour from the user perspective...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
