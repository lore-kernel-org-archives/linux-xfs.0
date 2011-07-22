Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MFq5OP092388 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 10:52:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 750C917ACCF4
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 08:52:01 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JZJZ7eksLlqfD70f for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 08:52:01 -0700 (PDT)
Date: Fri, 22 Jul 2011 11:52:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] adding example with xfs_info output decryption
Message-ID: <20110722155200.GA31867@infradead.org>
References: <BANLkTikjPhKNBVUamccXbAropDw=oBSRgg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikjPhKNBVUamccXbAropDw=oBSRgg@mail.gmail.com>
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
To: CoolCold <coolthecold@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 23, 2011 at 02:34:54AM +0400, CoolCold wrote:
> Basing on irc discussions and questions about reading xfs_info output
> I've added example in xfs_growfs manpage.

Alex, Dave, Eric, do you guys have any comments on this?  Language
nitpicks from the native speakers?  Otherwise I'd be inclined to put it
in.

> Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
> ---
>  man/man8/xfs_growfs.8 |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
> index 02793ae..c782fc1 100644
> --- a/man/man8/xfs_growfs.8
> +++ b/man/man8/xfs_growfs.8
> @@ -1,3 +1,14 @@
> +.\" Verbatim blocks taken from openssl req manpage content
> +.de Vb \" Begin verbatim text
> +.ft CW
> +.nf
> +.ne \\$1
> +..
> +.de Ve \" End verbatim text
> +.ft R
> +.fi
> +..
> +
>  .TH xfs_growfs 8
>  .SH NAME
>  xfs_growfs, xfs_info \- expand an XFS filesystem
> @@ -105,6 +116,7 @@ this is specified with
>  Specifies that no change to the filesystem is to be made.
>  The filesystem geometry is printed, and argument checking is performed,
>  but no growth occurs.
> +.B See output examples below.
>  .TP
>  .BI "\-r | \-R " size
>  Specifies that the real-time section of the filesystem should be grown. If the
> @@ -152,6 +164,28 @@ reside. In order to grow a filesystem, it is
> necessary to provide added
>  space for it to occupy. Therefore there must be at least one spare new
>  disk partition available. Adding the space is often done through the use
>  of a logical volume manager.
> +.SH "EXAMPLES"
> +
> +Examining xfs_info output.
> +.PP
> +Let's assume one have the next xfs_info output:
> +.PP
> +.Vb 1
> +\& meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
> +\&          =              sectsz=512   attr=2
> +\& data     =              bsize=4096   blocks=536869888, imaxpct=5
> +\&          =              sunit=32     swidth=128 blks
> +\& naming   =version 2     bsize=4096
> +\& log      =internal      bsize=4096   blocks=32768, version=2
> +\&          =              sectsz=512   sunit=32 blks, lazy-count=1
> +\& realtime =none          extsz=524288 blocks=0, rtextents=0
> +.Ve
> +.PP
> +
> +Here, data section block size (bsize) is 4096 bytes. Therefore
> +"sunit=32 swidth=128 blks" means stripe unit is 32*4096 bytes = 128 kibibytes
> +and stripe width is 128*4096 bytes = 512 kibibytes. Filesystem is striped
> +over 4 ( 128 / 32 ) stripes.
>  .SH SEE ALSO
>  .BR mkfs.xfs (8),
>  .BR md (4),
> -- 
> 1.7.2.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
