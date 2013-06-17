Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBB787F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 06:13:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B370D304032
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 04:13:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EFxKGx2kWNCW7O0x for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 04:13:51 -0700 (PDT)
Date: Mon, 17 Jun 2013 21:13:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130617111347.GL29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
	<CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 06:57:14AM -0400, Mark Seger wrote:
> all - good conversation and again, thanks for digging into this.  The
> comment about me running on an older kernel seems to be the problem and by
> rerunning my test on precise/3.5.0-23-generic all seems to be operating
> correctly, so I guess that was it.

OK, good to know.

> However, the one thing that does jump out of this is that proc/fs/xsfstats
> and pcp were both showing many hundred MB/sec during tests that only ran
> for a few seconds, which is impossible so it still feels some like sort of
> accounting bug to me.  On the other hand if the fact that this was an older
> kernel, and newer kernels are fine, perhaps it's something just to note and
> not worry about.

How big is the write cache in your RAID array? If the log is the
only thing being written to, and it fits within the cache, then it
can easily push several hundred MB/s of write IO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
