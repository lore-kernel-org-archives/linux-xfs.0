Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6T9oF9U037183 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 04:50:15 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4747411F6EF4
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 02:50:34 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	2tYg2SODtsBoKH0P for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2011 02:50:34 -0700 (PDT)
Received: by gyg10 with SMTP id 10so2827822gyg.26
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 02:50:13 -0700 (PDT)
Date: Fri, 29 Jul 2011 18:50:05 +0900
From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC PATCH 0/8] Reduce filesystem writeback from page reclaim v2
Message-ID: <20110729095005.GH1843@barrios-desktop>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<20110727161821.GA1738@barrios-desktop>
	<20110728113852.GN3010@suse.de>
	<20110729094816.GG1843@barrios-desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110729094816.GG1843@barrios-desktop>
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
To: Mel Gorman <mgorman@suse.de>, Andrew Lutomirski <luto@mit.edu>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

Sorry for missing Ccing.

On Fri, Jul 29, 2011 at 06:48:16PM +0900, Minchan Kim wrote:
> On Thu, Jul 28, 2011 at 12:38:52PM +0100, Mel Gorman wrote:
> > On Thu, Jul 28, 2011 at 01:18:21AM +0900, Minchan Kim wrote:
> > > On Thu, Jul 21, 2011 at 05:28:42PM +0100, Mel Gorman wrote:
> > > > Note how preventing kswapd reclaiming dirty pages pushes up its CPU
> 
> <snip>
> 
> > > > usage as it scans more pages but it does not get excessive due to
> > > > the throttling.
> > > 
> > > Good to hear.
> > > The concern of this patchset was early OOM kill with too many scanning.
> > > I can throw such concern out from now on.
> > > 
> > 
> > At least, I haven't been able to trigger a premature OOM.
> 
> AFAIR, Andrew had a premature OOM problem[1] but I couldn't track down at that time.
> I think this patch series might solve his problem. Although it doesn't, it should not accelerate
> his problem, at least.
> 
> Andrew, Could you test this patchset?
> 
> [1] https://lkml.org/lkml/2011/5/25/415
> -- 
> Kind regards,
> Minchan Kim

-- 
Kind regards,
Minchan Kim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
