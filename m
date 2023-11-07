Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1ABC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 18:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjKGSfP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 13:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjKGSfO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 13:35:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E96125
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 10:35:12 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182C8C433C7;
        Tue,  7 Nov 2023 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699382112;
        bh=lAPlU4AXPc8mZmW3KLy3viwDgYoR2l6QsW9jEty32yY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W/WPRHOJnQcTy7MitLY9iUOq96cojbu0clivuat9rQNJ1j0qhGSs+oCMIzerDVVkM
         eT1VzAAom1D4UC6HgZw7ZvHJdmqEBtAOOzmWwOYxzaKFu/T5d7qxtbgIYJtW6OXDtr
         tQfbPBp7ZDVZwpEh608bg1ug3iM7PTdhJkUm8AAF+t8kWbLd+028+1KeRuqk25Kph4
         zfxQJH94fAL3wlw5/aLEqAcVsPa4d6izaDUGuJJ8Za3E40f+gFKTVi+rzP47dCs5Yo
         /H5SWaBPLXtxHq5Ot2Vm9Q/t2hXXuIoJARwbPIRt5qvMVJcL37N0Giy6kjaELZRbZI
         pOBywz1jffn2A==
Date:   Tue, 7 Nov 2023 10:35:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <20231107183511.GN1205143@frogsfrogsfrogs>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
 <ZUn55/68v2VfQHCX@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUn55/68v2VfQHCX@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 12:48:39AM -0800, Christoph Hellwig wrote:
> On Thu, May 25, 2023 at 06:55:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In the next patch, we'll tighten up the security on the xfs_scrub
> > service so that it can't escape.  However, sanboxing the service
> > involves making the host filesystem as inaccessible as possible, with
> > the filesystem to scrub bind mounted onto a known location within the
> > sandbox.  Hence we need one path for reporting and a new -A argument to
> > tell scrub what it should actually be trying to open.
> 
> This confuses me a bit.  Let me try to see if I understood it correctly:
> 
>  - currently xfs_scrub is called on the mount point, where the
>    mount-point is the first non-optional argument
> 
> With this patch there is a new environment variable that tells it what
> mount point to use, and only uses the one passed as the argument for
> reporting messages.
> 
> If I understand this correctly I find the decision odd.  I can see
> why you want to separate the two.  But I'd still expect the mount point
> to operate on to be passed as the argument, with an override for the
> reported messages.  And I'd expect the override passed as a normal
> command line option and not an environment variable. 

The reason why I bolted on the SERVICE_MOUNTPOINT= environment variable
is to preserve procfs discoverability.  The bash translation of these
systemd unit definitions for a scrub of /home is:

  mount /home /tmp/scrub --bind
  SERVICE_MODE=1 SERVICE_MOUNTPOINT=/tmp/scrub xfs_scrub -b /home

And the top listing for that will look like:

    PID USER      PR  NI %CPU  %MEM     TIME+ COMMAND
  11804 xfs_scru+ 20  19 10.3   0.1   1:26.94 xfs_scrub -b /home

(I omitted a few columns to narrow the top output.)

Notice how the path that the program is allegedly scrubbing (despite all
the private bind mount security mania) shows up in the ps listing, so
it's easier to figure out what each process is doing.  The actual
horrible details of the sandboxing are hidden in /proc/11804/environ

So that's the reasoning behind the somewhat backwards phrasing.  As they
say, "Permits many, money more!"

For everyone else following at home -- the reason for bind mounting the
actual mountpoint into a private mount tree at /tmp/scrub is (a) to
make it so that the scrub process can only see a ro version of a subset
of the filesystem tree; and (b) separate the mountpoint in the scrub
process so that the sysadmin typing "umount /home" will see it disappear
out of most process' mount trees without that affecting scrub.

(I don't think xfs_scrub is going to go rogue and start reading users'
credit card numbers out of /home, but why give it an easy opportunity?)

--D
