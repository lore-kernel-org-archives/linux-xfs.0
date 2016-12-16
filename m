Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:34054 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbcLPWBa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2016 17:01:30 -0500
Date: Fri, 16 Dec 2016 23:01:21 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/9 v2] xfs: introduce and use KM_NOLOCKDEP to silence
 reclaim lockdep false positives
Message-ID: <20161216220121.GC7645@dhcp22.suse.cz>
References: <20161215140715.12732-1-mhocko@kernel.org>
 <20161215140715.12732-3-mhocko@kernel.org>
 <20161216154041.GA7645@dhcp22.suse.cz>
 <20161216163749.GE8447@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216163749.GE8447@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

On Fri 16-12-16 11:37:50, Brian Foster wrote:
> On Fri, Dec 16, 2016 at 04:40:41PM +0100, Michal Hocko wrote:
> > Updated patch after Mike noticed a BUG_ON when KM_NOLOCKDEP is used.
> > ---
> > From 1497e713e11639157aef21cae29052cb3dc7ab44 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.com>
> > Date: Thu, 15 Dec 2016 13:06:43 +0100
> > Subject: [PATCH] xfs: introduce and use KM_NOLOCKDEP to silence reclaim
> >  lockdep false positives
> > 
> > Now that the page allocator offers __GFP_NOLOCKDEP let's introduce
> > KM_NOLOCKDEP alias for the xfs allocation APIs. While we are at it
> > also change KM_NOFS users introduced by b17cb364dbbb ("xfs: fix missing
> > KM_NOFS tags to keep lockdep happy") and use the new flag for them
> > instead. There is really no reason to make these allocations contexts
> > weaker just because of the lockdep which even might not be enabled
> > in most cases.
> > 
> 
> Hi Michal,
> 
> I haven't gone back to fully grok b17cb364dbbb ("xfs: fix missing
> KM_NOFS tags to keep lockdep happy"), so I'm not really familiar with
> the original problem. FWIW, there was another KM_NOFS instance added by
> that commit in xlog_cil_prepare_log_vecs() that is now in
> xlog_cil_alloc_shadow_bufs(). Perhaps Dave can confirm whether the
> original issue still applies..?

Yes, I've noticed that but the reworked code looked sufficiently
different that I didn't dare to simply convert it.
-- 
Michal Hocko
SUSE Labs
