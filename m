Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58C3C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Oct 2022 00:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJKAbD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 20:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJKAbA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 20:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C357436F
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 17:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D55A5B81113
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 00:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9B8C433C1;
        Tue, 11 Oct 2022 00:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665448249;
        bh=azGpTi+xgXSMUR76/ddvwJqBvdGRwfXBGHZZIHEr+Ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmkosmwhqNkz6PeQbjnNM+YnTzLnuc9HbVR+95I5ZrO2t+ULOVIFr6ztw8gUCWUsX
         GLihMuaAxK1gP8/Aym3xgb/3blOsAqYhpW8/B7+zNBa4xAgCVc3gvA3q4fHb3vdU21
         kHH9YJsPDgp5r4e5xC3I10xW7oxxx0VJg7F384yCgerNeZ0BFMwxKP/WsxmVXidJ3w
         VR0sCFy82RyyW4hfHNpm3U9yiuJk6EVMrWVrVnPwoJxf7qsNcF67fOBIFbYUDHYV/j
         6PgDwd38HGxgqg6q6SRDaC9kG9mGJmuPohv7FjEgRrBZOAH95DpOxy8WDouSwZfz6J
         +n3xX8yDW9dMQ==
Date:   Mon, 10 Oct 2022 17:30:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Darrick Wong <darrick.wong@oracle.com>,
        Srikanth C S <srikanth.c.s@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <Y0S5OIoHkP4YMgBP@magnolia>
References: <MWHPR10MB1486754F03696347F4E7FEE5A3209@MWHPR10MB1486.namprd10.prod.outlook.com>
 <CO1PR10MB44992848A2000EFE3A930871F8209@CO1PR10MB4499.namprd10.prod.outlook.com>
 <20221010232932.GW3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010232932.GW3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 10:29:32AM +1100, Dave Chinner wrote:
> On Mon, Oct 10, 2022 at 03:40:51PM +0000, Darrick Wong wrote:
> > LGTM, want to send this to the upstream list to start that discussion?

UGH, so I thought this was an internal thread, but it turns out that
linux-xfs has been cc'd for a while but none of the messages made it to
lore.

I'll fill in some missing context below.

> > --D
> > 
> > ________________________________________
> > From: Srikanth C S <srikanth.c.s@oracle.com>
> > Sent: Monday, October 10, 2022 08:24
> > To: linux-xfs@vger.kernel.org; Darrick Wong
> > Cc: Rajesh Sivaramasubramaniom; Junxiao Bi
> > Subject: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair
> > 
> > fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
> > possible that when the machine crashes, the fs is in inconsistent
> > state with the journal log not yet replayed. This can put the
> > machine into rescue shell. To address this problem, mount and
> > umount the fs before running xfs_repair.
> 
> What's the purpose of forcing xfs_repair to be run on every boot?
> The whole point of having a journalling filesystem is to avoid
> needing to run fsck on every boot.

I don't think repair-at-every-boot here is the overall goal for our
customer base.

We've had some <cough> major support events over the last few months.
There are two things going on here: some of the problems are due to are
datacenters abending, and the rest of it are the pile of data corruption
problems that you and I and Chandan have been working through for months
now.

This means that customer support has 30,000 VMs to reboot.  90% of the
systems involved seem to have survived more or less intact, but that
leaves 10% of them with latent errors, unmountable root filesystems,
etc.  They probably have even more than that, but I don't recommend
inviting the G-men for a visit to find out the real sum.

Since these machines are remotely manageable, support /can/ inject the
kernel command line with 'fsck.mode=force' to kick off xfs_repair if the
machine won't come up or if they suspect there might be deeper issues
with latent errors in the fs metadata, which is what they did to try to
get everyone running ASAP while anticipating any future problems...

> I get why one might want to occasionally force a repair check on
> boot (e.g. to repair a problem with the root filesystem), but this
> is a -rescue operation- and really shouldn't be occurring
> automatically on every boot or after a kernel crash.
>
> If it is only occurring during rescue operations, then why is it a problem
> dumping out to a shell for the admin performing rescue
> operations to deal with this directly? e.g. if the fs has a
> corrupted journal, then a mount cycle will not fix the problem and
> the admin will still get dumped into a rescue shell to fix the
> problem manually.

...however, most of those filesystems in the abended datacenter had
dirty logs, so repair failed and dumped all those machines to the
emergency shell.  3000 machines * 15 minutes per ticket is a lot of
downtime and a lot of manual labor.

Support would really like a means to automate as much of this as they
can.  They had assumed that fsck.repair=yes would DTRT to try to recover
and/or repair the fs, and were surprised to discover that this script
would not even try to recover the log.

> Hence I don't really know why anyone would be configuring their
> systems like this:

Some of the machines are VM hypervisors where unexpected crashes due to
the rootfs going offline unexpectedly create unplanned downtime for a
lot of machines.  It would be less disruptive to our cloud fleet overall
for a hypervisor take a little longer to boot if it's running fsck,
since the rootfs is the bare minimum needed to get the smartnic started.
For this case it might be preferable to configure this permanently,
since there aren't /that/ many VM hypervisors.  Nobody else gets
fsck.mode=force in the grub config.

> > Run xfs_repair -e when fsck.mode=force and repair=auto or yes.

(If it were me writing the patch, I'd have made repair=auto detect a
dirty log and continue the boot without running repair at all...)

> as it makes no sense at all for a journalling filesystem.
> 
> > If fsck.mode=force and fsck.repair=no, run xfs_repair -n without
> > replaying the logs.
> 
> Nor is it clear why anyone would want force a boot time fsck and
> then not repair the damage that might be found....

That part's my fault, I suggested that we should fix the script so that
repair=no selects dry run mode like you might expect.

> More explanation, please!

Frankly, I /don't/ want to expend a lot of time wringing our hands over
how exactly do we hammer 2022 XFS tools into 1994 ext2 behavioral
semantics.

What they really want is online fsck to detect and fix problems in real
time, but I can't seem to engage the community on how exactly do we land
this thing now that I've finished writing it.

--D

> > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > ---
> >  fsck/xfs_fsck.sh | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > index 6af0f22..21a8c19 100755
> > --- a/fsck/xfs_fsck.sh
> > +++ b/fsck/xfs_fsck.sh
> > @@ -63,8 +63,24 @@ if [ -n "$PS1" -o -t 0 ]; then
> >  fi
> > 
> >  if $FORCE; then
> > -       xfs_repair -e $DEV
> > -       repair2fsck_code $?
> > +       if $AUTO; then
> > +               xfs_repair -e $DEV
> > +                error=$?
> > +                if [ $error -eq 2 ]; then
> > +                        echo "Replaying log for $DEV"
> > +                        mkdir -p /tmp/tmp_mnt
> > +                        mount $DEV /tmp/tmp_mnt
> > +                        umount /tmp/tmp_mnt
> > +                        xfs_repair -e $DEV
> > +                        error=$?
> > +                        rmdir /tmp/tmp_mnt
> > +                fi
> > +        else
> > +                #fsck.mode=force is set but fsck.repair=no
> > +                xfs_repair -n $DEV
> > +                error=$?
> > +        fi
> > +       repair2fsck_code $error
> >          exit $?
> >  fi
> 
> As a side note, the patch has damaged whitespace....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
