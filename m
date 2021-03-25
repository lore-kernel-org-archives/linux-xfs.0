Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D43EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A89161A1A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhCYEdT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYEdA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 00:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49CAA60238;
        Thu, 25 Mar 2021 04:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616646780;
        bh=di7oIpGQwzNDOAmPbBDHTwedcQXWqSfPyXPKAKVzbJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJZAyI4vLsnGcnPPynam9I0ljjohXC6PNEMkmq/GFEtzJocDp6s5JvHDmi+uuYyRE
         SlSNJeZPLuo59x+k4XD1e5gXc56frmFax9Xd12Pdnsw85Ig4Jby/ocURZnMspxWmIm
         /aGyzfWOQH/D6zCavlPYxG5CsQzOyXoG6UJ3KmYbhf21asSZEoGZU/SHDpioc+Makx
         5c1FAXFofuqBXuj/01bvvGHMu2N00eZQFhgZA3CBXRtcp+na1kcZC5HKrl7oUmQGeV
         lAtomm5NLm1zI+ugUywIqUOaRK++5czJEyRZwfS/m6r4dEaNOBBbD3lxt+GN09V85A
         JSMWYb4lt4Cew==
Date:   Wed, 24 Mar 2021 21:32:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_admin: pick up log arguments correctly
Message-ID: <20210325043259.GE4090233@magnolia>
References: <20210324021018.GQ22100@magnolia>
 <773c904b-4468-e16e-dc17-5942988c997c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <773c904b-4468-e16e-dc17-5942988c997c@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:47:54PM -0500, Eric Sandeen wrote:
> On 3/23/21 9:10 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In commit ab9d8d69, we added support to xfs_admin to pass an external
> > log to xfs_db and xfs_repair.  Unfortunately, we didn't do this
> > correctly -- by appending the log arguments to DB_OPTS, we now guarantee
> > an invocation of xfs_db when we don't have any work for it to do.
> > 
> > Brian Foster noticed that this results in xfs/764 hanging fstests
> > because xfs_db (when not compiled with libeditline) will wait for input
> > on stdin.  I didn't notice because my build includes libeditline and my
> > test runner script does silly things with pipes such that xfs_db would
> > exit immediately.
> > 
> > Reported-by: Brian Foster <bfoster@redhat.com>
> > Fixes: ab9d8d69 ("xfs_admin: support adding features to V5 filesystems")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> This seems fine.  While astute bashophiles will have no problem with this,
> at some point it might be nice to add some comments above DB_OPTS and
> REPAIR_OPTS that point out hey, if you set these, you WILL be invoking the
> tool.

That "should" be obvious from reading the source code, but this
maintainer obviously didn't notice that, and bash is horrible so I don't
blame anyone else for missing things.

> I also chafe a little at accumulating some device options in REPAIR_DEV_OPTS
> and others in LOG_OPTS; why not REPAIR_DEV_OPTS and DB_DEV_OPTS for some
> consistency?

Why not dump each arg into a bash array so that we don't have to deal
with all this shell space-escaping crap? :P

> But, this does seem to solve the problem, and in the
> Spirit of Lets Not Navel-Gaze And Just Keep Fixing Things(tm),

Ok, thanks.  Enjoy your vacation! :)

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  db/xfs_admin.sh |    9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > index 916050cb..409975b2 100755
> > --- a/db/xfs_admin.sh
> > +++ b/db/xfs_admin.sh
> > @@ -8,7 +8,7 @@ status=0
> >  DB_OPTS=""
> >  REPAIR_OPTS=""
> >  REPAIR_DEV_OPTS=""
> > -DB_LOG_OPTS=""
> > +LOG_OPTS=""
> >  USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
> >  
> >  while getopts "c:efjlL:O:pr:uU:V" c
> > @@ -40,19 +40,18 @@ case $# in
> >  	1|2)
> >  		# Pick up the log device, if present
> >  		if [ -n "$2" ]; then
> > -			DB_OPTS=$DB_OPTS" -l '$2'"
> > -			REPAIR_DEV_OPTS=$REPAIR_DEV_OPTS" -l '$2'"
> > +			LOG_OPTS=" -l '$2'"
> >  		fi
> >  
> >  		if [ -n "$DB_OPTS" ]
> >  		then
> > -			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
> > +			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
> >  			status=$?
> >  		fi
> >  		if [ -n "$REPAIR_OPTS" ]
> >  		then
> >  			echo "Running xfs_repair to upgrade filesystem."
> > -			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
> > +			eval xfs_repair $LOG_OPTS $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
> >  			status=`expr $? + $status`
> >  		fi
> >  		;;
> > 
