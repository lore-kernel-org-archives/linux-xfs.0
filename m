Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 810137F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 21:04:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10F55AC002
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 19:04:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	snGoJPPM4RMheRGd for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 19:04:17 -0700 (PDT)
Date: Sat, 15 Jun 2013 12:04:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130615020414.GB29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

On Fri, Jun 14, 2013 at 09:55:17PM -0400, Mark Seger wrote:
> I'm doing 1 second samples and the rates are very steady.  The reason I
> ended up at this level of testing was I had done a sustained test for 2
> minutes at about 5MB/sec and was seeing over 500MB/sec going to the disk,
> again sampling at 1-second intervals.  I'd be happy to provide detailed
> output and can even sample more frequently if you like.

Where are you getting your IO throughput numbers from?

How do they compare to, say, the output of `iostat -d -x -m 1`?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
