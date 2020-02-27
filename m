Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF90EC35677
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 15:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 953E524688
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 15:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TSuFgnfS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgB0PS1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 10:18:27 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30552 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729652AbgB0PS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 10:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582816705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=//5p8H7T6tAW+fdfl1MHeeI5aeOQRtXoVd6PAFlrf9U=;
        b=TSuFgnfSrvg1+c6eqZe7MTb8MJCXnaDocXDt5/SZtdB7d2GuZcdns30WuXP7xvQoNed1Aa
        bVKTr+UnaU7xu8EmxVRqcQzKo3PZ42BV5b1qQ6Pd7bSUGjJjcPLO6FjwGj33jr5j/RASuf
        flXaj/i6IRe6f1PVzyvRIMwM2mTRJV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-tloleKH6PEe9yxCSGvG7LA-1; Thu, 27 Feb 2020 10:18:17 -0500
X-MC-Unique: tloleKH6PEe9yxCSGvG7LA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1AD71005F62;
        Thu, 27 Feb 2020 15:18:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73ABF90767;
        Thu, 27 Feb 2020 15:18:16 +0000 (UTC)
Date:   Thu, 27 Feb 2020 10:18:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 0/9] xfs: automatic relogging experiment
Message-ID: <20200227151814.GA6320@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227150936.GL8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227150936.GL8045@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 07:09:36AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 27, 2020 at 08:43:12AM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's a v5 RFC of the automatic item relogging experiment. Firstly,
> > note that this is still a POC and experimental code with various quirks.
> 
> Heh, funny, I was going to ask you if you might have time next week to
> review the latest iteration of the btree bulk loading series so that I
> could get closer to merging the rest of online repair and/or refactoring
> offline repair.  I'll take a closer look at this after I read through
> everything else that came in overnight.
> 

Sure.. I can put that next on the list. Is the latest release pending a
post or already posted? Being out for over a month (effectively closer
to two when considering proximity to the holidays) caused me to pretty
much clear everything in my mailbox for obvious reasons. ;) As a result,
anything that might have been on my radar prior to that timeframe has
most likely dropped completely off it. :P

Brian

> --D
> 
> > Some are documented in the code, others might not be (such as abusing
> > the AIL lock, etc.). The primary purpose of this series is still to
> > express and review a fundamental design. Based on discussion on the last
> > version, there is specific focus towards addressing log reservation and
> > pre-item locking deadlock vectors. While the code is still quite hacky,
> > I believe this design addresses both of those fundamental issues.
> > Further details on the design and approach are documented in the
> > individual commit logs.
> > 
> > In addition, the final few patches introduce buffer relogging capability
> > and test infrastructure, which currently has no use case other than to
> > demonstrate development flexibility and the ability to support arbitrary
> > log items in the future, if ever desired. If this approach is taken
> > forward, the current use cases are still centered around intent items
> > such as the quotaoff use case and extent freeing use case defined by
> > online repair of free space trees.
> > 
> > On somewhat of a tangent, another intent oriented use case idea crossed
> > my mind recently related to the long standing writeback stale data
> > exposure problem (i.e. if we crash after a delalloc extent is converted
> > but before writeback fully completes on the extent). The obvious
> > approach of using unwritten extents has been rebuffed due to performance
> > concerns over extent conversion. I wonder if we had the ability to log a
> > "writeback pending" intent on some reasonable level of granularity (i.e.
> > something between a block and extent), whether we could use that to
> > allow log recovery to zero (or convert) such extents in the event of a
> > crash. This is a whole separate design discussion, however, as it
> > involves tracking outstanding writeback, etc. In this context it simply
> > serves as a prospective use case for relogging, as such intents would
> > otherwise risk similar log subsystem deadlocks as the quotaoff use case.
> > 
> > Thoughts, reviews, flames appreciated.
> > 
> > Brian
> > 
> > rfcv5:
> > - More fleshed out design to prevent log reservation deadlock and
> >   locking problems.
> > - Split out core patches between pre-reservation management, relog item
> >   state management and relog mechanism.
> > - Added experimental buffer relogging capability.
> > rfcv4: https://lore.kernel.org/linux-xfs/20191205175037.52529-1-bfoster@redhat.com/
> > - AIL based approach.
> > rfcv3: https://lore.kernel.org/linux-xfs/20191125185523.47556-1-bfoster@redhat.com/
> > - CIL based approach.
> > rfcv2: https://lore.kernel.org/linux-xfs/20191122181927.32870-1-bfoster@redhat.com/
> > - Different approach based on workqueue and transaction rolling.
> > rfc: https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat.com/
> > 
> > Brian Foster (9):
> >   xfs: set t_task at wait time instead of alloc time
> >   xfs: introduce ->tr_relog transaction
> >   xfs: automatic relogging reservation management
> >   xfs: automatic relogging item management
> >   xfs: automatic log item relog mechanism
> >   xfs: automatically relog the quotaoff start intent
> >   xfs: buffer relogging support prototype
> >   xfs: create an error tag for random relog reservation
> >   xfs: relog random buffers based on errortag
> > 
> >  fs/xfs/libxfs/xfs_errortag.h   |   4 +-
> >  fs/xfs/libxfs/xfs_shared.h     |   1 +
> >  fs/xfs/libxfs/xfs_trans_resv.c |  24 +++-
> >  fs/xfs/libxfs/xfs_trans_resv.h |   1 +
> >  fs/xfs/xfs_buf_item.c          |   5 +
> >  fs/xfs/xfs_dquot_item.c        |   7 ++
> >  fs/xfs/xfs_error.c             |   3 +
> >  fs/xfs/xfs_log.c               |   2 +-
> >  fs/xfs/xfs_qm_syscalls.c       |  12 +-
> >  fs/xfs/xfs_trace.h             |   3 +
> >  fs/xfs/xfs_trans.c             |  79 +++++++++++-
> >  fs/xfs/xfs_trans.h             |  13 +-
> >  fs/xfs/xfs_trans_ail.c         | 216 ++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_trans_buf.c         |  35 ++++++
> >  fs/xfs/xfs_trans_priv.h        |   6 +
> >  15 files changed, 399 insertions(+), 12 deletions(-)
> > 
> > -- 
> > 2.21.1
> > 
> 

