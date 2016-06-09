Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D218A7CA3
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 12:19:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CC5AAC001
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 10:19:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gTLl2rD6hj2HWpEn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 10:19:02 -0700 (PDT)
Date: Thu, 9 Jun 2016 13:18:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfsaild 20 wakeups per second
Message-ID: <20160609171857.GA9052@laptop.bfoster>
References: <ufaeg86e2jk.fsf@epithumia.math.uh.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ufaeg86e2jk.fsf@epithumia.math.uh.edu>
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
To: Jason L Tibbitts III <tibbs@math.uh.edu>
Cc: xfs@oss.sgi.com

On Thu, Jun 09, 2016 at 11:43:11AM -0500, Jason L Tibbitts III wrote:
> I was tuning the power consumption of my new laptop and noticed that
> each xfsaild process is still waking up 20 times per second.  I found
> http://oss.sgi.com/archives/xfs/2012-03/msg00237.html which I think
> indicates that this was a workaround for some other issue and wouldn't
> be permanent.  Unfortunately that was 4+ years ago.  I wasn't able to
> locate any other discussion about the topic.
> 
> Was it determined that the wakeups were going to have to stay
> permanently?  Or was the issue just not revisited?  And if the former,
> is there a way to tune the wakeup frequency in any way?
> 

The short answer is that the wakeups are probably going to be around for
the immediate future. There was some recent discussion on this here (see
the follow up thread to the patch):

  http://oss.sgi.com/pipermail/xfs/2016-April/048526.html

Brian

>  - J<
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
