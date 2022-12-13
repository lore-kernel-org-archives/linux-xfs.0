Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D191C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiLMTUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiLMTUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDA11AA0A
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 11:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98FB0616D4
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 19:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DB0C433D2;
        Tue, 13 Dec 2022 19:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670959220;
        bh=xbEIpQfDrw7N42/B/NjYqtJbXQ68fAtqN2rsUkMOwQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DHmVM+wTSPZTyT/o3mOvYwnKIVLqbtO9Fkru98J0ye8Lnyj4QH0oN0ZSCnPFLvcqi
         JT8H3mfm8Lcv5+dQqUykQY1tOtckFCRocXOdNWlKjl8JvOGVKQF/ghKeSwwcclbA3u
         X/Oi73/NRRFqMQJVvxuUVbJOHnW3dNue3mIr/nMBNGT3+BXQacZz5q4ei2Ib0twi9H
         qXxkLuSk5x6XIUUjI2NRTbNRYR3J5H64nRWlThE7kc1/2kKHmK5507zCp3dOG4fQ2e
         K0dCMYTS5DcgIvgv3uKgOzT/dEtVvUN5VEVvBuwgLpGJWIqswEh6LSOpUesyN05sAo
         s+bzoWq0zn63A==
Date:   Tue, 13 Dec 2022 11:20:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 2/2] xfs_admin: get UUID of mounted filesystem
Message-ID: <Y5jQcwO1pnPe326t@magnolia>
References: <20221207022346.56671-1-catherine.hoang@oracle.com>
 <20221207022346.56671-3-catherine.hoang@oracle.com>
 <GLN3Tpevb3-ESsUfAe6gL59xcVVTrn_p1ug0bMgoVhgKWigPIbEyl0D0n0qgLEH5Hdkex1t4Z5N0eF8tGfhILQ==@protonmail.internalid>
 <Y5Ej3Q9DWtpQ4+Cq@magnolia>
 <20221212133348.6ymz3cpt4i75k6ah@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212133348.6ymz3cpt4i75k6ah@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 12, 2022 at 02:33:48PM +0100, Carlos Maiolino wrote:
> On Wed, Dec 07, 2022 at 03:38:05PM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 06, 2022 at 06:23:46PM -0800, Catherine Hoang wrote:
> > > Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesystem.
> > > This is a precursor to enabling xfs_admin to set the UUID of a mounted
> > > filesystem.
> > >
> > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > ---
> > >  db/xfs_admin.sh | 21 ++++++++++++++++++---
> > >  1 file changed, 18 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > > index 409975b2..0dcb9940 100755
> > > --- a/db/xfs_admin.sh
> > > +++ b/db/xfs_admin.sh
> > > @@ -6,6 +6,8 @@
> > >
> > >  status=0
> > >  DB_OPTS=""
> > > +DB_EXTRA_OPTS=""
> > > +IO_OPTS=""
> > 
> 
> I'll try to come back later to this thread with better answers, but I didn't
> want to leave it with no answer at all, so, from a first glance:
> 
> 
> > This seemed oddly familiar until I remembered that we've been here
> > before:
> > https://lore.kernel.org/linux-xfs/ac736821-83de-4bde-a1a1-d0d2711932d7@sandeen.net/
> > 
> > And now that I've reread that thread, I've now realized /why/ I gave up
> > on adding things to this script -- there were too many questions from
> > the maintainer for which I couldn't come up with any satisfying answer.
> > Then I burned out and gave up.
> > 
> > Ofc now we have a new maintainer, so I'll put the questions to the new
> > one.  To summarize:
> > 
> > What happens if there are multiple sources of truth because the fs is
> > mounted?  Do we stop after processing the online options and ignore the
> > offline ones?  Do we keep going, even though -f is almost certainly
> > required?
> 
> /me has no idea, but to be honest, I'd say, those shouldn't be mixed, either
> target online, or offline. Both, seems a recipe for disaster IMHO.

Agreed. :)

> > 
> > If the user specifies multiple options, is it ok to change the order in
> > which we run them so that we can run xfs_io and then xfs_db?
> 
> Good question. I don't think I have a decent answer for that by now.
> I'm inclined to say it really depends on the semantics of the output, if
> ordering it doesn't change the expected output I don't see why reordering would
> be a problem.

Welll... in theory, if some user has hooked up xfs_admin to a program
that expects output lines in an exact order, reordering the commands
would be a breaking change.

Also, if ordering matters to the underlying xfs_db/xfs_io process, then
reordering causes problems if, say, the parameters actually change
things on the filesystem, and the order of those changes matters.

