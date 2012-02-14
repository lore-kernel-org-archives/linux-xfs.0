Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EJ7wvh117975 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 13:07:59 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wXFiOiMp29BmYVvu (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Feb 2012 11:07:57 -0800 (PST)
Date: Tue, 14 Feb 2012 14:07:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120214190753.GA8383@infradead.org>
References: <4F3A5B49.6020803@cape-horn-eng.com> <4F3AA191.9030606@mnsu.edu>
	<4F3AA40D.50302@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3AA40D.50302@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>, xfs@oss.sgi.com

On Tue, Feb 14, 2012 at 07:12:29PM +0100, Richard Ems wrote:
> # /net/c3m/usr/local/software/XFS/summarise_stat.pl /bin/
>       9  6.2% are scripts (shell, perl, whatever)
>      65 44.8% don't use any stat() family calls at all
>      61 42.1% use 32-bit stat() family interfaces only
>       9  6.2% use 64-bit stat64() family interfaces only
>       1  0.7% use both 32-bit and 64-bit stat() family interfaces
> 
> So I was not sure if I should use inode64 or not.

Are you on a 32-bit system (userspace, kernel doesn't matter)?

If the system is 64-bit even the plain stat handles 64-bit inodes just
fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
