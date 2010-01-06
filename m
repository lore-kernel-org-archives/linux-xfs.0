Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06GltNi095037 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 10:47:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 018EA146023
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 08:48:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GTmrjpLEymOcSlVv for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 08:48:47 -0800 (PST)
Date: Wed, 6 Jan 2010 11:48:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove bashisms from xfstests
Message-ID: <20100106164844.GB4209@infradead.org>
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Sun, Jan 03, 2010 at 02:30:05AM -0800, Christian Kujau wrote:
> While trying to run xfstests, I encountered several errors due to the fact 
> that my /bin/sh is not linked to /bin/bash but to dash(1), which can be 
> made the default /bin/sh in Debian based systems. The patch below is 
> rather large and is touching many files, but it's pretty straightfoward:
> 
> 1) convert brace expansions (e.g. "rm -f symlink_{0,1,2,3}")

I'll comment on these in detail below.

> 2) convert "let..." into something (hopefully) more portable

Dave converted these away from expr due to performance reasons.  I'd
like too see a prove that performance hasn't regressed due to this
change.

> 3) replace 'a == b' with 'a = b' in bourne shell scripts

This looks fine.  If you want feel free to submit these as a separate
first patch so that we have the large pile sorted out.

> -    rm -f symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9} symlink_self empty_file
> +    rm -f symlink_* empty_file

This kind of replacement looks fine.


> -for f in symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9}
> +f=1
> +while [ $f -le 40 ]
>  do
> -    ln -s $o $f
> +    ln -s $o symlink_$f
>      o=$f
> +    o=symlink_$f
> +    f=$((f + 1))
>  done

I fear this might cause some overhead in the shell.  What about the
following instead:

for i in `seq 0 39`; do
    ln -s $o symlink_$i
    o=symlink_$i
done

Same applies to similar subsitutions.

> diff -Nrup xfstests.orig/032 xfstests/032
> --- xfstests.orig/032	2010-01-03 00:42:16.601617592 -0800
> +++ xfstests/032	2010-01-03 00:43:56.321617592 -0800
> @@ -66,6 +66,7 @@ do
>  	[ $fs = ext3 ] && preargs="-F"
>  	[ $fs = ext4 ] && preargs="-F"
>  	[ $fs = ext4dev ] && preargs="-F"
> +	[ $fs = nilfs2 ] && preargs="-q"

This hunk is unrelated.  Please submit it with a trivial one-liner
description and a signed-off-by line and I'll put it in.

> -echo -e -n "\n\r*** XFS QA 044 - done\n\r\n\r" >/dev/console
> +printf "\n\r*** XFS QA 044 - done\n\r\n\r" >/dev/console

This looks okay, but should be mentioned in the patch description.

>  echo "=== Recursive change ACL ==="
>  rm -fr root
> -mkdir root
> -pushd root >/dev/null
>  # create an arbitrary little tree
>  for i in 1 2 3 4 5 6 7 8 9 0
>  do
> -	mkdir -p a/$i
> -	mkdir -p b/c$i/$i
> -	touch a/$i/mumble
> +	mkdir -p root/a/$i
> +	mkdir -p root/b/c$i/$i
> +	touch root/a/$i/mumble
>  done
> -popd >/dev/null

Same here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
