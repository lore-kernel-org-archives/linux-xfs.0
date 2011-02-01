Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11NkWFL252052 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 17:46:32 -0600
Subject: Re: [PATCH] Xfstests: make 014 only run on xfs
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110127005945.GE21311@dastard>
References: <1296050729-17316-1-git-send-email-josef@redhat.com>
	<20110127005945.GE21311@dastard>
Date: Tue, 01 Feb 2011 17:48:57 -0600
Message-ID: <1296604137.2350.138.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com

On Thu, 2011-01-27 at 11:59 +1100, Dave Chinner wrote:
> On Wed, Jan 26, 2011 at 09:05:29AM -0500, Josef Bacik wrote:
> > This test relies on mounting with -o allocsize, which is an xfs specific mount
> > option, so make the test only work on xfs.  Thanks,
> 
> Oh, sorry, my fault. Perhaps something like this instead?

Since test 014 reportedly works on other filesystem
types provided the allocsize option isn't provided,
Dave's version looks better.

Josef will you please take a look over--and preferably
test--what Dave proposed, and if you agree offer your
signoff?

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
