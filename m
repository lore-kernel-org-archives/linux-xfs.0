Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7JE1Jes023502 for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 09:01:19 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CA8913832F0
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 07:03:36 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id IFHS61lVWWNBQFVX for <xfs@oss.sgi.com>;
	Fri, 19 Aug 2011 07:03:36 -0700 (PDT)
Message-ID: <4E4E6CAE.9000909@sandeen.net>
Date: Fri, 19 Aug 2011 09:01:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix 062 for newer kernels (v3.0+)
References: <4E4D88BB.4020807@redhat.com>
In-Reply-To: <4E4D88BB.4020807@redhat.com>
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
Cc: Jeff Moyer <jmoyer@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/18/11 4:48 PM, Eric Sandeen wrote:
> Commit 55b23bde19c08f14127a27d461a4e079942c7258,
> xattr: Fix error results for non-existent / invisible attributes

Oh sorry, I see that Christoph already sent a (better) patch like
this, via Andreas...

*shrug* I suppose one or the other should go in ...

Thanks,
-Eric

> changed the error return for getfattr on a link:
> 
>     Return -ENODATA when trying to read a user.* attribute which cannot
>     exist: user space otherwise does not have a reasonable way to
>     distinguish between non-existent and inaccessible attributes.
> 
> via:
> 
>         if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
>                 if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> -                       return -EPERM;
> +                       return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
> 
> 
> So, I propose just filtering both error values to "Failure" as below.
> 
> Reported-by: Jeff MOyer <jmoyer@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/062 b/062
> index a6e4bc8..709f336 100755
> --- a/062
> +++ b/062
> @@ -46,9 +46,12 @@ _cleanup()
>  }
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> +# getfattr can fail in 2 ways depending on kernel version; see
> +# commit 55b23bde19c08f14127a27d461a4e079942c7258 upstream
>  getfattr()
>  {
> -    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch
> +    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch \
> +	| sed -e "s/No such attribute\|Operation not permitted/Failure/"
>  }
>  
>  setfattr()
> diff --git a/062.out b/062.out
> index 1d5a094..8377b30 100644
> --- a/062.out
> +++ b/062.out
> @@ -49,7 +49,7 @@ user.name2
>  user.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/reg: user.name2: No such attribute
> +SCRATCH_MNT/reg: user.name2: Failure
>  *** final list (strings, type=reg, nsp=user)
>  # file: SCRATCH_MNT/reg
>  user.name=0xbabe
> @@ -96,7 +96,7 @@ user.name2
>  user.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dir: user.name2: No such attribute
> +SCRATCH_MNT/dir: user.name2: Failure
>  *** final list (strings, type=dir, nsp=user)
>  # file: SCRATCH_MNT/dir
>  user.name=0xbabe
> @@ -119,13 +119,13 @@ setfattr: SCRATCH_MNT/lnk: Operation not permitted
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
> -SCRATCH_MNT/lnk: user.name2: Operation not permitted
> +SCRATCH_MNT/lnk: user.name2: Failure
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
> -SCRATCH_MNT/lnk: user.name2: Operation not permitted
> +SCRATCH_MNT/lnk: user.name2: Failure
>  *** remove attribute
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
> -SCRATCH_MNT/lnk: user.name2: Operation not permitted
> +SCRATCH_MNT/lnk: user.name2: Failure
>  *** final list (strings, type=lnk, nsp=user)
>  
>  === TYPE dev/b; NAMESPACE user
> @@ -144,13 +144,13 @@ setfattr: SCRATCH_MNT/dev/b: Operation not permitted
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
> -SCRATCH_MNT/dev/b: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/b: user.name2: Failure
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
> -SCRATCH_MNT/dev/b: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/b: user.name2: Failure
>  *** remove attribute
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
> -SCRATCH_MNT/dev/b: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/b: user.name2: Failure
>  *** final list (strings, type=dev/b, nsp=user)
>  
>  === TYPE dev/c; NAMESPACE user
> @@ -169,13 +169,13 @@ setfattr: SCRATCH_MNT/dev/c: Operation not permitted
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
> -SCRATCH_MNT/dev/c: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/c: user.name2: Failure
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
> -SCRATCH_MNT/dev/c: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/c: user.name2: Failure
>  *** remove attribute
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
> -SCRATCH_MNT/dev/c: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/c: user.name2: Failure
>  *** final list (strings, type=dev/c, nsp=user)
>  
>  === TYPE dev/p; NAMESPACE user
> @@ -194,13 +194,13 @@ setfattr: SCRATCH_MNT/dev/p: Operation not permitted
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
> -SCRATCH_MNT/dev/p: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/p: user.name2: Failure
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
> -SCRATCH_MNT/dev/p: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/p: user.name2: Failure
>  *** remove attribute
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
> -SCRATCH_MNT/dev/p: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/p: user.name2: Failure
>  *** final list (strings, type=dev/p, nsp=user)
>  
>  === TYPE reg; NAMESPACE trusted
> @@ -243,7 +243,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/reg: trusted.name2: No such attribute
> +SCRATCH_MNT/reg: trusted.name2: Failure
>  *** final list (strings, type=reg, nsp=trusted)
>  # file: SCRATCH_MNT/reg
>  trusted.name=0xbabe
> @@ -292,7 +292,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dir: trusted.name2: No such attribute
> +SCRATCH_MNT/dir: trusted.name2: Failure
>  *** final list (strings, type=dir, nsp=trusted)
>  # file: SCRATCH_MNT/dir
>  trusted.name=0xbabe
> @@ -341,7 +341,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/lnk: trusted.name2: No such attribute
> +SCRATCH_MNT/lnk: trusted.name2: Failure
>  *** final list (strings, type=lnk, nsp=trusted)
>  # file: SCRATCH_MNT/lnk
>  trusted.name=0xbabe
> @@ -388,7 +388,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dev/b: trusted.name2: No such attribute
> +SCRATCH_MNT/dev/b: trusted.name2: Failure
>  *** final list (strings, type=dev/b, nsp=trusted)
>  # file: SCRATCH_MNT/dev/b
>  trusted.name=0xbabe
> @@ -435,7 +435,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dev/c: trusted.name2: No such attribute
> +SCRATCH_MNT/dev/c: trusted.name2: Failure
>  *** final list (strings, type=dev/c, nsp=trusted)
>  # file: SCRATCH_MNT/dev/c
>  trusted.name=0xbabe
> @@ -482,7 +482,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dev/p: trusted.name2: No such attribute
> +SCRATCH_MNT/dev/p: trusted.name2: Failure
>  *** final list (strings, type=dev/p, nsp=trusted)
>  # file: SCRATCH_MNT/dev/p
>  trusted.name=0xbabe
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
