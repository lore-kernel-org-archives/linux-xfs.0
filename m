Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7JElYt2025448 for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 09:47:34 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B18D4F459B
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 07:47:33 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 6cOuWmAxlVFvV2fW for <xfs@oss.sgi.com>;
	Fri, 19 Aug 2011 07:47:33 -0700 (PDT)
Message-ID: <4E4E7784.7050509@sandeen.net>
Date: Fri, 19 Aug 2011 09:47:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Also accept "no such attribute" errors for
	invalid extended attributes
References: <1313619249.18763.3.camel@schurl.linbit>
In-Reply-To: <1313619249.18763.3.camel@schurl.linbit>
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
To: Andreas Gruenbacher <agruen@kernel.org>
Cc: hch@infradead.org, xfs@oss.sgi.com

On 8/17/11 5:14 PM, Andreas Gruenbacher wrote:
> In older Linux kernels, requesting an extended attribute which cannot exist
> failed with EPERM.  In version 3.0, this was changed to ENODATA so that
> programs can distinguish between missing attributes and permission problems
> independent of the file type.
> 
> For example, lgetxattr("file", "user.name", NULL, 0) will now return ENODATA if
> no such attribute exists even if "file" is a symbolic link.
> 
> In test 062, to make it work on kernels before and after 3.0, accept either of
> the two error results from getfattr.

> Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I'll merge it, thanks.

> ---
>  062     |   12 +++++++++---
>  062.out |   40 ++++++++++++++++++++--------------------
>  2 files changed, 29 insertions(+), 23 deletions(-)
> 
> diff --git a/062 b/062
> index a6e4bc8..f666e1b 100755
> --- a/062
> +++ b/062
> @@ -84,6 +84,12 @@ _scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
>  _scratch_mount || _fail "mount failed"
>  _create_test_bed
>  
> +# In kernels before 3.0, getxattr() fails with EPERM for an attribute which
> +# cannot exist.  Later kernels fail with ENODATA.  Accept both results.
> +invalid_attribute_filter() {
> +	sed -e "s:\(No such attribute\|Operation not permitted\):No such attribute or operation not permitted:"
> +}
> +
>  if [ "$USE_ATTR_SECURE" = yes ]; then
>      ATTR_MODES="user security trusted"
>  else
> @@ -119,15 +125,15 @@ for nsp in $ATTR_MODES; do
>  		
>  		echo "*** set an empty value for second attribute"
>  		setfattr -h -n $nsp.name2 $SCRATCH_MNT/$inode
> -		getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode
> +		getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
>  
>  		echo "*** overwrite empty value"
>  		setfattr -h -n $nsp.name2 -v 0xcafe $SCRATCH_MNT/$inode
> -		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode
> +		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
>  
>  		echo "*** remove attribute"
>  		setfattr -h -x $nsp.name2 $SCRATCH_MNT/$inode
> -		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode
> +		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
>  
>  		echo "*** final list (strings, type=$inode, nsp=$nsp)"
>  		getfattr -m '.' -e hex $SCRATCH_MNT/$inode
> diff --git a/062.out b/062.out
> index 1d5a094..699254a 100644
> --- a/062.out
> +++ b/062.out
> @@ -49,7 +49,7 @@ user.name2
>  user.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/reg: user.name2: No such attribute
> +SCRATCH_MNT/reg: user.name2: No such attribute or operation not permitted
>  *** final list (strings, type=reg, nsp=user)
>  # file: SCRATCH_MNT/reg
>  user.name=0xbabe
> @@ -96,7 +96,7 @@ user.name2
>  user.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dir: user.name2: No such attribute
> +SCRATCH_MNT/dir: user.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dir, nsp=user)
>  # file: SCRATCH_MNT/dir
>  user.name=0xbabe
> @@ -119,13 +119,13 @@ setfattr: SCRATCH_MNT/lnk: Operation not permitted
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
> -SCRATCH_MNT/lnk: user.name2: Operation not permitted
> +SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
> -SCRATCH_MNT/lnk: user.name2: Operation not permitted
> +SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
>  *** remove attribute
>  setfattr: SCRATCH_MNT/lnk: Operation not permitted
> -SCRATCH_MNT/lnk: user.name2: Operation not permitted
> +SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
>  *** final list (strings, type=lnk, nsp=user)
>  
>  === TYPE dev/b; NAMESPACE user
> @@ -144,13 +144,13 @@ setfattr: SCRATCH_MNT/dev/b: Operation not permitted
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
> -SCRATCH_MNT/dev/b: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
> -SCRATCH_MNT/dev/b: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
>  *** remove attribute
>  setfattr: SCRATCH_MNT/dev/b: Operation not permitted
> -SCRATCH_MNT/dev/b: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dev/b, nsp=user)
>  
>  === TYPE dev/c; NAMESPACE user
> @@ -169,13 +169,13 @@ setfattr: SCRATCH_MNT/dev/c: Operation not permitted
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
> -SCRATCH_MNT/dev/c: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
> -SCRATCH_MNT/dev/c: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
>  *** remove attribute
>  setfattr: SCRATCH_MNT/dev/c: Operation not permitted
> -SCRATCH_MNT/dev/c: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dev/c, nsp=user)
>  
>  === TYPE dev/p; NAMESPACE user
> @@ -194,13 +194,13 @@ setfattr: SCRATCH_MNT/dev/p: Operation not permitted
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
>  *** set an empty value for second attribute
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
> -SCRATCH_MNT/dev/p: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
>  *** overwrite empty value
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
> -SCRATCH_MNT/dev/p: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
>  *** remove attribute
>  setfattr: SCRATCH_MNT/dev/p: Operation not permitted
> -SCRATCH_MNT/dev/p: user.name2: Operation not permitted
> +SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dev/p, nsp=user)
>  
>  === TYPE reg; NAMESPACE trusted
> @@ -243,7 +243,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/reg: trusted.name2: No such attribute
> +SCRATCH_MNT/reg: trusted.name2: No such attribute or operation not permitted
>  *** final list (strings, type=reg, nsp=trusted)
>  # file: SCRATCH_MNT/reg
>  trusted.name=0xbabe
> @@ -292,7 +292,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dir: trusted.name2: No such attribute
> +SCRATCH_MNT/dir: trusted.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dir, nsp=trusted)
>  # file: SCRATCH_MNT/dir
>  trusted.name=0xbabe
> @@ -341,7 +341,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/lnk: trusted.name2: No such attribute
> +SCRATCH_MNT/lnk: trusted.name2: No such attribute or operation not permitted
>  *** final list (strings, type=lnk, nsp=trusted)
>  # file: SCRATCH_MNT/lnk
>  trusted.name=0xbabe
> @@ -388,7 +388,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dev/b: trusted.name2: No such attribute
> +SCRATCH_MNT/dev/b: trusted.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dev/b, nsp=trusted)
>  # file: SCRATCH_MNT/dev/b
>  trusted.name=0xbabe
> @@ -435,7 +435,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dev/c: trusted.name2: No such attribute
> +SCRATCH_MNT/dev/c: trusted.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dev/c, nsp=trusted)
>  # file: SCRATCH_MNT/dev/c
>  trusted.name=0xbabe
> @@ -482,7 +482,7 @@ trusted.name2
>  trusted.name2=0xcafe
>  
>  *** remove attribute
> -SCRATCH_MNT/dev/p: trusted.name2: No such attribute
> +SCRATCH_MNT/dev/p: trusted.name2: No such attribute or operation not permitted
>  *** final list (strings, type=dev/p, nsp=trusted)
>  # file: SCRATCH_MNT/dev/p
>  trusted.name=0xbabe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
