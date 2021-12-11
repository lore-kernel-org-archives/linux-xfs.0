Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6982FC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 16:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhLKQ4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Dec 2021 11:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhLKQ4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Dec 2021 11:56:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DF5C061714
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 08:56:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C30B0B80AF9
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 16:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6675EC004DD;
        Sat, 11 Dec 2021 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639241775;
        bh=1hjV9USkNnGZSBa+jTbOI2TvwomYleucQfXGr0kv5Bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HwxrbGxojlL3LfV72yhdzQnA+PvLp8Akaw89UilckJRcNbsGRnfumPFiWrJHJ11b5
         S0263aX9427WcDOHC0RDEcpZjHALvpbEkNSXSEu6MxWXM/bkWBPhNTME1pnk5CRkEX
         zmaCbb3DXxzx3ETWpVaj/lnBKwBd7DvEDuYCtdch9p+XAFQsAvV1riB9QxgCllMxJO
         rAiPFdfRwMP5SfbDKqWMlYAVr/oyNIS2az+sKj3GSlZmhRYZdzQCwI21p6NjQq0ox6
         EUu07e690lwxmViUlvpwfscfhGJ3OYrOPOQ3qkAd6IUrzaPSIQMxiP6GE7LnnAhnnK
         CVJ0p0YuO5H4g==
Date:   Sat, 11 Dec 2021 08:56:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_quota: don't exit on
 fs_table_insert_project_path failure
Message-ID: <20211211165615.GG1218082@magnolia>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-4-git-send-email-sandeen@sandeen.net>
 <20211211002156.GC1218082@magnolia>
 <7f51c3db-6f3e-be89-09cf-4e704b840440@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f51c3db-6f3e-be89-09cf-4e704b840440@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 11:52:54PM -0600, Eric Sandeen wrote:
> On 12/10/21 6:21 PM, Darrick J. Wong wrote:
> > On Fri, Dec 10, 2021 at 02:21:36PM -0600, Eric Sandeen wrote:
> > > From: Eric Sandeen <sandeen@redhat.com>
> > > 
> > > If "project -p" fails in fs_table_insert_project_path, it
> > > calls exit() today which is quite unfriendly. Return an error
> > > and return to the command prompt as expected.
> > > 
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> > > ---
> > >   libfrog/paths.c | 7 +++----
> > >   libfrog/paths.h | 2 +-
> > >   quota/project.c | 4 +++-
> > >   3 files changed, 7 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/libfrog/paths.c b/libfrog/paths.c
> > > index d679376..6c0fee2 100644
> > > --- a/libfrog/paths.c
> > > +++ b/libfrog/paths.c
> > > @@ -546,7 +546,7 @@ out_error:
> > >   		progname, strerror(error));
> > >   }
> > > -void
> > > +int
> > >   fs_table_insert_project_path(
> > >   	char		*dir,
> > >   	prid_t		prid)
> > > @@ -561,9 +561,8 @@ fs_table_insert_project_path(
> > >   	else
> > >   		error = ENOENT;
> > > -	if (error) {
> > > +	if (error)
> > >   		fprintf(stderr, _("%s: cannot setup path for project dir %s: %s\n"),
> > >   				progname, dir, strerror(error));
> > 
> > Why not move this to the (sole) caller?  Libraries (even pseudolibraries
> > like libfrog) usually aren't supposed to go around fprintfing things.
> 
> I mean, that's a legit goal, but
> 
> $ grep -rw "printf\|fprintf"  libfrog/ | wc -l
> 55
> 
> but ok, I can reduce it to 54 ;)
> 

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -Eric
