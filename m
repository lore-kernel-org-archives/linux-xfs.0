Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13EC37CA1
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:40:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C1F968F8059
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 07:40:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 260zsbPratHROw4l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 07:40:24 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 30C3CA147A
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:40:24 +0000 (UTC)
Received: from redhat.com (unused [10.10.50.219] (may be forged))
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4BEeJpA005779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 11 May 2016 10:40:22 -0400
Date: Wed, 11 May 2016 16:40:19 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V4]
Message-ID: <20160511144019.GB7828@redhat.com>
References: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
	<20160511141558.GE42410@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160511141558.GE42410@bfoster.bfoster>
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

On Wed, May 11, 2016 at 10:15:59AM -0400, Brian Foster wrote:
> On Tue, May 10, 2016 at 02:16:14PM +0200, Carlos Maiolino wrote:
> > New revision ot the patchset according with comments for V3.
> > 
> > This patchset is aimed to implement a configurable error behavior in XFS, and,
> > most of the design has been done by Dave, so, I kept his signed-off.
> > 
> > Detailed changelog is written on each patch, but, major changes are:
> > 
> > 	- make fail_at_unmount a global configuration option inside
> > 	  ../xfs/<dev>/err/fail_at_unmount
> > 
> 
> Any reason you didn't carry the reviewed-by tags from v3?

No reason Brian, I just completely forgot to carry the tags to the new version,
sorry for the extra work.

> 
> For Dave's convenience (and based on the reviews of v3 and v4), for the
> series:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > Carlos Maiolino (7):
> >   xfs: configurable error behavior via sysfs
> >   xfs: introduce metadata IO error class
> >   xfs: add configurable error support to metadata buffers
> >   xfs: introduce table-based init for error behaviors
> >   xfs: add configuration of error failure speed
> >   xfs: add configuration handlers for specific errors
> >   xfs: add "fail at unmount" error handling configuration
> > 
> >  fs/xfs/xfs_buf.h      |  20 ++++
> >  fs/xfs/xfs_buf_item.c | 121 +++++++++++++--------
> >  fs/xfs/xfs_mount.c    |  22 +++-
> >  fs/xfs/xfs_mount.h    |  34 ++++++
> >  fs/xfs/xfs_sysfs.c    | 291 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_sysfs.h    |   3 +
> >  fs/xfs/xfs_trace.h    |   1 -
> >  7 files changed, 446 insertions(+), 46 deletions(-)
> > 
> > -- 
> > 2.4.11
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
