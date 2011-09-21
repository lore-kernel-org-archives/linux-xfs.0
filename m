Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LGserk159669 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 11:54:40 -0500
Subject: Re: xfstests 258: Test xfs fs creation with fs size close to 4 TB
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
References: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
Date: Wed, 21 Sep 2011 11:54:35 -0500
Message-ID: <1316624075.2986.22.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Boris Ranto <branto@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sandeen <sandeen@redhat.com>, Eric@oss.sgi.com, xfs-oss <xfs@oss.sgi.com>

On Wed, 2011-09-21 at 15:52 +0200, Boris Ranto wrote:
> mkfs.xfs failed to create xfs filesystems with 4 TB minus few bytes due
> to round up error in mkfs.xfs code.
> 
> This test case is a regression test for the fs creation problem.
> 
> I've tested the test case with mkfs.xfs patch (in the form posted by
> Eric Sandeen) and the test passed (and therefore the patch fixed the
> issue for me).
> 
> Signed-off-by: Boris Ranto <branto@redhat.com>

This looks OK, but I'm a little concerned about the
shell's ability to handle > 32-bit values in its
arithmetic expressions (within $((...))).

Using ${fourtb} works for me, but I just don't know
whether it is written somewhere that bash always
supports 64-bit (or even arbitrary) precision values.

Do you know?

Same general concern goes for dd, but I am more inclined
to think it can handle large numbers.

Otherwise this looks good to me (though I haven't yet
tried it out).

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> +fourtb=4398046511104
> +for sub in 1 512 1024 1025 2048 4096;
> +do
> +	echo "Trying to make $fourtb - $sub B long xfs fs image"
> +	rm -f "$testfile"
> +	dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$(($fourtb - $sub))
> >/dev/null 2>&1 || echo "dd failed"
> +	lofile=$(losetup -f)
> +	losetup $lofile "$testfile"
> +	"$MKFS_XFS_PROG" -b size=512 $lofile >/dev/null || echo "mkfs failed!"
> +	losetup -d $lofile
> +done
> +

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
