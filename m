Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9ugvk225102 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:56:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDBBF1C4E8B1
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:58:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UgUrhpdqOdqCHSbX for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:58:15 -0800 (PST)
Date: Wed, 17 Nov 2010 04:58:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: WARNING: at fs/xfs/linux-2.6/xfs_aops.c:1289
	xfs_vm_releasepage+0x32/0x41()
Message-ID: <20101117095815.GA5531@infradead.org>
References: <4CE33550.1040302@mnsu.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CE33550.1040302@mnsu.edu>
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
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: xfs@oss.sgi.com

On Tue, Nov 16, 2010 at 07:52:16PM -0600, Jeffrey Hundstad wrote:
> Hello,
> 
> I'm not sure if this is interesting at all.  Let me know if it is, I
> can do bisects if needed, let me know which config additions you
> need for debugging.

It's very interesting.  I put these WARN_ONs in because we believed we
could never get a releasepage call with delayed or unwritten extents
still on.  Previous it could happen during truncate, but with the new
truncate sequence that should be gone.  Your trace on the other hand
comes from kswapd.

>  [<c1019687>] ? warn_slowpath_common+0x7c/0x8f
>  [<c10dbdcc>] ? xfs_vm_releasepage+0x32/0x41
>  [<c10dbdcc>] ? xfs_vm_releasepage+0x32/0x41
>  [<c10196b5>] ? warn_slowpath_null+0x1b/0x1e
>  [<c10dbdcc>] ? xfs_vm_releasepage+0x32/0x41
>  [<c1046672>] ? try_to_release_page+0x2c/0x3c
>  [<c104fc12>] ? shrink_page_list+0x47d/0x5e3
>  [<c104ea7a>] ? isolate_lru_pages+0x64/0x1cf
>  [<c104fee4>] ? shrink_inactive_list+0x16c/0x1f3
>  [<c1050272>] ? shrink_zone+0x307/0x3af
>  [<c10506c6>] ? kswapd+0x3ac/0x574
>  [<c102b335>] ? autoremove_wake_function+0x0/0x31
>  [<c105031a>] ? kswapd+0x0/0x574
>  [<c102b15f>] ? kthread+0x62/0x67
>  [<c102b0fd>] ? kthread+0x0/0x67
>  [<c1002b16>] ? kernel_thread_helper+0x6/0x10

This looks like some sort of race between writepage and redirtying.

Let me think about it a bit more, but I think it's harmless.  What
worries me more is that aptitude is apparently able to trigger
kswapd writeback easily.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
