Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAKFWQne168892 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 09:32:26 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C44418B24BF
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 07:32:49 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ExcloCavemg2RVSy for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2009 07:32:49 -0800 (PST)
Message-ID: <4B06B6A0.3030908@sandeen.net>
Date: Fri, 20 Nov 2009 09:32:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: make several more functions static
References: <4B0569A0.10405@sandeen.net>
	<20091120063720.GA3804@discord.disaster>
In-Reply-To: <20091120063720.GA3804@discord.disaster>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Nov 19, 2009 at 09:52:00AM -0600, Eric Sandeen wrote:
>> Just minor housekeeping, a lot more functions can be trivially
>> made static; others could if we reordered things a bit...
> 
> Only one minor comment:
> 
>> -void
>> +STATIC_INLINE void
>>  xlog_put_bp(
>>  	xfs_buf_t	*bp)
>>  {
> 
> I'd change that as STATIC as Christoph's recent patch removed
> STATIC_INLINE. gcc will inline it for us if it's a win....

Oops, ok, thanks for looking at it.

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
