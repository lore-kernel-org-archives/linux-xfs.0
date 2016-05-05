Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5CC47CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 09:37:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6CE7304062
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:37:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nD2vpHR2ZMcbEDQU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 07:37:23 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 12B036436D
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:37:23 +0000 (UTC)
Received: from redhat.com (unused [10.10.51.18] (may be forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u45EbIUl025655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Thu, 5 May 2016 10:37:22 -0400
Date: Thu, 5 May 2016 16:37:18 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V3]
Message-ID: <20160505143718.GB9359@redhat.com>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<20160505141107.GG1231@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160505141107.GG1231@bfoster.bfoster>
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
To: xfs@oss.sgi.com

On Thu, May 05, 2016 at 10:11:07AM -0400, Brian Foster wrote:
> On Wed, May 04, 2016 at 05:43:13PM +0200, Carlos Maiolino wrote:
> > This is the new revision of this patchset, according to last comments.
> > 
> > This patchset is aimed to implement a configurable error behavior in XFS, and
> > most of the design has been done by Dave, so, that's why I kept his signed-off
> > in the patches.
> > 
> > This new revision has the detailed changelog written on each patch, but the
> > major changes are:
> > 
> > 	- Detailed changelog by-patch and description fixed to become
> > 	  (hopefuly) more clear
> > 	- kept fail_at_unmount as a sysfs attribute
> > 
> > 
> > Regarding fail_at_unmount, I left it almost exactly as Dave's design, giving his
> > comments on the last revision, although, I still think there is no need to keep
> > it as a per-error granularity, so, I was wondering if a single, global option in
> > /sys/fs/xfs/<dev>/error/fail_at_unmount wouldn't suffice, but, this will require
> > a new place to store the value inside kernel, instead of keeping it inside
> > struct xfs_error_cfg, or maybe use the same structure but use it outside of the
> > m_error_cfg array?
> > 
> 
> I agree with regard to the granularity of fail_at_unmount. This was
> brought up previously:
> 
> http://oss.sgi.com/archives/xfs/2016-02/msg00558.html
> 
> ... and I haven't heard a use case for per-error granularity.

Hi, yes, my comment was based on our previous discussion, my apologies to not
have made it clear.

> 
> I suggest just to pull it out of the error classification stuff entirely
> and place it under xfs_mount. E.g., at the same level as "fail_writes"
> (but not a DEBUG mode only option).
> 
> I'm also wondering whether we need more mechanism for the
> fail_at_unmount behavior. For example, instead of defining
> XFS_MOUNT_UNMOUNTING, could we just call a function that resets
> max_retries (of each class) to 0 in the unmount path? Then maybe call
> the mount tunable retry_on_unmount or something like that. Thoughts?
> 
I don't oppose to that, although, having a flag like XFS_MOUNT_UNMOUNTING, might
be useful in the future, but still, wouldn't be better this single flag, instead
of walk through all classes/errors resetting the max_retries? It sounds as
granular as having fail_at_unmount inside each error, despite the fact it's not
exposed to user-space, we will need to interact over each max_retries to
actually shutdown the filesystem during unmount, which, is also error-prone
IMHO.
It also depends on how granular we will implement fail_at_unmount. If it's a
single global option, resetting all max_retries works, otherwise it might not
work, for example, if we decide to have fail_at_unmount for each class, we might
need to reset max_retries only in specific errors, which will increase the
complexity of the code.

Well, hope my comments make sense, just giving my $0.02 :)

cheers

> Brian
> 
> > First 6 patches are ready, the fail_at_unmount one, need to be re-worked if we
> > want it in a less granular way, but until now I don't think we reached any
> > decision about how it should be implemented.
> > 
> >  fs/xfs/xfs_buf.h      |  22 ++++
> >  fs/xfs/xfs_buf_item.c | 126 ++++++++++++++--------
> >  fs/xfs/xfs_mount.c    |  19 +++-
> >  fs/xfs/xfs_mount.h    |  32 ++++++
> >  fs/xfs/xfs_sysfs.c    | 283 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_sysfs.h    |   3 +
> >  6 files changed, 437 insertions(+), 48 deletions(-)
> > 
> > -- 
> > 2.4.11
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
