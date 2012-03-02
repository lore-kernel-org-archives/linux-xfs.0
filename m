Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22M9rdA161560 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 16:09:54 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id RInth8U2HHhKTBRR for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 14:09:52 -0800 (PST)
Message-ID: <4F51452F.90608@sandeen.net>
Date: Fri, 02 Mar 2012 16:09:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] repair: fix messages from set_nlinks
References: <20120228174223.GA6148@infradead.org>
	<20120228174251.GB6148@infradead.org>
In-Reply-To: <20120228174251.GB6148@infradead.org>
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

On 2/28/12 11:42 AM, Christoph Hellwig wrote:
> Link counts are unsigned and need to be printed as such.  Also only
> print the varning about upgrading the inode version if the inode was
            warning

> version 1 before.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Well you got reviews for the hard part, 1/2 :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> Index: xfsprogs-dev/repair/phase7.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/phase7.c	2012-02-28 12:45:52.627849317 +0100
> +++ xfsprogs-dev/repair/phase7.c	2012-02-28 14:03:20.475986024 +0100
> @@ -40,19 +40,20 @@ set_nlinks(
>  
>  	if (!no_modify) {
>  		*dirty = 1;
> -		do_warn(_("resetting inode %" PRIu64 " nlinks from %d to %d\n"),
> +		do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
>  			ino, dinoc->di_nlink, nrefs);
>  
> -		if (nrefs > XFS_MAXLINK_1)  {
> +		if (dinoc->di_version == 1 && nrefs > XFS_MAXLINK_1)  {
>  			ASSERT(fs_inode_nlink);
>  			do_warn(
> -_("nlinks %d will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
> +_("nlinks %u will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
>  				nrefs, ino);
>  
>  		}
>  		dinoc->di_nlink = nrefs;
>  	} else  {
> -		do_warn(_("would have reset inode %" PRIu64 " nlinks from %d to %d\n"),
> +		do_warn(
> +_("would have reset inode %" PRIu64 " nlinks from %u to %u\n"),
>  			ino, dinoc->di_nlink, nrefs);
>  	}
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
