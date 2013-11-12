Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAEC27F57
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 22:55:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 824918F8035
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 20:55:13 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eSShgDqUFAVkRehJ for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 20:55:11 -0800 (PST)
Date: Tue, 12 Nov 2013 15:55:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND] xfstests: _filter_mkfs should consume input from
	stdin first to avoid EPIPE
Message-ID: <20131112045505.GY6188@dastard>
References: <1384229874-30656-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384229874-30656-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 12, 2013 at 12:17:54PM +0800, Eryu Guan wrote:
> _filter_mkfs is a filter so that it should read from stdin first
> before printing anything out. Otherwise the command prior to the
> pipeline may get EPIPE.
> 
> I saw this when testing extN with generic/204, _scratch_mkfs_sized was
> unable to create fs because of EPIPE, then _scratch_mount failed.

Ok, so that's a problem for filesystem types that don't actually
filter the output.

> generic/204 12s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/204.out.bad)
>     --- tests/generic/204.out   2013-11-01 16:47:56.728591856 +0800
>     +++ /root/xfstests/results//generic/204.out.bad     2013-11-01 22:52:53.207828779 +0800
>     @@ -1,2 +1,7 @@
>      QA output created by 204
>     -*** done
>     +mount: wrong fs type, bad option, bad superblock on /dev/sda6,
>     +       missing codepage or helper program, or other error
>     +       In some cases useful info is found in syslog - try
>     +       dmesg | tail  or so
>     +
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/filter | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/common/filter b/common/filter
> index e37ce69..faf33e3 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -134,16 +134,19 @@ _filter_date()
>  # Non XFS filesystems always return a 4k block size and a 256 byte inode.
>  _filter_mkfs()
>  {
> +    local tmp=/tmp/mkfs_filter
> +    cat - >$tmp
> +

tmp is a global scope variable, so shouldn't be used as a local lik
ethis. Indeed, a file is not needed at all here, because

>      case $FSTYP in
>      xfs)
>  	;;
>      *)
>  	perl -e 'print STDERR "dbsize=4096\nisize=256\n"'
> +	rm -f $tmp
>  	return ;;

for filesystems that don't consume stdin, you could just pipe it to
/dev/null here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
