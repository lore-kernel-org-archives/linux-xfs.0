Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF2BC48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 21:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98AB46128C
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 21:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhFPVHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233836AbhFPVHH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 17:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1525860698;
        Wed, 16 Jun 2021 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623877501;
        bh=fgNuToXc56GiKjJ2ZU6IgKGKQkdi4Amc4WpgPT7OcRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LvaD2IyqMjYgOLZ9aK8fTYPJk9HGKry0Gzay5yMGXcZnL4YEmu/+mu4GqGKsm8ibq
         TFpx9I5bSI8cJ2l40WawOBHPJZpZ4tzDAKyMSX2WHppDmhw70E+z4FZ5Pb8zo78lv8
         CvxkjxcxJndhZGmntUsiFlHB+kzPtX7XhgGoROIzr7Q73J5+QRzbnu/551mKUVRG+s
         OGLGbjrABsB+axHJfiq1HUBZDJ/gRtxrgF2TwkQNrpdGzABkcMYXBcN80ago1KooOq
         1TMEAD4cRGHIUAbFwNeeZH+meaRL6wTD/jXKLx+pF15zZ1euiOmQw0HcQZkTKFhoEY
         EV0KHJ2Uf66MA==
Date:   Wed, 16 Jun 2021 14:05:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [BUG] generic/475 recovery failure(s)
Message-ID: <20210616210500.GF158209@locust>
References: <YMIsWJ0Cb2ot/UjG@bfoster>
 <YMOzT1goreWVgo8S@bfoster>
 <20210611223332.GS664593@dread.disaster.area>
 <20210616070542.GY664593@dread.disaster.area>
 <YMpgFmEzjpWnmZ66@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMpgFmEzjpWnmZ66@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 04:33:26PM -0400, Brian Foster wrote:
