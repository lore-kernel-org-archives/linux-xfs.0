Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9EE217CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 17:49:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 881E28F8033
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 15:49:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vMFTsOJaMgWGh2UF for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 15:49:39 -0700 (PDT)
Date: Sat, 27 Apr 2013 08:49:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests 311: test fsync with dm flakey V2
Message-ID: <20130426224937.GA23072@dastard>
References: <1366899176-12876-1-git-send-email-jbacik@fusionio.com>
	<20130425224556.GS30622@dastard>
	<20130426002404.GN2631@localhost.localdomain>
	<20130426010829.GV30622@dastard>
	<20130426013237.GO2631@localhost.localdomain>
	<20130426021214.GX30622@dastard>
	<20130426193101.GR2631@localhost.localdomain>
	<20130426220521.GC30622@dastard>
	<20130426223214.GA4117@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130426223214.GA4117@localhost.localdomain>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 26, 2013 at 06:32:14PM -0400, Josef Bacik wrote:
> On Fri, Apr 26, 2013 at 04:05:22PM -0600, Dave Chinner wrote:
> > On Fri, Apr 26, 2013 at 03:31:01PM -0400, Josef Bacik wrote:
> > > On Thu, Apr 25, 2013 at 08:12:14PM -0600, Dave Chinner wrote:
> > > > > Ok so I think I'll just make this test do all the iterations of the fsync tester
> > > > > with and without --nolockfs, since without --nolockfs I'm still seeing problems,
> > > > > does that sound reasonable?
> > > > 
> > > > Sounds like a fine plan to me ;)
> > > > 
> > > 
> > > Btw its test 19 O_DIRECT that gives me a 0 length file, the buffered case is
> > > fine.  The test just does a randomly sized sub-block sized write over and over
> > > again for a random number of times and fsync()'s in there randomly.  The number
> > > is 3072 because that's the largest inline extent we can have in btrfs, I added
> > > it specifically to test our inline extent logging.  Thanks,
> > 
> > Interesting - it only runs fsync every 8 iterations of the loop. Can
> > you check that it is running enough loops to execute a fsync?
> > 
> 
> If the loop doesn't fsync it still fsyncs before the program exits.

Doh! I noticed that yesterday but forgot about it. Not enough
coffee. I'll have a closer look, then.

> Side note I once wasted a week because Chris's fsync tester
> _didn't_ fsync() before exit so it would tell you a md5sum of a
> file that hadn't fsync()ed before the md5sum and I just assumed
> btrfs was broken.  This test does not make this mistake for that
> reason :).  Thanks,

I think we've all made mistakes like that at least once.... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
