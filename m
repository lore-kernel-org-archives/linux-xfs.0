Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8P9YeGl037708 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 04:34:40 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JzjEsfOtzpcJCzoP (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 02:35:57 -0700 (PDT)
Date: Tue, 25 Sep 2012 05:35:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: make inode64 as the default allocation mode
Message-ID: <20120925093556.GD9189@infradead.org>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1348147961-7520-3-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2178303392625704024=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

--===============2178303392625704024==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 20, 2012 at 10:32:37AM -0300, Carlos Maiolino wrote:
> since 64-bit inodes can be accessed while using inode32, and these can also be
> used on 32-bit kernels, there is no reason to still keep inode32 as the default
> mount option.
> If the filesystem cannot handle 64bit inode numbers (i.e CONFIG_LBDAF is not
> enabled and BITS_PER_LONG == 32), XFS_MOUNT_SMALL_INUMS will still be set by
> default, so inode64 is not an unconditional default value.

Btw, I think we should kill the !BIG_INUMS mode and just
require CONFIG_LBDAF on 32-bit, as the small in-core inums are å
codepath that rarely if ever is tested and not really useful these days.

But that should be a separate patch, so:


Reviewed-by: Christoph Hellwig <hch@lst.de>


--===============2178303392625704024==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2178303392625704024==--
