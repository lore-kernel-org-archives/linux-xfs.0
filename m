Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63E461q096376 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 09:04:06 -0500
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id nDSEg2Y5hOXnjSRD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Jul 2012 07:04:05 -0700 (PDT)
Received: by weyt57 with SMTP id t57so93959wey.26
	for <xfs@oss.sgi.com>; Tue, 03 Jul 2012 07:04:04 -0700 (PDT)
Date: Tue, 3 Jul 2012 16:04:01 +0200
From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120703140401.GB5103@phenom.ffwll.local>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	<20120629112505.GF14154@suse.de> <20120701235458.GM19223@dastard>
	<20120702063226.GA32151@infradead.org>
	<20120702143215.GS14154@suse.de> <20120702193516.GX14154@suse.de>
	<20120703130414.GD14154@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703130414.GD14154@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Keith Packard <keithp@keithp.com>, Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Eugeni Dodonov <eugeni.dodonov@intel.com>

On Tue, Jul 03, 2012 at 02:04:14PM +0100, Mel Gorman wrote:
> On Mon, Jul 02, 2012 at 08:35:16PM +0100, Mel Gorman wrote:
> > > <SNIP>
> > >
> > It was obvious very quickly that there were two distinct regression so I
> > ran two bisections. One led to a XFS and the other led to an i915 patch
> > that enables RC6 to reduce power usage.
> > 
> > [c999a223: xfs: introduce an allocation workqueue]
> > [aa464191: drm/i915: enable plain RC6 on Sandy Bridge by default]
> > 
> > gdm was running on the machine so i915 would have been in use. 
> 
> Bah, more PEBKAC. gdm was *not* running on this machine. i915 is loaded
> but X is not.

See my little explanation of rc6, just loading the driver will have
effects. But I'm happy to know that the issue also happens without using
it, makes it really unlikely it's an issue with the gpu or i915.ko ;-)
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
