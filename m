Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E4C77CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 17:32:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 403798F8035
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 15:32:19 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id N9ZK21NV9lfiGBty (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 15:32:18 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 984579A04FA
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 16:32:17 -0600 (MDT)
Date: Fri, 26 Apr 2013 18:32:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests 311: test fsync with dm flakey V2
Message-ID: <20130426223214.GA4117@localhost.localdomain>
References: <1366899176-12876-1-git-send-email-jbacik@fusionio.com>
	<20130425224556.GS30622@dastard>
	<20130426002404.GN2631@localhost.localdomain>
	<20130426010829.GV30622@dastard>
	<20130426013237.GO2631@localhost.localdomain>
	<20130426021214.GX30622@dastard>
	<20130426193101.GR2631@localhost.localdomain>
	<20130426220521.GC30622@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130426220521.GC30622@dastard>
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
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Josef Bacik <JBacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 26, 2013 at 04:05:22PM -0600, Dave Chinner wrote:
> On Fri, Apr 26, 2013 at 03:31:01PM -0400, Josef Bacik wrote:
> > On Thu, Apr 25, 2013 at 08:12:14PM -0600, Dave Chinner wrote:
> > > > Ok so I think I'll just make this test do all the iterations of the fsync tester
> > > > with and without --nolockfs, since without --nolockfs I'm still seeing problems,
> > > > does that sound reasonable?
> > > 
> > > Sounds like a fine plan to me ;)
> > > 
> > 
> > Btw its test 19 O_DIRECT that gives me a 0 length file, the buffered case is
> > fine.  The test just does a randomly sized sub-block sized write over and over
> > again for a random number of times and fsync()'s in there randomly.  The number
> > is 3072 because that's the largest inline extent we can have in btrfs, I added
> > it specifically to test our inline extent logging.  Thanks,
> 
> Interesting - it only runs fsync every 8 iterations of the loop. Can
> you check that it is running enough loops to execute a fsync?
> 

If the loop doesn't fsync it still fsyncs before the program exits.  Side note I
once wasted a week because Chris's fsync tester _didn't_ fsync() before exit so
it would tell you a md5sum of a file that hadn't fsync()ed before the md5sum and
I just assumed btrfs was broken.  This test does not make this mistake for that
reason :).  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
