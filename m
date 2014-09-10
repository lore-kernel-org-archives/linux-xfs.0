Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 91D5C7F5F
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 15:23:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7275B8F804C
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 13:23:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qP7qB2DX4S8RPAe7 for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 13:23:51 -0700 (PDT)
Date: Thu, 11 Sep 2014 06:23:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: lockdep warning when logging in with ssh
Message-ID: <20140910202348.GC27048@dastard>
References: <54109F93.9020206@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54109F93.9020206@redhat.com>
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
To: Prarit Bhargava <prarit@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>, xfs@oss.sgi.com

On Wed, Sep 10, 2014 at 02:59:31PM -0400, Prarit Bhargava wrote:
> I see this when I attempt to login via ssh.  I do not see it if I login on
> the serial console.  I recall seeing it earlier when chasing another patch but
> cannot recall the kernel version.

It's the shmem code that is broken - instantiating an inode while
holding the mmap_sem inverts lock orders all over the place,
especially in the security subsystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
