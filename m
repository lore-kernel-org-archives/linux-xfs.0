Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 786A27F77
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 14:46:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 573228F8070
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 12:46:53 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	P24MUz2k38lVpzWp for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 12:46:51 -0800 (PST)
Date: Tue, 5 Nov 2013 07:46:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to use increased number of ACL entries?
Message-ID: <20131104204647.GO6188@dastard>
References: <20131103081704.GE9974@fit.vutbr.cz>
	<20131104003915.GN6188@dastard> <5277086E.6030905@sandeen.net>
	<52771FFE.8030009@gmail.com> <5277AE19.0@sandeen.net>
	<20131104151050.GS9974@fit.vutbr.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131104151050.GS9974@fit.vutbr.cz>
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
To: Kasparek Tomas <kasparek@fit.vutbr.cz>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Nov 04, 2013 at 04:10:50PM +0100, Kasparek Tomas wrote:
> On Mon, Nov 04, 2013 at 08:24:25AM -0600, Eric Sandeen wrote:
> > > However, it should be dirent (ftype=1 in the above output) that keeps a 
> > > vanilla 3.10.17 kernel from mounting the resulting filesystem:
> > 
> > I'm sorry, you are right - it hit kernel v3.11:
> > 
> > 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57 xfs: increase number of ACL entries for V5 superblocks
> > 
> > $ git describe --contains 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57
> > v3.11-rc1~18^2~41
> 
> And get to stable 3.10 later.
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=0a8aa1939777dd114479677f0044652c1fd72398

No, that never went into the 3.10 stable tree, and nor should it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
