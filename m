Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CC2581008811 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 06:02:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9279914480C
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 04:03:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	0lOBFxibVrBEz8vY for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2010 04:03:00 -0800 (PST)
Date: Tue, 12 Jan 2010 23:02:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfstests: test quota log replay in 087
Message-ID: <20100112120256.GD17483@discord.disaster>
References: <20100110212619.GA30907@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100110212619.GA30907@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Jan 10, 2010 at 04:26:19PM -0500, Christoph Hellwig wrote:
> By mounting the filesystem with quotas enabled in 087 we exercise the
> replay of the quota log items in this tests, which we otherwise don't
> test in xfstests.  OSS bugzilla #855 is an example of something caught
> by this.
> 
> Does this look okay, or should I add a duplicate of 
> 087 with quotas enabled instead?

I think having 087 cover quotas as well is fine. Adding a separate
test just for quotas doesn't provide any extra coverage compared to
this patch.


> @@ -98,7 +100,7 @@ do
>  
>      # mount the FS
>      _echofull "mount"
> -    if ! _scratch_mount >>$seq.full 2>&1; then
> +    if ! _scratch_mount -o uquota >>$seq.full 2>&1; then

My only question is whether this will work if uquota is set up as a
global option. I haven't looked into it yet, but there appears to be
several different ways that uquota is specified in other tests:

052:_qmount_option uquota
108:export MOUNT_OPTIONS="-ouquota"
116:mount -o uquota $SCRATCH_DEV $SCRATCH_MNT
220:_scratch_mount -o uquota

Some consistency would be nice, but I don't think it's a problem
for this patch right now.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
