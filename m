Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD59B7F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 17:03:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61A64AC002
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 15:03:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2vUvoGjbCEkZUEWx for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 15:03:49 -0700 (PDT)
Date: Thu, 26 Jun 2014 08:03:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata CRC error upon unclean unmount
Message-ID: <20140625220336.GN9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
	<CA+o=1OXY8Ay8CSgsdiAOTacBa9800FiMKGbr0DdkE_YVpewqBw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OXY8Ay8CSgsdiAOTacBa9800FiMKGbr0DdkE_YVpewqBw@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 25, 2014 at 06:09:07PM +0200, Fanael Linithien wrote:
> First try, and something is wrong already.
> 
> Dmesg: https://clbin.com/e8HwM
> Pre-mount metadata: https://clbin.com/0thyz
> Post-mount metadata: https://clbin.com/WTIuF

Ok, that's the log crc error, which is likely a different problem
(probably an incomplete write due to the VM being terminated).  I'll
concentrate on that one after the one originally reported in this
thread.

Can you try to reproduce the AGI or AGF/freespace corruption issue
and post the results?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
