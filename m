Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HN2gBN007101 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 17:02:43 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0D4D13B52F1
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 15:04:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	Kmue6O3xC68YtGop for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2010 15:04:00 -0800 (PST)
Date: Thu, 18 Feb 2010 10:03:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: mount xfs with a context when selinux is on
Message-ID: <20100217230358.GX28392@discord.disaster>
References: <4B7C3F98.50303@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B7C3F98.50303@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Feb 17, 2010 at 01:12:24PM -0600, Eric Sandeen wrote:
> When selinux is on, we get tons of new xattrs, which messes
> up all kinds of output.
> 
> The simplest way out of this, for now, seems to be to just mount
> with a global context instead and skip writing the extra xattrs.
> 
> I've been using this internally on Fedora and RHEL for a while now.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

I know very little about selinux, so while the code changes look OK
I have no idea if the context change is All Goodness.

> --- a/common.rc
> +++ b/common.rc
> @@ -47,8 +47,16 @@ _ls_l()
>  
>  _mount_opts()
>  {
> +    # SELinux adds extra xattrs which can mess up our expected output.
> +    # So, mount with a context, and they won't be created
> +    # nfs_t is a "liberal" context so we can use it.
> +    if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
> +	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
> +    fi
> +

i.e. is t_nfs a context specific to a RHEL/Fedora setup, or is it a
generic context that other distro's also define?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
