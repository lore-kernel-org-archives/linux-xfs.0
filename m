Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 850017F91
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:19:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 658268F8035
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:19:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NL0J1hHHOoP7EVyZ for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:19:10 -0700 (PDT)
Date: Thu, 30 Jul 2015 08:18:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 2/2] xfs: fix efi/efd error handling to avoid fs
	shutdown hangs
Message-ID: <20150729221835.GD16638@dastard>
References: <1437682410-51778-1-git-send-email-bfoster@redhat.com>
	<1437682410-51778-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437682410-51778-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 23, 2015 at 04:13:30PM -0400, Brian Foster wrote:
> Freeing an extent in XFS involves logging an EFI (extent free
> intention), freeing the actual extent, and logging an EFD (extent free
> done). The EFI object is created with a reference count of 2: one for
> the current transaction and one for the subsequently created EFD. Under
> normal circumstances, the first reference is dropped when the EFI is
> unpinned and the second reference is dropped when the EFD is committed
> to the on-disk log.
> 
> In event of errors or filesystem shutdown, there are various potential
> cleanup scenarios depending on the state of the EFI/EFD. The cleanup
> scenarios are confusing and racy, as demonstrated by the following test
> sequence:
> 
> 	# mount $dev $mnt
> 	# fsstress -d $mnt -n 99999 -p 16 -z -f fallocate=1 \
> 		-f punch=1 -f creat=1 -f unlink=1 &
> 	# sleep 5
> 	# killall -9 fsstress; wait
> 	# godown -f $mnt
> 	# umount
> 
> ... in which the final umount can hang due to the AIL being pinned
> indefinitely by one or more EFI items. This can occur due to several
> conditions. For example, if the shutdown occurs after the EFI is
> committed to the on-disk log and the EFD committed to the CIL, but
> before the EFD committed to the log, the EFD iop_committed() abort
> handler does not drop its reference to the EFI. Alternatively, manual
> error injection in the xfs_bmap_finish() codepath shows that if an error
> occurs after the EFI transaction is committed but before the EFD is
> constructed and logged, the EFI is never released from the AIL.
> 
> Update the EFI/EFD item handling code to use a more straightforward and
> reliable approach to error handling. If the EFI transaction is
> cancelled, the EFI is freed when the log item is unlocked. If the EFI
> transaction is committed successfully, from that point forward it is the
> responsibility of the EFD to drop its EFI reference. This means that the
> EFI unpin callback only ever drops the log reference to the EFI. It does
> not free the EFI in the event of log I/O error. This also means that the
> EFD item must drop its EFI reference either if the EFD transaction is
> cancelled, committed or itself aborted due to log I/O error. Finally,
> update xfs_bmap_finish() to ensure that once an EFI transaction is
> committed, we are guaranteed to construct and log the associated EFD.
> This ensures that the EFD is aborted and drops the reference to the EFI.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

FWIW, we have the same hang problems in log recovery when
xfs_free_extent fails - the efd is not logged and the filesystem is
not shut down, so the EFI being processed is not released or removed
from the AIL. We also abort the processing of EFIs on the first
error, leaving the AIL full of EFIs that will never be removed and
so the unmount will hang trying to empty the AIL...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
