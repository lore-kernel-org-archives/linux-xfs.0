Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IEUYbI158431 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 09:30:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88F241CCEEE1
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 07:31:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PFvGJHDyHZsPVr3h for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 07:31:15 -0700 (PDT)
Date: Sat, 18 Jul 2009 10:31:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs &
	ext4
Message-ID: <20090718143114.GC20905@infradead.org>
References: <4A5E3A37.5050306@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A5E3A37.5050306@redhat.com>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Wed, Jul 15, 2009 at 03:21:11PM -0500, Eric Sandeen wrote:
> Test a few very basic defragmentation scenarios.
> 
> This test creates some files, runs defrag on them,
> and compares the before/after fragmentation as well
> as file md5sums and timestamps.
> 
> (md5sums may just be reading buffered data though,
> suggestions?)

As Andreas said unmount it before.

> The test currently expects to find e4defrag in
> /usr/bin

> +_supported_fs xfs ext4

> +fragfile=$SCRATCH_MNT/fragfile.$$
> +
> +if [ "$FSTYP" == "xfs" ]; then
> +	DEFRAG=/usr/sbin/xfs_fsr
> +else
> +	DEFRAG=/usr/bin/e4defrag
> +fi
> +
> +_require_command $DEFRAG
> +_require_command /usr/sbin/filefrag

I think we're much better off adding a helpers for this in a new
common.defrag (or adding it somwhere).

Then set a DEFRAF_PROG variable there, and add a _require_defrag
ala

_require_defrag()
{
    case "$FSTYP" in
    xfs)
        DEFRAG_PROG=/usr/sbin/xfs_fsr
	;;
    ext4)
        DEFRAG_PROG=/usr/bin/e4defrag
	;;
    *)
        _notrun "defragmentation not supported for fstype \"$FSTYP\""
	;;
    esac

    _require_command $DEFRAG
    _require_command /usr/sbin/filefrag
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
