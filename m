Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B535629DFB
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 18:13:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98D478F8040
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:13:16 -0700 (PDT)
Date: Thu, 26 Sep 2013 20:13:09 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests: add xfs/291 to auto group
Message-ID: <20130926231309.GA18924@andromeda.usersys.redhat.com>
References: <52444130.6030000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52444130.6030000@sandeen.net>
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
To: xfs@oss.sgi.com, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

Good to me too

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
On Thu, Sep 26, 2013 at 09:14:08AM -0500, Eric Sandeen wrote:
> 291 passes just fine w/ current xfsprogs on non-crc filesystems,
> so add it to the auto group.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Not sure why I didn't do this in the first commit, sorry...
> 
> 
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 352a4c5..17fff27 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -171,7 +171,7 @@
>  283 dump ioctl auto quick
>  287 auto dump quota quick
>  290 auto rw prealloc quick ioctl
> -291 repair
> +291 auto repair
>  292 auto mkfs quick
>  293 auto quick
>  295 auto logprint quick
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
