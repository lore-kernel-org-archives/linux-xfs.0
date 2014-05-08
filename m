Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D5F17F54
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 23:16:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1792EAC006
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 21:16:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id R4VWX0rFCfPnPKN5 for <xfs@oss.sgi.com>;
	Wed, 07 May 2014 21:16:28 -0700 (PDT)
Message-ID: <536B051B.20400@sandeen.net>
Date: Wed, 07 May 2014 23:16:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix flink test
References: <1399496087-20431-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1399496087-20431-1-git-send-email-jbacik@fb.com>
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
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 5/7/14, 3:54 PM, Josef Bacik wrote:
> I don't have flink support in my xfsprogs, but it doesn't fail with "command not
> found" or whatever, it fails because I don't have the -T option.  So fix
> _require_xfs_io_command to check for an invalid option and not run.  This way I
> get notrun instead of a failure.  Thanks,

This actually doesn't work for me on an old kernel, if that matters; it
fails with:

/mnt/test: Is a directory

and nothing catches that.  Old xfsprogs tries to open the file
in question RDWR even before it gets to the -T option (which
would fail, I guess), and you can't do that for directories.

So I suppose we could explicitly test for that when checking
flink:

        [ $command = "flink" ] && echo $testio | grep -q "Is a directory" && \
                _notrun "xfs_io flink support is missing"

or alternately, first just run xfs_io w/ the command but no file;
today, at least, that works:

[root@bp-05 xfstests]# xfs_io -c flink
command "flink" not found
[root@bp-05 xfstests]# xfs_io -c pread
[root@bp-05 xfstests]# 

so could do this before the case statement:

        $XFS_IO_PROG -c $command 2>&1 | grep -q "not found" && \
                _notrun "xfs_io $command support is missing"

but that might be subject to future changes in xfs_io command
parsing...

-Eric


> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  common/rc | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 5c13db5..4fa7e63 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1258,6 +1258,8 @@ _require_xfs_io_command()
>  		_notrun "xfs_io $command support is missing"
>  	echo $testio | grep -q "Operation not supported" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
> +	echo $testio | grep -q "invalid option" && \
> +		_notrun "xfs_io $command support is missing"
>  }
>  
>  # Check that a fs has enough free space (in 1024b blocks)
> -- 1.8.3.1 _______________________________________________ xfs mailing list xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
