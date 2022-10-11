Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AE3C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Oct 2022 16:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJKQIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 12:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJKQIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 12:08:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4444152DF6
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 09:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A445BCE1888
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 16:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD63C433C1;
        Tue, 11 Oct 2022 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665504480;
        bh=/QQHqUzWHIlKYJLQ3wV1C0FXkotVeTNnJVM0kG91dnI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUPSexOoh55iDm05dsI/YgqJ8RQkzgvk4hssZWzJ5cGdjeWfn88k0nVZZAsORWwh6
         zVxLhUZiBerzNMuT6Sflik2rnk2iHDic+M0pYHyO17zrlS+6NYUdxiIpjI8BQEIwNM
         2Rtk9x//rCVQnjeX9uLvm+evQrWiLxxbkAzkvvuaJPnXhU9L2VS3QAKy1oFLrlOeAH
         TlgA/cqgQcDzcwTCbCOuVljQV98TwZR/eXspKY1JWOHGI/IIMEVusv3OLnvy+K9+6v
         aM2b8yUenkO9NFx3iJSlmvPY9oCf07yEcH9NtbVzNw40Nv4nHFp5jmn+YWJiqdOozl
         /yq63SP3MswRA==
Date:   Tue, 11 Oct 2022 09:08:00 -0700
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
Message-ID: <Y0WU4FANNYTKNXzL@magnolia>
References: <MWHPR10MB1486754F03696347F4E7FEE5A3209@MWHPR10MB1486.namprd10.prod.outlook.com>
 <CO1PR10MB44992848A2000EFE3A930871F8209@CO1PR10MB4499.namprd10.prod.outlook.com>
 <20221010232932.GW3600936@dread.disaster.area>
 <Y0S5OIoHkP4YMgBP@magnolia>
 <20221011042602.GX3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011042602.GX3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 03:26:02PM +1100, Dave Chinner wrote:
> On Mon, Oct 10, 2022 at 05:30:48PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 11, 2022 at 10:29:32AM +1100, Dave Chinner wrote:
> > > On Mon, Oct 10, 2022 at 03:40:51PM +0000, Darrick Wong wrote:
> > > > LGTM, want to send this to the upstream list to start that discussion?
> > 
> > UGH, so I thought this was an internal thread, but it turns out that
> > linux-xfs has been cc'd for a while but none of the messages made it to
> > lore.
> > 
> > I'll fill in some missing context below.
> > 
> > > > --D
> > > > 
> > > > ________________________________________
> > > > From: Srikanth C S <srikanth.c.s@oracle.com>
> > > > Sent: Monday, October 10, 2022 08:24
> > > > To: linux-xfs@vger.kernel.org; Darrick Wong
> > > > Cc: Rajesh Sivaramasubramaniom; Junxiao Bi
> > > > Subject: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair
> > > > 
> > > > fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
> > > > possible that when the machine crashes, the fs is in inconsistent
> > > > state with the journal log not yet replayed. This can put the
> > > > machine into rescue shell. To address this problem, mount and
> > > > umount the fs before running xfs_repair.
> > > 
> > > What's the purpose of forcing xfs_repair to be run on every boot?
> > > The whole point of having a journalling filesystem is to avoid
> > > needing to run fsck on every boot.
> > 
> > I don't think repair-at-every-boot here is the overall goal for our
> > customer base.
> > 
> > We've had some <cough> major support events over the last few months.
> > There are two things going on here: some of the problems are due to are
> > datacenters abending, and the rest of it are the pile of data corruption
> 
> /me has to look up what "abending" means in this context, because I
> don't think you mean that the data denter was "Absent By Enforced
> Net Deprivation"...
> 
> Ah, it's an ancient abbreviation from the early days of IBM
> mainframes meaning "abnormal end of task". i.e. something crashed.

Yes.

