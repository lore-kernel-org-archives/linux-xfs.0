Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB22Ja0P246609 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 20:19:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CD4A1BAC59
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:21:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	rAc5VXRMhTeuidCo for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:21:18 -0800 (PST)
Date: Thu, 2 Dec 2010 13:21:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests 065 failures
Message-ID: <20101202022116.GW16922@dastard>
References: <1291235379.2556.28.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291235379.2556.28.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>, dchinner@redhat.com

On Wed, Dec 01, 2010 at 02:29:39PM -0600, Alex Elder wrote:
> Dave, you were asking on IRC about test 065 failures.
> I asked Bill Kendall about it and he bisected to find
> that the commit below seems to be where the problems
> started.  I believe the problem is that one of the
> times is not updated properly when renaming the file
> "addedfile4".  Here are the commands that might affect
> that file in test 065:
> 
> 	mv addeddir4/addedfile5 addeddir4/addedfile4
> 	mv addeddir4 addeddir6
> 
> I glanced at the commit and saw nothing obviously
> wrong, but at the moment I can't really dig into
> it any deeper so I thought I'd report what Bill
> found so others could look.

Yeah, I know that this patch was the cause, and IIRC it only affects
a hard linked directory. What I found is that the iterative dump
actually contains all the correct changes (the restore part of the
test does not fail) - it's just that the dump image table of
contents does not contain the all the changes. I haven't tracked
down why the dump TOC does not contain a modification that is
actually in the dump yet....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
