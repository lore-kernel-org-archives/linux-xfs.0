Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32EZDUS187586 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 09:35:13 -0500
Message-ID: <4F79B91E.3060008@sgi.com>
Date: Mon, 02 Apr 2012 09:35:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] 030: fix for new xfs_repair versions
References: <20120331232836.GA19572@infradead.org>
In-Reply-To: <20120331232836.GA19572@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 03/31/12 18:28, Christoph Hellwig wrote:
> Given that we now drop invalid unlinked inode lists there is no message
> to capture.  Also add a sed expression to avoid failures on old repair
> versions.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> Index: xfstests-dev/030
> ===================================================================
> --- xfstests-dev.orig/030	2012-03-31 23:15:11.000000000 +0000
> +++ xfstests-dev/030	2012-03-31 23:18:31.000000000 +0000
> @@ -55,7 +55,8 @@ _check_ag()
>   	for structure in 'sb 0' 'agf 0' 'agi 0' 'agfl 0'
>   	do
>   		echo "Corrupting $structure - setting bits to $1"
> -		_check_repair $1 "$structure"
> +		_check_repair $1 "$structure" |
> +			sed -e 's/error following ag 0 unlinked list//'
>   	done
>   }
>
> @@ -97,8 +98,7 @@ src/devzero -v -1 -n "$clear" $SCRATCH_D
>
>   # now kick off the real repair test...
>   #
> -_scratch_mkfs_xfs $DSIZE | _filter_mkfs | \
> -    sed -e 's/error following ag 0 unlinked list//' 2>$tmp.mkfs
> +_scratch_mkfs_xfs $DSIZE | _filter_mkfs 2>$tmp.mkfs
>   . $tmp.mkfs
>   _check_ag 0
>   _check_ag -1
> Index: xfstests-dev/030.out.linux
> ===================================================================
> --- xfstests-dev.orig/030.out.linux	2012-03-31 23:19:09.000000000 +0000
> +++ xfstests-dev/030.out.linux	2012-03-31 23:19:17.000000000 +0000
> @@ -85,7 +85,6 @@ bad agbno AGBNO for inobt root, agno 0
>   root inode chunk not found
>   Phase 3 - for each AG...
>           - scan and clear agi unlinked lists...
> -error following ag 0 unlinked list
>           - process known inodes and perform inode discovery...
>           - process newly discovered inodes...
>   Phase 4 - check for duplicate blocks...
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

The sed left a blank line where where the "error following ag 0 unlinked 
list" would have been in an 3.0.x kernel run of the test.

Maybe add another "sed -e '/^$/d'" to the filter?

--Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
