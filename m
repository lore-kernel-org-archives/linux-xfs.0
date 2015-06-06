Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE2047F61
	for <xfs@oss.sgi.com>; Sat,  6 Jun 2015 17:32:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 487D6AC002
	for <xfs@oss.sgi.com>; Sat,  6 Jun 2015 15:32:11 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VnCkriugkHyc9eZU for <xfs@oss.sgi.com>;
	Sat, 06 Jun 2015 15:32:04 -0700 (PDT)
Date: Sun, 7 Jun 2015 08:32:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix in the setting of logbsize
Message-ID: <20150606223200.GZ24666@dastard>
References: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
	<20150605222257.GY24666@dastard> <55722AD9.2080105@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55722AD9.2080105@sandeen.net>
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
Cc: Ales Novak <alnovak@suse.cz>, xfs@oss.sgi.com

On Fri, Jun 05, 2015 at 06:03:53PM -0500, Eric Sandeen wrote:
> On 6/5/15 5:22 PM, Dave Chinner wrote:
> 
> > On Fri, Jun 05, 2015 at 03:28:45PM +0200, Ales Novak wrote:
> >> However, this rule is only mentioned in the documentation, while it
> >> could be checked during the mount.
> > 
> > Where in the documentation is that mentioned?
> 
> Documentation/filesystems/xfs.txt:
> 
>   logbsize=value
>         Set the size of each in-memory log buffer.  The size may be
>         specified in bytes, or in kilobytes with a "k" suffix.
>         Valid sizes for version 1 and version 2 logs are 16384 (16k)
>         and 32768 (32k).  Valid sizes for version 2 logs also
>         include 65536 (64k), 131072 (128k) and 262144 (256k). The
>         logbsize must be an integer multiple of the log
>         stripe unit configured at mkfs time.

Ah, ok. I'll need to look at the history of that, because I think I
can see what it is intended to mean, but the "power-of-two" sizes
that are enforced will also enforce the "integer multiple" part,
too. I think it was more intended for people using wierd stripe
units (e.g. 96k) to say the equivalent on 2x96k is a valid log
buffer size. I suspect we need to revisit both the code and the
documentation here....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
