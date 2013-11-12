Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF22C7F6D
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 16:08:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCF24304051
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 14:08:46 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7HgARSu06QrYTKAh for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 14:08:45 -0800 (PST)
Date: Wed, 13 Nov 2013 09:08:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: _filter_mkfs should consume input from
	stdin for non-xfs fs
Message-ID: <20131112220816.GB6188@dastard>
References: <1384243158-19317-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384243158-19317-1-git-send-email-eguan@redhat.com>
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

On Tue, Nov 12, 2013 at 03:59:18PM +0800, Eryu Guan wrote:
> _filter_mkfs is a filter so that it should read from stdin first
> before printing anything out. Otherwise the command prior to the
> pipeline may get EPIPE.
> 
> I saw this when testing extN with generic/204, _scratch_mkfs_sized was
> unable to create fs because of EPIPE, then _scratch_mount failed.
> 
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
> v2: just pipe stdin to /dev/null for non-xfs fs as Dave suggested.
> 
>  common/filter | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/filter b/common/filter
> index e37ce69..c872a27 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -138,6 +138,7 @@ _filter_mkfs()
>      xfs)
>  	;;
>      *)
> +	cat - >/dev/null
>  	perl -e 'print STDERR "dbsize=4096\nisize=256\n"'
>  	return ;;
>      esac

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
