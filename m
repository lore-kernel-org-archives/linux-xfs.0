Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o936HxLR238920 for <xfs@oss.sgi.com>; Sun, 3 Oct 2010 01:18:00 -0500
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B40CC1E750CB
	for <xfs@oss.sgi.com>; Sat,  2 Oct 2010 23:18:59 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id ATiaBEm1SLsdGOez for
	<xfs@oss.sgi.com>; Sat, 02 Oct 2010 23:18:59 -0700 (PDT)
Date: Sun, 3 Oct 2010 02:18:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Linux and DMAPI
Message-ID: <20101003061854.GA24293@infradead.org>
References: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
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
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: xfs@oss.sgi.com

On Sat, Sep 18, 2010 at 09:08:16PM -0300, Diego Woitasen wrote:
> Hi,
>  I'm looking for software that supports DMAPI on Linux. I haven't
> found anything on the web. I need to implement HSM for a mail server,
> to store old messages in a secondary storage.
> 
>  Are there something implemented? Open source or propietary one? I
> prefer open source obviously...

The XFS on disk format supports the required metadata for DMAPI, but the
implementation for it never made it into the mainline Linux kernel.  For
years SGI provided a tree to add the support, but for the last few years
the support bitrotted heavily.  Alex promised to publush a tree with
updated DMAPI support in the near future.

You'll still need additional userspace support the to actually driver
the migration.  The xfstests suite has a minimal implementation for QA
purposes as free software, but I don't think that's what your looking
for.  The main user of the XFS DMAPI support is SGI's DMF product,
and at least a few years ago IBM's Tivoli Storage Manager also supported
DMAPI.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
