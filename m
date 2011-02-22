Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MK3TO4256177 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:03:29 -0600
Subject: Re: [PATCH] xfsprogs: Don't ever try to set the device blocksize
	in repair
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D62B7D1.4040901@redhat.com>
References: <4D62B7D1.4040901@redhat.com>
Date: Tue, 22 Feb 2011 14:04:19 -0600
Message-ID: <1298405059.1960.41.camel@doink>
Mime-Version: 1.0
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-02-21 at 13:06 -0600, Eric Sandeen wrote:
> On 4k devices, we get this warning from repair:
> 
> # xfs_repair /dev/sdc2
> xfs_repair: warning - cannot set blocksize 512 on block device /dev/sdc2: Invalid argument
> Phase 1 - find and verify superblock...
> ...
> 
> but things proceed without trouble after that.
> 
> I'm unable to find any history or reason for setting the
> device blocksize at the beginning of repair, and in any case,
> things clearly work without doing so.  So, let's just remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

On Linux anyway, the way it's used here is pretty
pointless anyway.  It passes either 0 or 1, which
means either don't set it (if "living dangerously")
or do set it, to the minimum XFS sector size, 512
bytes.  Hence it'll screw up on > 512-byte sector
devices.

If there was a reason for setting it, it should
do so by setting it to the device's logical block
size rather than assuming 512.

But I don't see a reason to set it either, so the
change looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
