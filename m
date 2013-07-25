Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 194AC7CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 23:15:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB36B8F8033
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 21:15:43 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	G6voSgvOxdnsF8Xm for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 21:15:42 -0700 (PDT)
Date: Thu, 25 Jul 2013 14:15:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
	fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130725041538.GH13468@dastard>
References: <20130712023930.GA6473@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130712023930.GA6473@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Jul 11, 2013 at 10:39:30PM -0400, Dave Jones wrote:
> Just saw this during boot after an unclean shutdown. It hung afterwards.
> 
> [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
> [   97.164646] ------------[ cut here ]------------

I just reproduced this by chance. I know exactly what I was doing
when it went bang, so I might be able to reduce it from scattergun
blast testing to be able to reproduce it on demand.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
