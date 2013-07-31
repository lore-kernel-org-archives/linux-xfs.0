Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D32EB7F69
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 08:27:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CC19AC006
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 06:27:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130727015029.GT13468@dastard>
References: <51F2BD31.5060301@profihost.ag> <20130727015029.GT13468@dastard>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Wed, 31 Jul 2013 09:26:35 -0400
Message-ID: <CAGpXXZ+no_YcepmwMopFDYO_6PR6jOop9UpY_mAcaPbLA6CYkg@mail.gmail.com>
Subject: Re: [xfs-masters] how to use fstrim?
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
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe <s.priebe@profihost.ag>

On Fri, Jul 26, 2013 at 9:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> IOWs, the behaviour of fstrim on XFS is entirely dependent on the
> speed of the block layer and hardware implementations of discards.

And on a lot of SSDs, trim seems to act like a cache flush so it can
hit performance hard.  It should be scheduled for off-peak times
afaik.  It's not critical to run hourly or even daily.  If you can
schedule it once a week when other i/o is light that should be enough
for most workloads.

Greg
--
Greg Freemyer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