(I don't think any of the fs change options actually do matter, at least
not the ones that apply to v5 filesystems.)

> On the other hand, I think there is a myriad of possible combinations that would
> require evaluation to check when we are able to reorder or not.

Yep.

> It it worth the effort?

I don't think it is.

> > 
> > If it's not ok to change the order, how do we make the two tools run in
> > lockstep so we only have to open the filesystem once?
> > 
> > If it's not ok to change the order and we cannot do lockstep, is it ok
> > to invoke io/db once for each subcommand instead of assembling a giant
> > cli option array like we now for db?
> 
> I might be being naive here, but it doesn't sound bad. Performance is no big
> deal here I believe, so, some extra time invoking io/db once for each
> subcommand, instead of creating a spaghetti of possible options that may/may not
> work together, sounds as a good trade off.

Yeah.  I'm sure we could come up with some pathological sequence where
multiple invocations would actually break very badly -- if, say, we were
to allow xfs_db to "add" reflink and/or rmap to a filesystem, we'd want
to set the NEEDSREPAIR bit to force the user to run xfs_repair to
generate the missing btrees.

But what if you did something like:

xfs_admin -O rmap <some other option> -O reflink

which would translate to:

xfs_db -c 'add rmap' $dev
<dev is now marked NEEDSREPAIR>
<other option>
xfs_db -c 'add reflink' $dev
<fails because NEEDSREPAIR set at xfs_db init time>

whereas this:

xfs_admin -O rmap -O reflink

would translate to:

xfs_db -c 'add rmap' -c 'add reflink' $dev
<single command, succeeds>

Or maybe we just don't care if any of that is broken because this is all
theoretical. :P

> > If we have to invoke io/db multiple times, what do we do if the state
> > changes between invocations (e.g. someone else mounts the block dev or
> > unmounts the fs)?  What happens if this all results in multiple
> > xfs_repair invocations?
> 
> One idea would be to check the FS state before each io/db call, if the state
> changes, drop a warning to the user and stop operation. Couldn't the xfs_repair
> be postponed to the end if needed?
> 
> > 
> > Can we prohibit people from running multiple subcommands?  Even if
> > that's a breaking change for someone who might be relying on the exact
> > behaviors of this shell script?
> > 
> > What if, instead of trying to find answers to all these annoying
> > questions, we instead decide that either all the subcommands have to
> > target a mountpoint or they all have to target a blockdev, or xfs_admin
> > will exit with an error code?
> 
> TBH this is my favorite idea so far.

Ok, let's run with this then. :D

--D

> > 
> > --D
> > 
> > >  REPAIR_OPTS=""
> > >  REPAIR_DEV_OPTS=""
> > >  LOG_OPTS=""
> > > @@ -23,7 +25,8 @@ do
> > >  	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
> > >  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> > >  	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
> > > -	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> > > +	u)	DB_EXTRA_OPTS=$DB_EXTRA_OPTS" -r -c uuid";
> > > +		IO_OPTS=$IO_OPTS" -r -c fsuuid";;
> > >  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
> > >  	V)	xfs_db -p xfs_admin -V
> > >  		status=$?
> > > @@ -38,14 +41,26 @@ set -- extra $@
> > >  shift $OPTIND
> > >  case $# in
> > >  	1|2)
> > > +		# Use xfs_io if mounted and xfs_db if not mounted
> > > +		if [ -n "$(findmnt -t xfs -T $1)" ]; then
> > > +			DB_EXTRA_OPTS=""
> > > +		else
> > > +			IO_OPTS=""
> > > +		fi
> > > +
> > >  		# Pick up the log device, if present
> > >  		if [ -n "$2" ]; then
> > >  			LOG_OPTS=" -l '$2'"
> > >  		fi
> > >
> > > -		if [ -n "$DB_OPTS" ]
> > > +		if [ -n "$DB_OPTS" ] || [ -n "$DB_EXTRA_OPTS" ]
> > > +		then
> > > +			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS $DB_EXTRA_OPTS "$1"
> > > +			status=$?
> > > +		fi
> > > +		if [ -n "$IO_OPTS" ]
> > >  		then
> > > -			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
> > > +			eval xfs_io -x -p xfs_admin $IO_OPTS "$1"
> > >  			status=$?
> > >  		fi
> > >  		if [ -n "$REPAIR_OPTS" ]
> > > --
> > > 2.25.1
> > >
> 
> -- 
> Carlos Maiolino
