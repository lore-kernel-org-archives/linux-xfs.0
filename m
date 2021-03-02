Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE2DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839C861494
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244936AbhCCDMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:12:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350392AbhCBMVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 07:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614687583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Rtdd+LyrmVY092AQNOiwq2MNPG+Z7thgz4Rfs1eTMY=;
        b=BF4i5tUHY37IZ5jXJQAHRqWpyefmD7AqtmSeiwqtX3OKLvk0Az2SPbjL6Z9mFsUG4iXugg
        yUo1+Butq7ySVZFDRaOONtux4+sIdy3QPNQum0IJYQehOck5UIy01ieqErC5bAvDinWCdq
        GpjGD4VsYOXZeb58FXIlmqgiVJU6dKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-CGPCxs7kP_myH4SVB0VGqA-1; Tue, 02 Mar 2021 07:19:41 -0500
X-MC-Unique: CGPCxs7kP_myH4SVB0VGqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 418461005501;
        Tue,  2 Mar 2021 12:19:40 +0000 (UTC)
Received: from bfoster (ovpn-113-160.rdu2.redhat.com [10.10.113.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E144189BB;
        Tue,  2 Mar 2021 12:19:39 +0000 (UTC)
Date:   Tue, 2 Mar 2021 07:19:37 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Geert Hendrickx <geert@hendrickx.be>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <YD4tWbfzmuXv1mKQ@bfoster>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
 <20210301191803.GE7269@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301191803.GE7269@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 11:18:03AM -0800, Darrick J. Wong wrote:
> [adding linux-xfs to cc]
> 
> On Mon, Mar 01, 2021 at 11:13:14AM +0100, Geert Hendrickx wrote:
> > Gentlemen
> > 
> > 
> > I've been testing xfsprogs 5.11.0-rc1 for XFS feature upgrades (inobtcount
> > and bigtime), and have a couple of small nits with it - besides the actual
> > functionality working as expected:
> > 
> > 1/ xfs_admin responds to every xfs_repair failure with the very generic
> > "Conversion failed, is the filesystem unmounted?"  This isn't very helpful
> > (and left me scratching my head in a number of scenarios), whereas calling
> > xfs_repair directly shows a relevant error message in all cases.  This
> > output should somehow be relayed through xfs_admin - without just dumping
> > the whole xfs_repair output which I know you wanted to avoid.  Maybe by
> > distinguishing more carefully between stderr and stdout?  (Currently, it
> > seems xfs_repair sends its errors to stdout and "normal output" to stderr,
> > and xfs_admin discards xfs_repair's stderr.)
> 
> That's a difficult project -- some of the things repair will complain
> about are a result of whatever the upgrade is (e.g. complaining about
> incorrect inode btree counters when you're in the process of enabling
> the counters) but then there are other things that it probably should
> not be dropping on the floor.
> 

It's not clear to me if you're reporting that feature upgrades
spuriously report this "Conversion failed ..." message (i.e., feature
upgrade succeeded, but repair found and fixed things expected to be
problems due to the feature upgrade), or that this error is reported if
there is something independently wrong with the fs. If the former, that
seems like a bug. If the latter, I think that's reasonable/expected
behavior.

IMO, the fact that the feature upgrade runs xfs_repair is an
implementation detail. There's no guarantee that repair might always be
necessary for this operation or that it would find/fix other issues when
running for the purpose of a feature upgrade. For that reason, I don't
think it makes a whole lot of sense to try and pipe detailed repair
messages through xfs_admin (as opposed to generically informative
messages like "upgrade succeeded," "upgrade failed," "filesystem
corrupt?" etc). Just my .02, of course.

Brian

> > 2/ minor, but xfs_admin(8) manpage documents `xfs_admin -O feature=status`,
> > however xfs_admin itself appends another `=1`, resulting in `xfs_repair -c
> > feature=1=1`.  This works, but looks ugly, and is not consistent with the
> > option to enable multiple features at once.  I think either the xfs_admin
> > script or its manpage should be adjusted to be consistent?
> 
> Yeah, xfs_admin should not add '=1'. Thanks for pointing that out.
> 
> > Apart from this, the actual upgrade functionality is working as expected,
> > great job!
> 
> Thx :)
> 
> > Btw, do you have an idea from which release onwards mkfs.xfs will enable
> > the new features by default?  Are there fixed rules for this (like feature
> > must be X releases old, or supported by the latest LTS kernel), or is this
> > judged on a case-by-case basis?
> 
> ~6mo after we hear that people are using the feature /and/ we haven't
> heard of any serious complaints.
> 
> Or some distro makes a business case and enables it by default. <cough>
> 
> --D
> 
> > 
> > Thanks!
> > 
> > 
> > 	Geert
> > 
> > 
> 

