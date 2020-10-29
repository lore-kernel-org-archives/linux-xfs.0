Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AC4C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 12:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D832620796
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 12:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqqH0mbv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgJ2MJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 08:09:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbgJ2MJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 08:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603973350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmL3VWpI7zPBibgY3qXNaxnvkag2a9L9y2m4S8oChQ4=;
        b=KqqH0mbvEsMMfUGkbsRQ3pb37HK3Cvw3tlxugXE7ixrqPB9Z8cfp5m57FSj9if7HHsS3hJ
        EoR/WjKXQIM8yY/ZGwfhKRw2knONCfYHY20lMdnx+1nPQyiVP+FrWRYG1upVBjQY5hT9K/
        3Sw+Tpek4iAKp6OffpVqoIEIJU1ehuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-piVOUlItMviIn1MKZihZxg-1; Thu, 29 Oct 2020 08:09:08 -0400
X-MC-Unique: piVOUlItMviIn1MKZihZxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8792F1882FBB;
        Thu, 29 Oct 2020 12:09:07 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F3F111974D;
        Thu, 29 Oct 2020 12:09:06 +0000 (UTC)
Date:   Thu, 29 Oct 2020 08:09:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs_db: add inobtcnt upgrade path
Message-ID: <20201029120905.GA1657878@bfoster>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521801.880355.2055596956122419535.stgit@magnolia>
 <20201028172925.GD1611922@bfoster>
 <20201029000332.GG1061252@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029000332.GG1061252@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 05:03:32PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 28, 2020 at 01:29:25PM -0400, Brian Foster wrote:
> > On Mon, Oct 26, 2020 at 04:33:38PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Enable users to upgrade their filesystems to support inode btree block
> > > counters.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  db/sb.c              |   76 +++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  db/xfs_admin.sh      |    4 ++-
> > >  man/man8/xfs_admin.8 |   16 +++++++++++
> > >  3 files changed, 94 insertions(+), 2 deletions(-)
> > > 
> > > 
...
> > > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > > index 8afc873fb50a..65ca6afc1e12 100644
> > > --- a/man/man8/xfs_admin.8
> > > +++ b/man/man8/xfs_admin.8
...
> > > @@ -103,6 +105,20 @@ The filesystem label can be cleared using the special "\c
> > >  " value for
> > >  .IR label .
> > >  .TP
> > > +.BI \-O " feature"
> > > +Add a new feature to the filesystem.
> > > +Only one feature can be specified at a time.
> > > +Features are as follows:
> > > +.RS 0.7i
> > > +.TP
> > > +.B inobtcount
> > > +Upgrade the filesystem to support the inode btree counters feature.
> > > +This reduces mount time by caching the size of the inode btrees in the
> > > +allocation group metadata.
> > > +Once enabled, the filesystem will not be writable by older kernels.
> > > +The filesystem cannot be downgraded after this feature is enabled.
> > 
> > Any reason for not allowing the downgrade path? It seems like we're
> > mostly there implementation wise and that might facilitate enabling the
> > feature by default.
> 
> Downgrading will not be easy for bigtime, since we'd have to scan the
> whole fs to see if there are any timestamps past 2038.  For other
> features it might not be such a big deal, but in general I don't want to
> increase our testing burden even further.
> 

Well it's not something I'd say we should necessarily support for every
feature. TBH, I wasn't expecting an upgrade mechanism for inobtcount in
the first place since I thought we didn't tend to do that for v5
filesystems. ISTM it's simple enough to support and perhaps that's good
enough reason to do so, but if we're going to move the "test burden"
line anyways it seems rather arbitrary to me to support one direction
and not the other when they are presumably of comparable complexity.
Just my .02 of course, and I don't feel strongly about whether we
support upgrade, downgrade, or neither...

Brian

> I'll ask the ext4 folks if they know of people downgrading filesystems
> with tune2fs, but AFAIK it's not generally done.
> 
> --D
> 
> > Brian
> > 
> > > +.RE
> > > +.TP
> > >  .BI \-U " uuid"
> > >  Set the UUID of the filesystem to
> > >  .IR uuid .
> > > 
> > 
> 

