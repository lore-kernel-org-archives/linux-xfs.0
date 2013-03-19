Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C687A7F5E
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 15:58:04 -0500 (CDT)
Date: Tue, 19 Mar 2013 15:58:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/13] xfstests: filter new repair/mkfs output for CRCs
Message-ID: <20130319205801.GG22182@sgi.com>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
	<1363348411-21867-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363348411-21867-2-git-send-email-david@fromorbit.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

Hey Rich,
   
On Fri, Mar 15, 2013 at 10:53:19PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This patch it to ensure that xfstests passes on non-crc filesystems
> with a CRC enabled userspace.
> 
> Filter out the mkfs/xfs_info CRC line from tests that capture the
> output of these commands.
> 
> Filter out new error noise from xfs_repair that occurs for
> xfs_repair as a result of the CRC changes.

IIRC this change was a temporary one so that xfstests could be run with crc
enabled filesystems.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  096           |    1 +
>  206           |    9 ++++++---
>  common.repair |    3 +++
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/096 b/096
> index 237edad..5a2273d 100755
> --- a/096
> +++ b/096
> @@ -85,6 +85,7 @@ _mkfs_filter()
>  	-e '/inode-paths/d' \
>  	-e 's/\(log[ 	]*=\).*bsize/\1LOG                    bsize/' \
>  	-e 's/\(realtime[ 	]*=\).*extsz/\1REALTIME               extsz/' \
> +	-e '/.*crc=/d' \
>  	-e 's/ *$//' \
>     | grep -v parent
>  }
> diff --git a/206 b/206
> index e8bc922..e46e6a3 100755
> --- a/206
> +++ b/206
> @@ -77,7 +77,8 @@ echo "=== mkfs.xfs ==="
>  mkfs.xfs -f -bsize=4096 -dagsize=76288719b,size=3905982455b -llazy-count=0 $tmpfile \
>  	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
>  		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
> -		-e "s/, projid32bit=[0-9]//"
> +		-e "s/, projid32bit=[0-9]//" \
> +		-e "/.*crc=/d"
>  
>  mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
>  
> @@ -85,13 +86,15 @@ mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
>  echo "=== xfs_growfs ==="
>  xfs_growfs $tmpdir \
>  	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
> -		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/"
> +		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
> +		-e "/.*crc=/d"
>  
>  # and double-check the new geometry
>  echo "=== xfs_info ==="
>  xfs_info $tmpdir \
>  	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
> -		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/"
> +		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
> +		-e "/.*crc=/d"
>  
>  # _cleanup cleans up for us
>  
> diff --git a/common.repair b/common.repair
> index 23a1ed6..db160bb 100644
> --- a/common.repair
> +++ b/common.repair
> @@ -77,6 +77,9 @@ s/\s+- \d+:\d\d:\d\d:.*\n//g;
>  /^agi_/ && next; # remove agi counts
>  /^sb_/ && next; # remove sb counts
>  /^agi unlinked/ && next; # remove agi unlinked bucket warning
> +# crc enabled filesystem output
> +/XFS_CORRUPTION_ERROR/ && next;
> +/^bad uuid/ && next;

Doesn't this filter out xfs repair failures which should be reported?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
