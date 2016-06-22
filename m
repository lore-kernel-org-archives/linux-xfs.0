Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 039D27CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 17:51:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AEB688F8033
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 15:51:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Bd1YE2oCSHou6AB0 for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2016 15:51:18 -0700 (PDT)
Date: Thu, 23 Jun 2016 08:51:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs metadata overhead
Message-ID: <20160622225117.GX12670@dastard>
References: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
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
To: Danny Shavit <danny@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 22, 2016 at 06:58:16PM +0300, Danny Shavit wrote:
> Hi,
> 
> We are looking for a method to estimate the size of metadata overhead for a
> given file system.
> We would like to use this value as indicator for the amount of cache memory
> a system for faster operation.
> Are there any counters that are maintained in the on-disk data
> structures like free space for examples?

No.

Right now, you'll need to take a metadump of the filesystem to
measure it. The size of the dump file will be a close indication of
the amount of metadata in the filesystem as it only contains
the filesystem metadata.

In future, querying the rmap will enable us to calculate it on the
fly, (i.e. not requiring the filesystem to be snapshotted/taken off
line to do a metadump).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
