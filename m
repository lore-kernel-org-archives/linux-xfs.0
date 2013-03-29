Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59CFC7F6D
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 19:38:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38747304048
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 17:38:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IsFfRPAit5aejgbo for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 17:38:50 -0700 (PDT)
Date: Fri, 29 Mar 2013 11:38:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix common rc file path in new
Message-ID: <20130329003847.GG6369@dastard>
References: <1364478683-6752-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364478683-6752-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 28, 2013 at 09:51:23PM +0800, Eryu Guan wrote:
> After the re-factor common.rc has been renamed to common/rc, fix the
> path in script new, otherwise ./new reports
> 
> ./new: line 26: ./common.rc: No such file or directory
> Building include
> Building lib
> Building ltp
> Building src
> Building m4
> ./new: line 70: BEGIN{printf "%03d\n",+1}: command not found
> Next test is
> Error: test  already exists!
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> After applying this patch, ./new generates new test starting from 001,
> so we have to maintain the seq number manually? Do we need an updated
> version of new? eg. takes an argument to specify the test type like
> 
> 	./new generic
> 
> and generates new test based on existing seq number in generic dir.

We could, but this all has to change when we allow non-numeric test
names.  i.e. the 'new' script is just creating a test template and
you can simply copy it to where ever you need with the appropriate
name. So just fixing the includes are appropriate right now, I
think...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
