Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDD2B7F4E
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2014 18:57:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B898E8F8033
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2014 16:57:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bU3WbVO2cDB7Fzhb for <xfs@oss.sgi.com>;
	Sun, 06 Jul 2014 16:57:33 -0700 (PDT)
Date: Mon, 7 Jul 2014 09:57:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Data loss XFS with RT kernel on Debian.
Message-ID: <20140706235701.GQ9508@dastard>
References: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
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
To: Jan de Kruyf <jan.de.kruyf@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 05, 2014 at 02:41:06PM +0200, Jan de Kruyf wrote:
> Hallo,
> 
> While doing a reasonably high density job like rsynching a subdirectory
> from one place to another, or tarring it to a pipe and untarring it at the
> other end, I note that the cpu usage goes practically to 100% and when I
> after 5 minutes or so I reset the computer the writing has not finished at
> all.
> However on the stock Debian kernel it works without a problem.

Which says that it's a RT kernel problem, not an XFS issue. There
have been other recent reports of issues with RT kernels, and they
have proven to be core RT kernel bugs, not filesystem issues. I'd
suggest that you are likely to be seeing the same RT issues....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
