Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECBF77CA0
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 13:43:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AD9EE30404E
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 11:43:18 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4mddH4VHkJCsGdVJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 11:43:16 -0700 (PDT)
Date: Fri, 26 Aug 2016 11:42:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v8 00/71] xfs: add reflink and dedupe support
Message-ID: <20160826184246.GF20705@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<20160826125636.GA1548@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826125636.GA1548@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 05:56:36AM -0700, Christoph Hellwig wrote:
> FTI, with your djwong-devel tree I see sporadic slab corruption when
> running xfstests with reflinks force enabled in mkfs.
> 
> And while the trace looks like from the rmap code it doesn't happen
> without the reflink patches.
> 
> Example during xfs/313 below:

Ok, so this was caused by a bug in the deferred ops abort code where we'd
unconditionally free a log intent item even if a log done item has already been
attached.  That in turn led to the intent item being freed three times (once
when the CUI was committed, again when the deferred op aborted, and again when
the CUD was committed during transaction abort), hence the slab corruption.
Oops.

Will post patch shortly.

--D

> 
> [14751.774252] Slab corruption (Tainted: G        W      ): xfs_cui_item start=ffff88013afb3748, len=408
> [14751.775170] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [14751.775731] Last user: [<ffffffff815ce4cc>](xfs_cui_item_free+0x1c/0x30)
> [14751.776397] 070: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b kkkkkkkkjkkkkkkk
> [14751.777157] Single bit error detected. Probably bad RAM.
> [14751.777591] Run memtest86+ or a similar memory test tool.
> [14751.778015] Prev obj: start=ffff88013afb3598, len=408
> [14751.778468] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [14751.778940] Last user:
> [<ffffffff815ce4cc>](xfs_cui_item_free+0x1c/0x30)
> [14751.779621] 000: 6b 6b 6b 6b 6b 00 01 02 03 6b 6b 6b 6b 6b 6b 6b kkkkk....kkkkkkk
> [14751.780378] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [14751.781140] Next obj: start=ffff88013afb38f8, len=408
> [14751.781639] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [14751.782216] Last user:
> [<ffffffff815ce4cc>](xfs_cui_item_free+0x1c/0x30)
> [14751.782885] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [14751.783608] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [14751.784287] Slab corruption (Tainted: G        W      ): xfs_bui_item start=ffff880131b67048, len=184
> [14751.785126] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [14751.785979] Last user: [<ffffffff815c9584>](xfs_bui_release+0x44/0x70)0
> [14751.786636] 070: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b kkkkkkkkjkkkkkkk
> [14751.787414] Single bit error detected. Probably bad RAM.
> [14751.787948] Run memtest86+ or a similar memory test tool.
> [14751.788477] Next obj: start=ffff880131b67118, len=184
> [14751.789002] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [14751.789559] Last user: [<ffffffff815c9584>](xfs_bui_release+0x44/0x70)
> [14751.790259] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [14751.791055] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
