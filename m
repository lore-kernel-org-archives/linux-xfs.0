Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RIG5gj131744 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 13:16:06 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7198A13569D2
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 11:16:05 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id bIpS1U0PS0IZTihH for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2011 11:16:05 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5RICxrZ025335
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 12:12:59 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5RIFbg3167834 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 12:15:38 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5RIFaOa003271
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 12:15:37 -0600
Message-ID: <4E08C8BE.7090500@linux.vnet.ibm.com>
Date: Mon, 27 Jun 2011 11:15:26 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfstests: fix fsx fpunch test to actually test for
	fpunch
References: <1309153722-1231-1-git-send-email-david@fromorbit.com>
	<1309153722-1231-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1309153722-1231-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/26/2011 10:48 PM, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The operation flags parameter to fallocate is the second parameter,
> not the last. Hence the fpunch test is actually testing for falloc
> support, not fpunch. Somebody needs a brown paper bag.
>
> Also, add a ftruncate call whenthe fpunch succeeds just in case the
> file was not already zero sized. Failing to ensure we start with a
> zero length file can cause read ops to fail size checks if they
> occur before the file is written to be the main test loop.
>
> While there, observe the quiet flag the same as the falloc test
> does and have them both emit the warning at the same error level.

Hi there,

Sorry about that, I think this bug was mine.  I have tried your patch 
set on my box, and it appears to run with out problems for me. Thx!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