> On Wed, Jun 16, 2021 at 05:05:42PM +1000, Dave Chinner wrote:
> > On Sat, Jun 12, 2021 at 08:33:32AM +1000, Dave Chinner wrote:
> > > On Fri, Jun 11, 2021 at 03:02:39PM -0400, Brian Foster wrote:
> > > > On Thu, Jun 10, 2021 at 11:14:32AM -0400, Brian Foster wrote:
> > > > > Hi all,
> > > > > 
> > > > > I'm seeing what looks like at least one new generic/475 failure on
> > > > > current for-next. (I've seen one related to an attr buffer that seems to
> > > > > be older and harder to reproduce.). The test devices are a couple ~15GB
> > > > > lvm devices formatted with mkfs defaults. I'm still trying to establish
> > > > > reproducibility, but so far a failure seems fairly reliable within ~30
> > > > > iterations.
> > > > > 
> > > > > The first [1] looks like log recovery failure processing an EFI. The
> > > > > second variant [2] looks like it passes log recovery, but then fails the
> > > > > mount in the COW extent cleanup stage due to a refcountbt problem. I've
> > > > > also seen one that looks like the same free space corruption error as
> > > > > [1], but triggered via the COW recovery codepath in [2], so these could
> > > > > very well be related. A snippet of the dmesg output for each failed
> > > > > mount is appended below.
> > > > > 
> > > > ...
> > > > 
> > > > A couple updates..
> > > > 
> > > > First (as noted on irc), the generic/475 failure is not new as I was
> > > > able to produce it on vanilla 5.13.0-rc4. I'm not quite sure how far
> > > > back that one goes, but Dave noted he's seen it on occasion for some
> > > > time.
> > > > 
> > > > The generic/019 failure I'm seeing does appear to be new as I cannot
> > > > reproduce on 5.13.0-rc4. This failure looks more like silent fs
> > > > corruption. I.e., the test or log recovery doesn't explicitly fail, but
> > > > the post-test xfs_repair check detects corruption. Example xfs_repair
> > > > output is appended below (note that 'xfs_repair -n' actually crashes,
> > > > while destructive repair seems to work). Since this reproduces fairly
> > > > reliably on for-next, I bisected it (while also navigating an unmount
> > > > hang that I don't otherwise have data on) down to facd77e4e38b ("xfs:
> > > > CIL work is serialised, not pipelined"). From a quick glance at that I'm
> > > > not quite sure what the problem is there, just that it doesn't occur
> > > > prior to that particular commit.
> > > 
> > > I suspect that there's an underlying bug in the overlapping CIL
> > > commit record sequencing. This commit will be the first time we are
> > > actually getting overlapping checkpoints that need ordering via the
> > > commit record writes. Hence I suspect what is being seen here is a
> > > subtle ordering bug that has been in that code since it was first
> > > introduced but never exercised until now..
> > > 
> > > I haven't had any success in reproducing this yet, I'll keep trying
> > > to see if I can get it to trigger so I can look at it in more
> > > detail...
> > 
> > I think I have reproduced this enough to have some idea about what
> > is happening here. I has RUI recovery fail converting an unwritten
> > extent which was added in a RUI+RUD+rmapbt buffer modification a few
> > operations prior to the RUI that failed. Turns out that the on-disk
> > buffer had an LSN stamped in it more recent than the LSN of the
> > checkpoint being recovered and it all goes downhill from there.
> > 
> > The problematic checkpoints at the end of the log overlap
> > like this:
> > 
> > Oper (0): tid: 53552074  len: 0  clientid: TRANS  flags: START 
> > cycle: 52       version: 2              lsn: 52,13938   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,14002   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,14066   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,14130   tail_lsn: 52,10816
> > Oper (27): tid: c960e383  len: 0  clientid: TRANS  flags: START 
> > cycle: 52       version: 2              lsn: 52,14194   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,14258   tail_lsn: 52,10816
> > .....
> > cycle: 52       version: 2              lsn: 52,15410   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,15474   tail_lsn: 52,10816
> > Oper (29): tid: c960e383  len: 0  clientid: TRANS  flags: COMMIT 
> > Oper (30): tid: 53552074  len: 0  clientid: TRANS  flags: COMMIT 
> > cycle: 52       version: 2              lsn: 52,15513   tail_lsn: 52,10816
> > Oper (0): tid: 22790ee5  len: 0  clientid: TRANS  flags: START 
> > cycle: 52       version: 2              lsn: 52,15577   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,15641   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,15705   tail_lsn: 52,10816
> > cycle: 52       version: 2              lsn: 52,15769   tail_lsn: 52,10816
> > 
> > You can see the commit records for transaction IDs (tid: xxx)
> > 53552074 and c960e383 are ordered differently to the start records.
> > The checkpoint "tid: 22790ee5" is the last checkpoint in the log
> > which is incomplete and so isn't recovered.
> > 
> > Now, from this information I don't know whether the commit records
> > are correctly ordered as the CIL code is suppposed to do, but what
> > has happened is that log recovery tags checkpoints with the start
> > lsn of the checkpoint and uses that for recovery. That's the lsn it
> > stamps into metadata recovered by that commit.
> > 
> > So, we recover "tid: c960e383" first with a lsn of 0x340003732,
> > then recover "tid: 53552074" with a lsn of 0x3400003632. Hence even
> > if the commit records are correctly ordered, log recovery screws up
> > the LSN used to recover the checkpoints and hence incorrectly
> > recovers buffers and stamps incorrect LSNs into buffers.
> > 
> 
> Oof. :/
> 
> > So, once this is all recovered, we go to handle outstanding intents.
> > We start with a RUI that is an rmap conversion, and it fails to find
> > the rmap record that it is converting and assert fails. It didn't
> > find the record because the rmapbt block modification was not
> > replayed because the on-disk rmapbt block was updated in "tid:
> > c960e383" and so has a lsn of 0x340003732 stamped in it. And so the
> > modification that added the record in "tid: 53552074" was skipped
> > because it ran with an LSN less than what was already on disk.
> > 
> > IOWs, we got a RUI conversion failure because the above two nested
> > checkpoints were either replayed out of order or were replayed with
> > the incorrect LSNs.
> > 
> > From here, I'm working as I write this because, well, complex... :/
> > 
> > Hypothesis: If the two nested checkpoints had their commit records
> > written out of order, then what wasn't complete in 53552074 should
> > be in c960e383 but was ignored. There were only two RUIs left
> > incomplete in 53552074 (i.e. had no RUD+rmapbt buffer mods) and they
> > weren't in c960e383. Hence c960e383 does not follow 53552074.
> > Indeed, I found both RUDs at the start of checkpoint 22790ee5 (which
> > wasn't complete or replayed), hence log recovery was correct to be
> > replaying those RUIs.
> > 
> > So, lets use this same intent -> intent done split across
> > checkpoints to verify that 53552074 follows c960e383. So:
> > 
> > ----------------------------------------------------------------------------
> > Oper (26): tid: d3047f93  len: 48  clientid: TRANS  flags: none
> > RUI:  #regs: 1  num_extents: 1  id: 0xffff888034f3edb0
> > (s: 0x25198c, l: 1, own: 518, off: 2714540, f: 0x20000001) 
> > ....
> > ----------------------------------------------------------------------------
> > Oper (2): tid: 53552074  len: 16  clientid: TRANS  flags: none
> > RUD:  #regs: 1                   id: 0xffff8880422f1d90
> > .....
> > ----------------------------------------------------------------------------
> > Oper (24): tid: 53552074  len: 48  clientid: TRANS  flags: none
> > RUI:  #regs: 1  num_extents: 1  id: 0xffff8880422f35c0
> > (s: 0x107de7, l: 1, own: 521, off: 2854494, f: 0x5) 
> > ....
> > ----------------------------------------------------------------------------
> > Oper (39): tid: c960e383  len: 16  clientid: TRANS  flags: none
> > RUD:  #regs: 1                   id: 0xffff888034f3edb0
> > ....
> > ----------------------------------------------------------------------------
> > Oper (28): tid: c960e383  len: 48  clientid: TRANS  flags: none
> > RUI:  #regs: 1  num_extents: 1  id: 0xffff8880422f1d90
> > (s: 0x31285f, l: 1, own: 520, off: 3195131, f: 0x5) 
> > ----------------------------------------------------------------------------
> > Oper (29): tid: c960e383  len: 0  clientid: TRANS  flags: COMMIT 
> > ----------------------------------------------------------------------------
> > Oper (30): tid: 53552074  len: 0  clientid: TRANS  flags: COMMIT 
> > ....
> > ----------------------------------------------------------------------------
> > Oper (0): tid: 22790ee5  len: 0  clientid: TRANS  flags: START 
> > ----------------------------------------------------------------------------
> > Oper (1): tid: 22790ee5  len: 16  clientid: TRANS  flags: none
> > TRAN:     tid: e50e7922  num_items: 876
> > ----------------------------------------------------------------------------
> > Oper (2): tid: 22790ee5  len: 16  clientid: TRANS  flags: none
> > RUD:  #regs: 1                   id: 0xffff8880422f35c0
> > ----------------------------------------------------------------------------
> > 
> > Yup, there's the ordering evidence. The checkpoint sequence is:
> > 
> > d3047f93 (RUI 0xffff888034f3edb0)
> > c960e383 (RUD 0xffff888034f3edb0)
> > 
> > c960e383 (RUI 0xffff8880422f1d90)
> > 53552074 (RUD 0xffff8880422f1d90)
> > 
> > 53552074 (RUI 0xffff8880422f35c0)
> > 22790ee5 (RUD 0xffff8880422f35c0)
> > 
> > So what we have here is log recovery failing to handle checkpoints
> > that -start- out of order in the log because it uses the /start lsn/
> > for recovery LSN sequencing, not the commit record LSN. However, it
> > uses the commit record ordering for sequencing the recovery of
> > checkpoints. The code that uses the start lsn for recvery of commit
> > records appears to be:
> > 
> > STATIC int
> > xlog_recover_items_pass2(
> >         struct xlog                     *log,
> >         struct xlog_recover             *trans,
> >         struct list_head                *buffer_list,
> >         struct list_head                *item_list)
> > {
> >         struct xlog_recover_item        *item;
> >         int                             error = 0;
> > 
> >         list_for_each_entry(item, item_list, ri_list) {
> >                 trace_xfs_log_recover_item_recover(log, trans, item,
> >                                 XLOG_RECOVER_PASS2);
> > 
> >                 if (item->ri_ops->commit_pass2)
> >                         error = item->ri_ops->commit_pass2(log, buffer_list,
> > >>>>>>>>>>                               item, trans->r_lsn);
> >                 if (error)
> >                         return error;
> >         }
> > 
> >         return error;
> > }
> > 
> > trans->r_lsn is the LSN where the start record for the
> > commit is found, not the LSN the commit record was found. At run
> > time, we do all our ordering off start record LSN because new
> > journal writes cannot be allowed to overwrite the start of the
> > checkpoint before every item in the checkpoint has been written back
> > to disk. If we were to use the commit record LSN, the AIL would
> > allow the tail of the log to move over the start of the checkpoint
> > before every thing was written.
> > 
> > However, what is the implication of the AIL having -start lsns- for
> > checkpoint sequences out of order? And for log recovery finding the
> > head of the log? I think it means we have the potential for
> > checkpoint N to be complete in the log an needing recovery, but
> > checkpoint N+1 is not complete because we've allowed the tail of the
> > log to move past the start of that checkpoint. That will also cause
> > corruption log recovery corruption. And I have a sneaking suspiciion
> > that this may cause fsync/log force issues as well....
> > 
> > ----
> > 
> > Ok, time to step back and think about this for a bit. The good news
> > is that this can only happen with pipelined CIL commits, while means
> > allowing more than one CIL push to be in progress at once. We can
> > avoid this whole problem simply by setting the CIL workqueue back to
> > running just a single ordered work at a time. Call that Plan B.
> > 
> > The bad news is that this is zero day bug, so all kernels out there
> > will fail to recovery with out of order start records. Back before
> > delayed logging, we could have mulitple transactions commit to the
> > journal in just about any order and nesting, and they used exactly
> > the same start/commit ordering in recovery that is causing us
> > problems now. This wouldn't have been noticed, however, because
> > transactions were tiny back then, not huge checkpoints like we run
> > now. And if is was, it likely would have been blamed on broken
> > storage because it's so ephemeral and there was little test
> > infrastructure that exercised these paths... :/

It's a zero day bug, but at least nobody tripped over this until two
months ago.  I've been dealing on and off with customer escalations
involving a filesystem with large reflinked images that goes down, and
then some time after the recovery (minutes to weeks) they hit a
corruption goto and crash again.  I've been able to pin down the
symptoms to ... the "corrupt" refcount btree block containing partial
old contents, where the old contents are always aligned to 128 byte
boundaries, and when Dave mentioned this last night I realized that he
and I might have fallen into the same thing.

> > What this means is that we can't just make a fix to log recovery
> > because taking a log from a current kernel and replaying it on an
> > older kernel might still go very wrong, and do so silently. So I
> > think we have to fix what we write to the log.
> > 
> > Hence I think the only way forward here is to recognise that the
> > AIL, log forces and log recovery all require strictly ordered
> > checkpoint start records (and hence LSNs) as well as commit records.
> > We already strictly order the commit records (and this analysis
> > proves it is working correctly), so we should be able to leverage
> > the existing functionality to do this.
> > 
> 
> Ok. I still need to poke at the code and think about this, but what you
> describe here all makes sense. I wonder a bit if we have the option to
> fix recovery via some kind of backwards incompatibility, but that
> requires more thought (didn't we implement or at least consider
> something like a transient feature bit state some time reasonably
> recently? I thought we did but I can't quite put my finger on what it
> was for or if it landed upstream.).

We did -- it was (is) a patchset to turn on log incompat feature bits in
the superblock, and clear them later on when they're not in use and the
log is being cleaned.  I proposed doing that for atomic file content
swapping, and Allison's deferred xattrs patchset will want the same to
protect xattr log intent items.

> That train of thought aside, ordering start records a la traditional
> commit record ordering seems like a sane option. I am starting to think
> that your plan B might actually be a wise plan A, though. I already
> wished we weren't pushing so much log rewrite/rework through all in one
> cycle. Now it sounds like we require even more significant (in
> complexity, if not code churn, as I don't yet have a picture of what
> "start record ordering" looks like) functional changes to make an
> otherwise isolated change safe. Just my .02.

/me guesses that we should go with plan B for 5.14, and work on fixing
whatever's wrong for 5.15.  But since it's never possible to tell how
much time is left until the merge window opens, I'll keep an open
mind...

> Brian
> 
> > So I think I see a simple way out of this. I'll sleep on it and see
> > if if I still think that in the morning...

...at least until I hear what this simple way out is.

--D

> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
