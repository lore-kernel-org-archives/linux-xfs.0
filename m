Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63D4L1i092307 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 08:04:21 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id aJFslKz3hBbLDekE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 06:04:20 -0700 (PDT)
Date: Tue, 3 Jul 2012 14:04:14 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120703130414.GD14154@suse.de>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	<20120629112505.GF14154@suse.de> <20120701235458.GM19223@dastard>
	<20120702063226.GA32151@infradead.org>
	<20120702143215.GS14154@suse.de> <20120702193516.GX14154@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120702193516.GX14154@suse.de>
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
Cc: Keith Packard <keithp@keithp.com>, Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Eugeni Dodonov <eugeni.dodonov@intel.com>

On Mon, Jul 02, 2012 at 08:35:16PM +0100, Mel Gorman wrote:
> > <SNIP>
> >
> It was obvious very quickly that there were two distinct regression so I
> ran two bisections. One led to a XFS and the other led to an i915 patch
> that enables RC6 to reduce power usage.
> 
> [c999a223: xfs: introduce an allocation workqueue]
> [aa464191: drm/i915: enable plain RC6 on Sandy Bridge by default]
> 
> gdm was running on the machine so i915 would have been in use. 

Bah, more PEBKAC. gdm was *not* running on this machine. i915 is loaded
but X is not.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
