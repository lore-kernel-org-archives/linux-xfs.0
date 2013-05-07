Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C993529DF8
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 20:13:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C4A7B8F8037
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 18:13:00 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Pg4MYqcWwikPhtNr for <linux-xfs@oss.sgi.com>;
	Mon, 06 May 2013 18:12:56 -0700 (PDT)
Date: Tue, 7 May 2013 11:12:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: general protection fault
Message-ID: <20130507011254.GP19978@dastard>
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5187A663.707@itwm.fraunhofer.de>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-xfs@oss.sgi.com

On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
> On 05/06/2013 02:28 PM, Dave Chinner wrote:
> >On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
> >>And anpther protection fault, this time with 3.9.0. Always happens
> >>on one of the servers. Its ECC memory, so I don't suspect a faulty
> >>memory bank. Going to fsck now-
> >
> >http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> Isn't that a bit overhead? And I can't provide /proc/meminfo and
> others, as this issue causes a kernel panic a few traces later.

Provide what information you can.  Without knowing a single thing
about your hardware, storage config and workload, I can't help you
at all. You're asking me to find a needle in a haystack blindfolded
and with both hands tied behind my back....

Stuff like /proc/meminfo doesn't have to be provided from exactly
the time of the crash - it's just the simplest way to find out how
much RAM you have in the machine, so a dump from whenever the
machine is up and running the workload is fine. Other information we
ask for (e.g. capturing the output of `vmstat 5` as suggested in the
FAQ) gives us the runtime variation of memory usage and easy to
capture right up to the failure point....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
