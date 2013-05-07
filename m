Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9071C29E07
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 17:23:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 74BFB8F8059
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 15:22:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AbXRdyQLrVXPuZy5 for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 15:22:57 -0700 (PDT)
Date: Wed, 8 May 2013 08:22:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130507222256.GD24635@dastard>
References: <20130507133707.GA18301@redhat.com> <51895025.2010709@sgi.com>
	<20130507190731.GA15528@redhat.com> <518954DE.4070803@sgi.com>
	<20130507193146.GA7539@redhat.com> <51895CD7.7040806@sgi.com>
	<20130507195954.GA8384@redhat.com> <51895E51.2050508@sgi.com>
	<20130507202217.GA9883@redhat.com> <518962FC.2060509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518962FC.2060509@sgi.com>
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
Cc: Dave Jones <davej@redhat.com>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Tue, May 07, 2013 at 03:24:28PM -0500, Mark Tinguely wrote:
> On 05/07/13 15:22, Dave Jones wrote:
> >On Tue, May 07, 2013 at 03:04:33PM -0500, Mark Tinguely wrote:
> >  >  On 05/07/13 14:59, Dave Jones wrote:
> >  >  >  On Tue, May 07, 2013 at 02:58:15PM -0500, Mark Tinguely wrote:
> >  >  >
> >  >  >    >   >   I can hit this almost instantly with fsx. I'll do a bisect, though
> >  >  >    >   >   it sounds like you already have a suspect.
> >  >  >    >   >
> >  >  >    >
> >  >  >    >   If you want to try kmem debug of Linux 3.8 that would help.
> >  >  >
> >  >  >  I'm not sure what that is.
> >  >
> >  >  Sorry, if you would test Linux 3.8 with "CONFIG_DEBUG_SLAB=y".
> >
> >Ah, done that. (I pretty much always run with it).
> >
> >This is something new. Even 3.9 was fine. It's only since
> >the recent xfs merge.
> >
> >	Dave
> >
> 
> git revert 666d644cd72a9ec58b353209ff191d7430f3b357

That won't prevent the use after free. That commit fixed a problem
that could lead to a use after free, but what we are seeing here is
that it has ultimately exposed a previously unknown issue that
causes the use after free.

Basically what is happening is that there are two commits for the
EFD being processed, when there should only be one. I'm not sure how
this is happening yet, but these three traces came out from my debug
sequentially when running generic/006:

__xfs_efi_release 0xffff88006c4d7058 2
Pid: 4756, comm: kworker/1:1H Tainted: G    B        3.9.0-rc8-dgc+ #592
Call Trace:
 [<ffffffff814e43a5>] __xfs_efi_release+0x35/0x80
 [<ffffffff814e444d>] xfs_efi_item_unpin+0x5d/0x70
 [<ffffffff814dbb88>] xfs_trans_committed_bulk+0x248/0x2e0
 [<ffffffff814e18db>] xlog_cil_committed+0x3b/0x140
 [<ffffffff814ddfae>] xlog_state_do_callback+0x19e/0x3a0
.....

That's the EFI being unpinned and it's reference going away during
transaction commit completion procesing.

__xfs_efi_release 0xffff88006c4d7058 1
Pid: 4756, comm: kworker/1:1H Tainted: G    B        3.9.0-rc8-dgc+ #592
Call Trace:
 [<ffffffff814e43a5>] __xfs_efi_release+0x35/0x80
 [<ffffffff814e4620>] xfs_efi_release+0x60/0x80
 [<ffffffff814e46a6>] xfs_efd_item_committed+0x26/0x40
 [<ffffffff814dba21>] xfs_trans_committed_bulk+0xe1/0x2e0
 [<ffffffff814e18db>] xlog_cil_committed+0x3b/0x140
 [<ffffffff814ddfae>] xlog_state_do_callback+0x19e/0x3a0
.....

That's the EFD releasing the EFI, which drops it's reference count
and frees the both the EFI and the EFD.

__xfs_efi_release 0xffff88006c4d7058 1802201963
Pid: 4756, comm: kworker/1:1H Tainted: G    B        3.9.0-rc8-dgc+ #592
Call Trace:
 [<ffffffff814e43a5>] __xfs_efi_release+0x35/0x80
 [<ffffffff814e4630>] xfs_efi_release+0x70/0x80
 [<ffffffff814e46a6>] xfs_efd_item_committed+0x26/0x40
 [<ffffffff814dba21>] xfs_trans_committed_bulk+0xe1/0x2e0
 [<ffffffff814e18db>] xlog_cil_committed+0x3b/0x140
.....

And there's the EFI being released by an EFD after it has been
freed. It's definitely been freed because 1802201963 =
0x6b6b6b6b....

Like I said, I don't understand how this is happening yet, but just
seeing this behaviour explains an awful lot about why we've had long
term issues with this code....

FWIW, I used to run with slab debugging turned on for all my debug
builds. I switched my .config from SLAB to SLUB a few months ago,
and didn't realise this silently turned of memory poisoning.  That's
how it slipped through my testing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
