Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE98C7F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 20:42:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9701F30404E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 18:42:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mVEwVUAK02xerQ31 for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 18:42:44 -0700 (PDT)
Date: Mon, 14 Apr 2014 11:42:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix xfs_logprint EFI entry split on log buffer
Message-ID: <20140414014212.GG27694@dastard>
References: <20140409210013.095709266@sgi.com>
	<20140409210048.859660076@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140409210048.859660076@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: XFS Filesystem <xfs@oss.sgi.com>

On Wed, Apr 09, 2014 at 04:00:14PM -0500, Mark Tinguely wrote:
> xfs_logprint does not correctly handle EFI entries that
> are split across two log buffers. xfs_efi_copy_format()
> falsely interrupts the truncated size of the split entry
> as being a corrupt entry.
> 
> If the first log entry has enough information, namely the
> number of extents in the entry and the identifier, then
> display this information and a warning that this entry is
> truncated. Otherwise, if there is not enough information in
> the first log buffer, then print a message that the EFI decode
> was not possible. These messages are similar to split inode
> entries.
> 
> Example of a continued entry:
> Oper (336): tid: f214bdb  len: 44  clientid: TRANS  flags: CONTINUE
> EFI:  #regs: 1    num_extents: 2  id: 0xffff880804f63900
> EFI free extent data skipped (CONTINUE set, no space)
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
