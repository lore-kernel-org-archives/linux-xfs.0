Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15HLUEZ056442 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 11:21:30 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C6tvqmDB4wx2LHys for
	<xfs@oss.sgi.com>; Sun, 05 Feb 2012 09:21:28 -0800 (PST)
Message-ID: <4F2EBA96.2070603@redhat.com>
Date: Sun, 05 Feb 2012 11:21:26 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com>
	<201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
	<4F2EB017.5090006@redhat.com>
	<201202051719.q15HJJme010040@helium.internal.tigress.co.uk>
In-Reply-To: <201202051719.q15HJJme010040@helium.internal.tigress.co.uk>
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
To: Ron Yorston <rmy@tigress.co.uk>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 2/5/12 11:19 AM, Ron Yorston wrote:
> OK, I tried it out for my use case of flinging VM filesystem images around
> on ext4 and it seems to do the job.  I don't have any 64-bit systems
> here at home so I used my feeble 32-bit netbook.  Since sizeof(off_t) !=
> sizeof(long long) the debug output was all wrong:
> 
>    punching at 8989607068975104 len -4635819229210214401

whoops, I'll fix that thanks.

This is the problem when I start something as a hack and then expose it
to the light of day.  ;)

-Eric

> but the image file and the host filesystem both survived the ordeal.
> 
> Ron

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
