Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BNuFgw152870 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 18:56:15 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	to9XcycVBQitco23 for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 16:56:14 -0700 (PDT)
Date: Tue, 12 Jun 2012 09:56:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: block sizes > 4K ??  possible w/large page support?
Message-ID: <20120611235612.GF22848@dastard>
References: <4FD5643F.5070801@tlinx.org>
	<20120611132932.GA18432@andromeda.usersys.redhat.com>
	<4FD606C1.1070103@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD606C1.1070103@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2012 at 09:54:57AM -0500, Stan Hoeppner wrote:
> On 6/11/2012 8:29 AM, Carlos Maiolino wrote:
> 
> > The maximum block size of a XFS filesystem is 64kiB. But in linux it's limited
> > to the PAGE_SIZE value. 
> 
> Correct.
> 
> > so, on x86 architectures, the maximum block size is
> > 4kiB.
> 
> Not entirely correct.  Since ~1996, 16 years ago, PPro and higher 32bit
> CPUs with PSE/PSE36 support pages of 4MB, or 2MB with PAE enabled.
> 
> x86-64 CPUs in long mode also support a 2MB page size.  But the problem
> of internal fragmentation may outweigh the TLB and other benefits of
> these very large pages.  I'm not an MM dev so I can't elaborate further.
>  There may be other issues.
> 
> > although it could benefit from a 16kiB page size, you'll need to be running an
> > operating system which supports this page size value.
> 
> And AFAIK the kernel MM team doesn't have x86 2MB pages on their radar.
>  Or do they?

Been supported for a few of years now in one form or another.
google for "transparent huge pages".....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
