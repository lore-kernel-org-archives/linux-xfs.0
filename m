Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C81C7F37
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 19:44:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 495B38F8059
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 17:44:40 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	S8Vzhzieb3ry8rd8 for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 17:44:09 -0700 (PDT)
Date: Wed, 20 Mar 2013 11:44:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Crash with 3.8.3 and TuxOnIce
Message-ID: <20130320004405.GC17758@dastard>
References: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
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
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 19, 2013 at 11:31:16PM +0000, Pedro Ribeiro wrote:
> Hi,
> 
> I'm using a TuxOnIce enabled kernel, and recently moved from 3.7.1 to
> 3.8.3. The former used to work nicely, but now I get a hard crash when I
> try to hibernate.
> This is solely related to TuxOnIce as it does not happen in the default
> hibernation.
> 
> I know this is an unsupported out of tree patch, but can you please help me
> debug it or point in the right direction?
> 
> Unfortunately as this was a kernel crash all I have are crappy photos, but
> they do show a readable stack trace:
> img18[dot]imageshack[dot]us/img18/395/imag0228hp[dot]jpg
> img13[dot]imageshack[dot]us/img13/4375/imag0231p[dot]jpg
> 
> (I removed the HTTP part and the dots off the links else it would bounce
> back from the list)

The list doesn't bounce URLs. Please make then clicky in future.

As it is, your kernel has oopsed in submit_bio() when writing a log
buffer writing a dummy log record.

The xfs_log_worker is trying to cover the log, and it seems like the
IO subsystem below it is doing something wrong. Perhaps Tux-on-Ice
is killing the IO subsystem without having first stopped all the
async filesystem processing first?

Looks like a Tux-on-ICE problem to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
