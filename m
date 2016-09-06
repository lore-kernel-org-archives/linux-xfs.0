Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D08D7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 12:03:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D200C8F8037
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:03:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6xXxFOGdSAPwzr3l (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 10:03:21 -0700 (PDT)
Date: Tue, 6 Sep 2016 10:03:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/71] xfs: create refcount update intent log items
Message-ID: <20160906170319.GB22753@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216801436.867.13017543869659604138.stgit@birch.djwong.org>
	<20160906151603.GI24287@infradead.org>
	<20160906164341.GD16696@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906164341.GD16696@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 09:43:41AM -0700, Darrick J. Wong wrote:
> <shrug> I'm relatively indifferent either way, though I noticed that
> EFIs have a separate copy_format function in xfs_extfree_item.c which
> reduces the amount of clutter in xfs_log_recover.c.  It seemed more
> neat to keep all the log item functions corralled within a separate
> file rather than putting them in xfs_log_recover.c, so I maintained
> that pattern for the rui/cui/bui items.

The big difference with the EFI is that we had packing problems with
them so we might have to do a few different conversions.

> In a semi-related side note I've been toying with turning on LTO in
> xfsprogs to see how much it shrinks all the XFS code.  Code size goes
> down considerably (repair shrinks by nearly 1MB!) but wow the
> resulting tangle can be a PITA to debug.  :(

Yes. LTO is a nightmare for debugging.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
