Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4UG7LdH150902 for <xfs@oss.sgi.com>; Sat, 30 May 2009 11:07:21 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ACFC2AF0B2
	for <xfs@oss.sgi.com>; Sat, 30 May 2009 09:07:36 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id RL6hLYocBxnGCHug for
	<xfs@oss.sgi.com>; Sat, 30 May 2009 09:07:36 -0700 (PDT)
Date: Sat, 30 May 2009 18:14:25 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] xfs: prevent deadlock in xfs_qm_shake()
Message-ID: <20090530161425.GO1065@one.firstfloor.org>
References: <1243620631-10749-1-git-send-email-felixb@sgi.com>
	<1243620631-10749-2-git-send-email-felixb@sgi.com>
	<20090529192529.GA1599@infradead.org>
	<87d49qeuqd.fsf@basil.nowhere.org>
	<1A09BC73-E1E8-4EF4-AD29-FB93556C3E3B@sgi.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1A09BC73-E1E8-4EF4-AD29-FB93556C3E3B@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>, Hedi Berriche <hedi@sgi.com>, xfs@oss.sgi.com

On Sat, May 30, 2009 at 09:57:20AM -0500, Felix Blyakher wrote:
> 
> (gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS)  != 0   or as Andi noted
> (gfp_mask & (__GFP_WAIT|__GFP_FS)) == (__GFP_WAIT|__GFP_FS)
> 
> I'd prefer the former, as in my original patch.
> 
> Also, I accidentally put an extra open brace in a statement. After a
> successful build I started playing with braces for more readability,
> and left it in inconsistent state.
> Seems like the preferred style in the kernel is as following:
> 
> return ((gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) != 0;

I would say it is

return (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS);

The != 0 is completely superfluous.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
