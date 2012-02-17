Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHNvZb098508 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:23:57 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	eZ8WQ0xZ7ftH9wJA (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:23:56 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RyRXH-0005fN-OZ
	for xfs@oss.sgi.com; Fri, 17 Feb 2012 17:23:55 +0000
Date: Fri, 17 Feb 2012 12:23:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] repair: fix a few message formats in process_dinode_int
Message-ID: <20120217172355.GA21725@infradead.org>
References: <20120209181959.GA28010@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20120209181959.GA28010@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1853539644010595137=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1853539644010595137==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

ping?

On Thu, Feb 09, 2012 at 01:19:59PM -0500, Christoph Hellwig wrote:
> Always out¶ut newline after messages, and skip corruptions warnings
> if handling uncertain inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/repair/dinode.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/dinode.c	2012-02-05 05:59:08.441922905 -0800
> +++ xfsprogs-dev/repair/dinode.c	2012-02-06 11:56:36.689502813 -0800
> @@ -2552,16 +2552,22 @@ _("bad (negative) size %" PRId64 " on in
>  		uint16_t flags = be16_to_cpu(dino->di_flags);
>  
>  		if (flags & ~XFS_DIFLAG_ANY) {
> -			do_warn(_("Bad flags set in inode %" PRIu64), lino);
> +			if (!uncertain) {
> +				do_warn(
> +	_("Bad flags set in inode %" PRIu64 "\n"),
> +					lino);
> +			}
>  			flags &= ~XFS_DIFLAG_ANY;
>  		}
>  
>  		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
>  			/* need an rt-dev! */
>  			if (!rt_name) {
> -				do_warn(
> -	_("inode %" PRIu64 " has RT flag set but there is no RT device"),
> -					lino);
> +				if (!uncertain) {
> +					do_warn(
> +	_("inode %" PRIu64 " has RT flag set but there is no RT device\n"),
> +						lino);
> +				}
>  				flags &= ~(XFS_DIFLAG_REALTIME |
>  						XFS_DIFLAG_RTINHERIT);
>  			}
> @@ -2569,8 +2575,11 @@ _("bad (negative) size %" PRId64 " on in
>  		if (flags & XFS_DIFLAG_NEWRTBM) {
>  			/* must be a rt bitmap inode */
>  			if (lino != mp->m_sb.sb_rbmino) {
> -				do_warn(_("inode %" PRIu64 " not rt bitmap"),
> -					lino);
> +				if (!uncertain) {
> +					do_warn(
> +	_("inode %" PRIu64 " not rt bitmap\n"),
> +						lino);
> +				}
>  				flags &= ~XFS_DIFLAG_NEWRTBM;
>  			}
>  		}
> @@ -2580,9 +2589,11 @@ _("bad (negative) size %" PRId64 " on in
>  			     XFS_DIFLAG_NOSYMLINKS)) {
>  			/* must be a directory */
>  			if (di_mode && !S_ISDIR(di_mode)) {
> -				do_warn(
> -	_("directory flags set on non-directory inode %" PRIu64 ),
> -					lino);
> +				if (!uncertain) {
> +					do_warn(
> +	_("directory flags set on non-directory inode %" PRIu64 "\n" ),
> +						lino);
> +				}
>  				flags &= ~(XFS_DIFLAG_RTINHERIT |
>  						XFS_DIFLAG_EXTSZINHERIT |
>  						XFS_DIFLAG_PROJINHERIT |
> @@ -2592,9 +2603,11 @@ _("bad (negative) size %" PRId64 " on in
>  		if (flags & (XFS_DIFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) {
>  			/* must be a file */
>  			if (di_mode && !S_ISREG(di_mode)) {
> -				do_warn(
> -	_("file flags set on non-file inode %" PRIu64),
> -					lino);
> +				if (!uncertain) {
> +					do_warn(
> +	_("file flags set on non-file inode %" PRIu64 "\n"),
> +						lino);
> +				}
>  				flags &= ~(XFS_DIFLAG_REALTIME |
>  						XFS_XFLAG_EXTSIZE);
>  			}
> 

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

---end quoted text---


--===============1853539644010595137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1853539644010595137==--