> > problems that you and I and Chandan have been working through for months
> > now.
> > 
> > This means that customer support has 30,000 VMs to reboot.  90% of the
> > systems involved seem to have survived more or less intact, but that
> > leaves 10% of them with latent errors, unmountable root filesystems,
> > etc.  They probably have even more than that, but I don't recommend
> > inviting the G-men for a visit to find out the real sum.
> > 
> > Since these machines are remotely manageable, support /can/ inject the
> > kernel command line with 'fsck.mode=force' to kick off xfs_repair if the
> > machine won't come up or if they suspect there might be deeper issues
> > with latent errors in the fs metadata, which is what they did to try to
> > get everyone running ASAP while anticipating any future problems...
> 
> This context is kinda important :)
> 
> [....]
> 
> > > More explanation, please!
> > 
> > Frankly, I /don't/ want to expend a lot of time wringing our hands over
> > how exactly do we hammer 2022 XFS tools into 1994 ext2 behavioral
> > semantics.
> 
> Neither do I - I just want to understand the problem that the
> change is trying to solve. The commit message gave no indication of
> why the change was being proposed; commit messages need to tell the
> whole story, not describe the code change being made.  If it started
> like:
> 
> "After a recent data center crash, we recently had to recover root
> filesystems on several thousand VMs via a boot time fsck. Many of
> them failed unnecessarily because.... "
> 
> then it becomes self evident that replaying the log in these
> situations is necessary.

<nod> Srikanth, would you reword the patch message to include some of
the details about why we want this patch?

> > What they really want is online fsck to detect and fix problems in real
> > time, but I can't seem to engage the community on how exactly do we land
> > this thing now that I've finished writing it.
> 
> I only want to look at the interfacing with the runtime structures
> and locking to ensure we don't back ourselves into a nasty corner.
> This is really only a small part of the bigger online repair
> patchset.  Once we've got that sorted, I think we should just commit
> the rest of it as it stands (i.e. tested but unreviewed) and fix as
> needed, just like we do with the userspace xfs_repair code...

Ok.

> > --D
> > 
> > > > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > > > ---
> > > >  fsck/xfs_fsck.sh | 20 ++++++++++++++++++--
> > > >  1 file changed, 18 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > > > index 6af0f22..21a8c19 100755
> > > > --- a/fsck/xfs_fsck.sh
> > > > +++ b/fsck/xfs_fsck.sh
> > > > @@ -63,8 +63,24 @@ if [ -n "$PS1" -o -t 0 ]; then
> > > >  fi
> > > > 
> > > >  if $FORCE; then
> > > > -       xfs_repair -e $DEV
> > > > -       repair2fsck_code $?
> > > > +       if $AUTO; then
> > > > +               xfs_repair -e $DEV
> > > > +                error=$?
> > > > +                if [ $error -eq 2 ]; then

To reiterate something earlier in the thread: I would only do the
mount/umount if the caller passes -fy.  I would drop to the emergency
shell for -fa or -f.

(Also: whitespace damage)

> > > > +                        echo "Replaying log for $DEV"
> > > > +                        mkdir -p /tmp/tmp_mnt
> > > > +                        mount $DEV /tmp/tmp_mnt
> 
> Need to handle mount failure here - this will need to drop to
> a rescue shell for manual recovery, I think.

Yep.

> Also, what happens if there are mount options set like quota?
> Doesn't this make more work for the recovery process if we elide
> things like that here?

Agreed, I think we need to extract rootflags= from /proc/cmdline.

> > > > +                        umount /tmp/tmp_mnt
> > > > +                        xfs_repair -e $DEV
> > > > +                        error=$?
> > > > +                        rmdir /tmp/tmp_mnt
> > > > +                fi
> > > > +        else
> > > > +                #fsck.mode=force is set but fsck.repair=no
> > > > +                xfs_repair -n $DEV
> > > > +                error=$?
> > > > +        fi
> 
> I think that adding a "check only" mode should be a separate patch.
> We have to consider different things here, such as it will run on an
> unrecovered filesystem and potentially report it damaged when, in
> fact, all that is needed is log recovery to run....

<nod> I'm not sure what we should return in that case.  Maybe 8 for
operational error?

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
