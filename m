Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E75E87D06
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 07:12:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 679C9AC003
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 05:12:25 -0700 (PDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com
	[74.125.82.65]) by cuda.sgi.com with ESMTP id r0BHRPKECU4yDBeX
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Apr 2016 05:12:23 -0700 (PDT)
Received: by mail-wm0-f65.google.com with SMTP id n129so4585868wmn.1
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 05:12:23 -0700 (PDT)
Date: Fri, 29 Apr 2016 14:12:20 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm, debug: report when GFP_NO{FS,IO} is used
	explicitly from memalloc_no{fs,io}_{save,restore} context
Message-ID: <20160429121219.GL21977@dhcp22.suse.cz>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
	<1461671772-1269-3-git-send-email-mhocko@kernel.org>
	<20160426225845.GF26977@dastard>
	<20160428081759.GA31489@dhcp22.suse.cz>
	<20160428215145.GM26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160428215145.GM26977@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri 29-04-16 07:51:45, Dave Chinner wrote:
> On Thu, Apr 28, 2016 at 10:17:59AM +0200, Michal Hocko wrote:
> > [Trim the CC list]
> > On Wed 27-04-16 08:58:45, Dave Chinner wrote:
> > [...]
> > > Often these are to silence lockdep warnings (e.g. commit b17cb36
> > > ("xfs: fix missing KM_NOFS tags to keep lockdep happy")) because
> > > lockdep gets very unhappy about the same functions being called with
> > > different reclaim contexts. e.g.  directory block mapping might
> > > occur from readdir (no transaction context) or within transactions
> > > (create/unlink). hence paths like this are tagged with GFP_NOFS to
> > > stop lockdep emitting false positive warnings....
> > 
> > As already said in other email, I have tried to revert the above
> > commit and tried to run it with some fs workloads but didn't manage
> > to hit any lockdep splats (after I fixed my bug in the patch 1.2). I
> > have tried to find reports which led to this commit but didn't succeed
> > much. Everything is from much earlier or later. Do you happen to
> > remember which loads triggered them, what they looked like or have an
> > idea what to try to reproduce them? So far I was trying heavy parallel
> > fs_mark, kernbench inside a tiny virtual machine so any of those have
> > triggered direct reclaim all the time.
> 
> Most of those issues were reported by users and not reproducable by
> any obvious means.

I would really appreciate a reference to some of those (my google-fu has
failed me) or at least a pattern of those splats - was it 
"inconsistent {RECLAIM_FS-ON-[RW]} -> {IN-RECLAIM_FS-[WR]} usage"
or a different class reports?

> They may have been fixed since, but I'm sceptical
> of that because, generally speaking, developer testing only catches
> the obvious lockdep issues. i.e. it's users that report all the
> really twisty issues, and they are generally not reproducable except
> under their production workloads...
> 
> IOWs, the absence of reports in your testing does not mean there
> isn't a problem, and that is one of the biggest problems with
> lockdep annotations - we have no way of ever knowing if they are
> still necessary or not without exposing users to regressions and
> potential deadlocks.....

I understand your points here but if we are sure that those lockdep
reports are just false positives then we should rather provide an api to
silence lockdep for those paths than abusing GFP_NOFS which a) hurts
the overal reclaim healthiness and b) works around a non-existing
problem with lockdep disabled which is the vast majority of
configurations.

Thanks!
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
