Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBipLw111102 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:44:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01B9755F0
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:45:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	YijVi38FZALWXJsJ for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:45:19 -0700 (PDT)
Date: Wed, 18 Aug 2010 21:45:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 241: run parallel dbench
Message-ID: <20100818114507.GS10429@dastard>
References: <4C6AE57D.7090807@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C6AE57D.7090807@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 17, 2010 at 02:39:41PM -0500, Eric Sandeen wrote:
> ext4 was corrupting inode table bitmaps due to a mishmash of
> atomic & nonatomic bitops.  This got broken twice and fixed
> twice; let's add a test.
> 
> On a 4-way box this reliably ends up with a corrupted filesystem
> if we get it wrong (upstream as of 2.6.35 at least is fine again)
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good, except it's missing a 241.out file for the golden
output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
