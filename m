Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9EC2F7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:24:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 84E2C8F804B
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:24:58 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BOLS9affOiFUQE8U for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 13:24:55 -0800 (PST)
Date: Wed, 13 Jan 2016 08:24:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160112212454.GM10456@dastard>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112195945.GC568@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 08:59:45PM +0100, Felix Janda wrote:
> ustat has been used to check whether a device file is mounted.
> The function is deprecated and not supported by uclibc and musl.
> Now do the check using the *mntent functions.

Which will cause problems with builds on other platforms. Why not
just use statfs() instead?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
