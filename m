Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E64C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 14:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B9AA610A1
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 14:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhIVODD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:03:03 -0400
Received: from sandeen.net ([63.231.237.45]:39752 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhIVODC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Sep 2021 10:03:02 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 225C414A18;
        Wed, 22 Sep 2021 09:01:08 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Bill O'Donnell <billodo@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20210916023652.GA34820@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Sprints
Message-ID: <3475534f-dd71-978a-0690-f54b5631a9d7@sandeen.net>
Date:   Wed, 22 Sep 2021 09:01:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210916023652.GA34820@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick -

Just wanted to chime in with my support for this approach - both the
more collaborative concept, and the planning specifics. And I think
those will go hand in hand. If specific goals (patchsets) are agreed on
for a release, it will be easier for people to focus and help get those
goals accomplished.

Thanks for thinking about this and proposing a plan. It might take a
little time to shift behaviors and expectations, but I think this is
totally worth a shot.

Thanks,
-Eric

On 9/15/21 9:36 PM, Darrick J. Wong wrote:
> Hi again,
> 
> Now that 5.15-rc1 is past, I would like to say something:
> 
> I've been reflecting on my (sharply higher) stress levels in 2021, and
> realized that I don't enjoy our development process anymore.  One of the
> nice things about being a co-maintainer is that I can take advantage of
> the fact that suggesting improvements == leadership, though that comes
> with the responsibility that leadership == actually making it happen.
> 
> The thing that has been bothering me these past few months is how we
> decide what's going into the next merge window.  People send patchsets
> at various points between the second week of the merge window and the
> week after -rc6, and then ... they wait to see if anyone will actually
> read them.  I or one of the maintainers will get to them eventually, but
> as a developer it's hard to know if nobody's responding because they
> don't like the patchset?  Or they're quietly on leave?  Or they're
> drowning trying to get their own patchsets out to the list?  Or they
> have too many bugs to triage and distro kernel backports?  Or they're
> afraid of me?
> 
> Regardless, I've had the experience that it's stressful as the
> maintainer looking at all the stuff needing review; it's stressful as a
> developer trying to figure out if I'm /really/ going to make any
> progress this cycle; and as a reviewer it's stressful keeping up with
> both of these dynamics.  I've also heard similar sentiments from
> everyone else.
> 
> The other problem I sense we're having is implied sole ownership of
> patchesets being developed.  Reviewers make comments, but then it seems
> like it's totally on the developer (as the applicant) to make all those
> changes.  It's ... frustrating to watch new code stall because reviewers
> ask for cleanups and code restructuring that are outside of the original
> scope of the series as a condition for adding a Reviewed-by tag... but
> then they don't work on those cleanups.
> 
> At that point, what's a developer to do?  Try to get someone else's
> attention and start the review process all over again?  Try to get
> another maintainer's attention and have them do it?  This last thing is
> hard if you're already a maintainer, because doing that slows /everyone/
> down.
> 
> (And yes, I've been growing our XFS team at Oracle this year so that
> this doesn't seem so one-sided with RedHat.)
> 
> I've also heard from a few of you who find it offputting when patches
> show up with verbiage that could be interpreted as "I know best and
> won't take any further suggestions".  I agree with your feelings when
> I hear complaints coming in, because my own thoughts had usually already
> been "hmm, this sounds preemptively defensive, why?"
> 
> Ok, so, things I /do/ like:
> 
> During the 5.15 development cycle I really enjoyed going back and forth
> with Dave over my deferred inode inactivation series and the log
> speedups that we were both proposing.  I learned about percpu lists, and
> I hope he found it useful to remember how that part of the inode cache
> works again.  This dialectic was what drew me to XFS back in 2014 when I
> started working on reflink, and I've been missing it, especially since
> the pandemic started.
> 
> So the question I have is: Can we do community sprints?  Let's get
> together (on the lists, or irc, wherever) the week after -rc2 drops to
> figure out who thinks they're close to submitting patchsets, decide
> which one or two big patchsets we as a group want to try to land this
> cycle, and then let's /all/ collaborate on making it happen.  If you
> think a cleanup would be a big help for someone else's patchset, write
> those changes and make that part happen.
> 
> There's never been a prohibition on us working like that, but I'd like
> it if we were more intentional about working like a coordinated team to
> get things done.  What do you all think?
> 
> (Small changes and bug fixes can be sent any time and I'll take a look
> at them; I'm not proposing any changes to that part of the process.)
> 
> --D
> 
