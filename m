Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B8F67CA2
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 19:05:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33EF5AC019
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 17:05:44 -0700 (PDT)
Date: Sat, 4 Jun 2016 10:04:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING
	fs/xfs/xfs_aops.c:1232 xfs_vm_releasepage
Message-ID: <20160604000449.GU26977@dastard>
References: <20160511133417.GA42410@bfoster.bfoster>
	<57333BA4.4040402@profihost.ag>
	<20160511155951.GF42410@bfoster.bfoster>
	<5738576B.4010208@profihost.ag>
	<20160515115017.GA6433@laptop.bfoster>
	<57386E84.3090606@profihost.ag>
	<20160516010602.GA24980@bfoster.bfoster>
	<57420A47.2000700@profihost.ag> <20160522213850.GE26977@dastard>
	<5751C4B8.2080301@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5751C4B8.2080301@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jun 03, 2016 at 07:56:08PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> should i remove the complete if conditions incl. the return 0 or should
> id convert it to if without WARN_ONCE? like below?
> 
>         if (WARN_ON_ONCE(delalloc))
>                 return 0;
>         if (WARN_ON_ONCE(unwritten))
>                 return 0;
> 
> =>
> 
>   if (delalloc)
>     return 0;
>   if (unwritten)
>     return 0;

Yes, you need to keep the checks and returns. That's what I meant
when I said that "XFS handles the dirty page case correctly in this
case". If the page is dirty, we should not be attempting to release
the buffers, and that is what the code does. It's just noisy about
it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
