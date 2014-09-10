Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF2D87F61
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 17:40:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ADFDA8F8049
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 15:40:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QYRgJzIJjwzVJVRD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 15:40:25 -0700 (PDT)
Message-ID: <5410D34F.1030404@redhat.com>
Date: Wed, 10 Sep 2014 18:40:15 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
Subject: Re: lockdep warning when logging in with ssh
References: <54109F93.9020206@redhat.com> <20140910202348.GC27048@dastard>
In-Reply-To: <20140910202348.GC27048@dastard>
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
Cc: Eric Sandeen <esandeen@redhat.com>, xfs@oss.sgi.com



On 09/10/2014 04:23 PM, Dave Chinner wrote:
> On Wed, Sep 10, 2014 at 02:59:31PM -0400, Prarit Bhargava wrote:
>> I see this when I attempt to login via ssh.  I do not see it if I login on
>> the serial console.  I recall seeing it earlier when chasing another patch but
>> cannot recall the kernel version.
> 
> It's the shmem code that is broken - instantiating an inode while
> holding the mmap_sem inverts lock orders all over the place,
> especially in the security subsystem....
> 

I'll send this off to Hugh Dickens then.

P.

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
