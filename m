Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 967F07F4E
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:12:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E6ACAC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:12:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FucruGpAN3YdnfCH for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:12:26 -0800 (PST)
Date: Thu, 27 Feb 2014 20:12:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9] current series for verifier error differentiation
Message-ID: <20140227091211.GZ13647@dastard>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 18, 2014 at 05:52:20PM -0600, Eric Sandeen wrote:
> This is the current series I have leading up to verifier error differentiation,
> just resending them all.
> 
> As I send this, I remember that EILSEQ is giving us an unusual perror()
> output, so the last patch which uses it may need to pick some (?)
> other error code...

Eric, this leaks EBADMSG to userspace in xfs/005 with a corrupted
superblock:

$ diff -u tests/xfs/005.out /home/dave/src/xfstests-dev/results//xfs/005.out.bad
--- tests/xfs/005.out   2014-02-24 09:58:09.000000000 +1100
+++ /home/dave/src/xfstests-dev/results//xfs/005.out.bad
2014-02-27 19:40:56.000000000 +1100
@@ -1,4 +1,4 @@
 QA output created by 005
 wrote 4/4 bytes at offset 224
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-mount: Structure needs cleaning
+mount: Bad message

Dmesg contains this:

[ 8790.946956] XFS (vdb): Metadata CRC error detected at xfs_sb_read_verify+0x10c/0x140, block 0x0
[ 8790.949984] XFS (vdb): Unmount and run xfs_repair
[ 8790.951725] XFS (vdb): First 64 bytes of corrupted metadata buffer:
[ 8790.953883] ffff880003eea000: 58 46 53 42 00 00 10 00 00 00 00 00 00 2c 00 00  XFSB.........,..
[ 8790.956452] ffff880003eea010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[ 8790.958518] ffff880003eea020: 0b 21 13 2a 5b 00 40 59 bd 7c 2b d4 5b 6c a4 0a  .!.*[.@Y.|+.[l..
[ 8790.960487] ffff880003eea030: 00 00 00 00 00 20 00 04 00 00 00 00 00 00 00 40  ..... .........@

So that part is good. However, I suspect we should still be
returning EFSCORRUPTED to userspace. Most metadata buffer reads go
through xfs_trans_read_buf_map(), so there only a couple of places
we need to catch and convert the error being returned. The other two
I notice that are need conversion are xfs_buf_read() in
xfs_readlink_bmap(), and the cause of this regression which is
xfs_buf_read_uncached() in xfs_readsb()....

Can you look into writing up a followup patch that does this
catch-and-convert? It will also mean all the higher layers will
treat a CRC error as corrupt metadata, which is exactly what we want
it to do. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
