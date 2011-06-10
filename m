Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5AIrl6r002496 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:53:48 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75A07DA2DBF
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 11:53:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MnUe41MNRh3A6joo for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 11:53:45 -0700 (PDT)
Message-ID: <4DF26838.4030101@redhat.com>
Date: Fri, 10 Jun 2011 13:53:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH]: [xfstests] Make ext2 requirement explicit for test 049
References: <1307731533.7661.436.camel@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <1307731533.7661.436.camel@chandra-lucid.beaverton.ibm.com>
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
To: sekharan@us.ibm.com
Cc: XFS <xfs@oss.sgi.com>

On 06/10/2011 01:45 PM, Chandra Seetharaman wrote:
> Test 049 depends on ext2 module being supported by the kernel.
> 
> This patch makes it a explicit, instead of failing the test with
> obscure message.
> 
> Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
> 
> diff --git a/049 b/049
> index 3d3f030..c6c4faa 100755
> --- a/049
> +++ b/049
> @@ -64,6 +64,7 @@ _require_nobigloopfs
>  _require_nonexternal
>  _require_scratch
>  _require_loop
> +_require_ext2
>  
>  rm -f $seq.full
>  
> diff --git a/common.rc b/common.rc
> index c510c66..531a43e 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -769,6 +769,23 @@ _require_loop()
>      fi
>  }
>  
> +# this test requires ext2 filesystem support
> +#
> +_require_ext2()
> +{
> +    if [ "$HOSTOS" != "Linux" ]
> +    then
> +	_notrun "This test requires linux for ext2 filesystem support"
> +    fi
> +
> +    if modprobe ext2 >/dev/null 2>&1

Does this do the right thing if ext2 is built in?

If not, would :

modprobe ext2 >/dev/null 2>&1
grep ext2 /proc/filesystems ...

work better?

-Eric

> +    then
> +	:
> +    else
> +	_notrun "This test requires ext2 filesystem support"
> +    fi
> +}
> +
>  # this test requires that (large) loopback device files are not in use
>  #
>  _require_nobigloopfs()
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
