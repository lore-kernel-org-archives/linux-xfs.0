Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A433C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 02:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 326BD611BD
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 02:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFHCEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhFHCEq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 22:04:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23CC661168;
        Tue,  8 Jun 2021 02:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623117774;
        bh=cMPtDsRpn8s7XeMaQ3Bd7GFSWbxajPsPXO6oHccbq6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EStjUVsuhlqlK0rTVHLzOY6jJvIUUREhKFS4jgWb8pIRhptQE3kZzT4RgBHzSNDUF
         6h7rkw91bgGP8MEckh05tEpdEZHgGb3cyBFjkdIttKY9SZ9zJSNIYrTqE65nIi3VaS
         0+UvWCyeQhCqJNspHR9cgM4xX3aLKDraBdHnvLF5WlywB/K0h231lZN0tLLtL3d2qT
         hG+KYMT3Ft7NxB2cDAYRmYw2EDZze9QL9rL5ZK9w73szi5hQ6PsqxTV+FE5KTBhcQ6
         2t3lppXGVBfkv9MIF5SDnnHXqH6NlPim1PsI31rdtJTTa9zL4NOdLTW82YmErDu5DK
         dkwtZGhgymKQA==
Date:   Mon, 7 Jun 2021 19:02:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/9] xfs: expose sysfs knob to control inode inactivation
 delay
Message-ID: <20210608020253.GP2945738@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310471037.3465262.10128421878961173112.stgit@locust>
 <20210608010936.GH664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608010936.GH664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 11:09:36AM +1000, Dave Chinner wrote:
> On Mon, Jun 07, 2021 at 03:25:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Allow administrators to control the length that we defer inode
> > inactivation.  By default we'll set the delay to 2 seconds, as an
> > arbitrary choice between allowing for some batching of a deltree
> > operation, and not letting too many inodes pile up in memory.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  Documentation/admin-guide/xfs.rst |    7 +++++++
> >  fs/xfs/xfs_globals.c              |    3 +++
> >  fs/xfs/xfs_icache.c               |    3 ++-
> >  fs/xfs/xfs_linux.h                |    1 +
> >  fs/xfs/xfs_sysctl.c               |    9 +++++++++
> >  fs/xfs/xfs_sysctl.h               |    1 +
> >  6 files changed, 23 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> > index f9b109bfc6a6..9dd62b155fda 100644
> > --- a/Documentation/admin-guide/xfs.rst
> > +++ b/Documentation/admin-guide/xfs.rst
> > @@ -277,6 +277,13 @@ The following sysctls are available for the XFS filesystem:
> >  	references and returns timed-out AGs back to the free stream
> >  	pool.
> >  
> > +  fs.xfs.inode_gc_delay
> > +	(Units: centiseconds   Min: 0  Default: 1  Max: 360000)
> > +	The amount of time to delay cleanup work that happens after a file is
> > +	closed by all programs.  This involves clearing speculative
> > +	preallocations from linked files and freeing unlinked files.  A higher
> > +	value here increases batching at a risk of background work storms.
> 
> Can we make new timers use a sane unit of time like milliseconds?

Ok.  Changing the name to inode_gc_delay_ms to make the units obvious to
userspace.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
