Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9PFxLE4184956 for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 10:59:23 -0500
Received: from mail.qboosh.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45912161D5CD
	for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 08:59:16 -0700 (PDT)
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61]) by cuda.sgi.com
	with ESMTP id BVjPn5ALAa5beqd9 for <xfs@oss.sgi.com>;
	Tue, 25 Oct 2011 08:59:16 -0700 (PDT)
Date: Tue, 25 Oct 2011 17:59:16 +0200
From: Jakub Bogusz <qboosh@pld-linux.org>
Subject: Re: [PATCH] xfsprogs: fix various incorrect printf formats
Message-ID: <20111025155916.GA19818@stranger.qboosh.pl>
References: <20111025115233.GB22103@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111025115233.GB22103@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Oct 25, 2011 at 07:52:33AM -0400, Christoph Hellwig wrote:
> Reported-by: Jakub Bogusz <qboosh@pld-linux.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
[...]
> Index: xfsprogs/repair/scan.c
> ===================================================================
> --- xfsprogs.orig/repair/scan.c	2011-10-25 13:46:56.562602076 +0200
> +++ xfsprogs/repair/scan.c	2011-10-25 13:47:31.369102715 +0200
> @@ -289,14 +289,14 @@ _("bad back (left) sibling pointer (saw
>  			 */
>  			set_bmap(agno, agbno, XR_E_MULT);
>  			do_warn(
> -_("inode 0x%" PRIu64 "bmap block 0x%" PRIu64 " claimed, state is %d\n"),
> +_("inode 0x%" PRIu64 "bmap block %" PRIx64 " claimed, state is %d\n"),
>  				ino, bno, state);
>  			break;
>  		case XR_E_MULT:
>  		case XR_E_INUSE_FS:
>  			set_bmap(agno, agbno, XR_E_MULT);
>  			do_warn(
> -_("inode 0x%" PRIu64 " bmap block 0x%" PRIu64 " claimed, state is %d\n"),
> +_("inode 0x%" PRIu64 " bmap block %" PRIx64 " claimed, state is %d\n"),
>  				ino, bno, state);
>  			/*
>  			 * if we made it to here, this is probably a bmap block
> @@ -311,7 +311,7 @@ _("inode 0x%" PRIu64 " bmap block 0x%" P
>  		case XR_E_BAD_STATE:
>  		default:
>  			do_warn(
> -_("bad state %d, inode 0x%" PRIu64 " bmap block 0x%" PRIu64 "\n"),
> +_("bad state %d, inode 0x%" PRIu64 " bmap block %" PRIx64 "\n"),
>  				state, ino, bno);
>  			break;
>  		}
> @@ -338,7 +338,7 @@ _("bad state %d, inode 0x%" PRIu64 " bma
>  		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
>  							mp->m_bmap_dmnr[0])) {
>  				do_warn(
> -_("inode 0x%" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
> +_("inode %" PRIx64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
>  					ino, numrecs, mp->m_bmap_dmnr[0],
>  					mp->m_bmap_dmxr[0]);
>  			return(1);

Erm... the above part of changes is inconsistent.

PRIxnn itself doesn't append "0x" - so either remove "0x" prefix and
keep PRIu64 (thus printing value in decimal) _or_ (xor in terms of
computer logic ;)) keep "0x" prefix and use PRIx64 (thus printing value
in hex).
I'd use decimal at least for inodes (in other places they are printed in
such way).

Also please note that in first 3 messages there were two uses
"0x"+PRIu64...


Regards,

-- 
Jakub Bogusz    http://qboosh.pl/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
