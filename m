Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9D0uvDn119638 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 19:56:57 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F3941C8397C
	for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 17:56:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cIBt7G7J2hRAhoZ7 for <xfs@oss.sgi.com>;
	Wed, 12 Oct 2011 17:56:55 -0700 (PDT)
Date: Thu, 13 Oct 2011 11:56:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] 263: Functional test case for the btrfs snapshot
Message-ID: <20111013005652.GM3159@dastard>
References: <4E3BA2F7.4080500@oracle.com>
	<1318395174-4075-1-git-send-email-Anand.Jain@oracle.com>
	<1318395174-4075-2-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318395174-4075-2-git-send-email-Anand.Jain@oracle.com>
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
To: Anand Jain <Anand.Jain@oracle.com>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Oct 12, 2011 at 12:52:52PM +0800, Anand Jain wrote:
> Create snapshots in various ways, modify the data around the block and
> file boundaries and verify the data integrity.
....

> +
> +# Create Dir tree and files in it.
> +# arg1 basedir
> +# arg2 dir depth
> +# arg3 nfile_min
> +# arg4 nfile_max
> +# arg5 fsize_min
> +# arg6 fsize_max
> +_fillfs()
> +{
> +	umask 000
> +	local j
> +	local i
> +	local DIRP
> +	local FCNT
> +	local FILEP
> +	local SCNT
> +	local BCNT
> +	DIRP=$6
> +	for ((j=0; j<$1; j++)); do
> +		DIRP=`mktemp -dq $DIRP/dir.XXXXXX`
> +		FCNT=$(_rand_range $2 $3)
> +		for ((i=0; i<$FCNT; i++)); do
> +			FILEP=`mktemp -q $DIRP/file.XXXXXX`
> +			SCNT=$(_rand_range $4 $5)
> +			dd if=/dev/urandom of=$FILEP bs=$SCNT count=1 status=noxfer 2>/dev/null &
> +		done
> +	done
> +	wait $!
> +}

Please, no, not -another- new and just a bit different "fill
filesystem" function.

There's already been one added recently in test 256 which I
commented at the time could use _populate_fs, and I said the same
thing in my original review of this series, too.

So please modify the _populate_fs function to do what you need.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
