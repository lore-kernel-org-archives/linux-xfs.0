Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46416 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdKMV4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 16:56:18 -0500
Date: Mon, 13 Nov 2017 13:56:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [btrfs] WARNING: CPU: 0 PID: 6379 at fs/direct-io.c:293
 dio_complete+0x1d4/0x220
Message-ID: <20171113215601.GD6246@magnolia>
References: <CA+55aFxSJGeN=2X-uX-on1Uq2Nb8+v1aiMDz5H1+tKW_N5Q+6g@mail.gmail.com>
 <20171029225155.qcum5i75awrt5tzm@wfg-t540p.sh.intel.com>
 <20171030072021.gcgpaolo5m3myuln@wfg-t540p.sh.intel.com>
 <20171030074429.GC3283@eguan.usersys.redhat.com>
 <20171031001041.5qjzn5pjertpdc3e@wfg-t540p.sh.intel.com>
 <20171031065417.GD3283@eguan.usersys.redhat.com>
 <20171106011306.GB11631@zzz.localdomain>
 <20171113191322.GA123488@gmail.com>
 <ff823a95-3dff-0f2b-13ab-aab9bed7b0d3@kernel.dk>
 <CA+55aFxv4jVzoa_NpYOq=+TVpBvbSmJq++dPW5nmWNdxUEc-8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxv4jVzoa_NpYOq=+TVpBvbSmJq++dPW5nmWNdxUEc-8Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers3@gmail.com>, Eryu Guan <guaneryu@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

[cc xfs list]

[We're discussing the WARN_ON in *dio_complete when invalidation fails]

[yes, again]

On Mon, Nov 13, 2017 at 11:21:50AM -0800, Linus Torvalds wrote:
> On Mon, Nov 13, 2017 at 11:16 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > I would tend to agree with you, it's annoying to dump a full stack trace
> > for an expected (even for a rare situation) condition. But it's not the
> > first one, there's also one in XFS that always triggers for test runs. I
> > complained about that one in the past.
> 
> Yeah, we should always consider a WARN_ON() that is triggerable from
> user space to be a kernel bug.
> 
> If it's a "cannot happen", then the bug should be fixed.
> 
> If it's a "can happen, but I want to see the trace", then you just got
> the trace and you're done, and the WARN_ON() should be removed.
> 
> It could possibly be replaced with a "pr_warn()" or something, so that
> it still shows up as a "the user did something dodgy", but honestly,
> even that is questionable. We do that for things like "we just removed
> support for this, we want to see if somebody is using it"
> 
> So in no case is "let's just keep things as is" the right answer.

Wellll... the WARN_ON in question happens when:

a) two programs race to write to the same part of a file, one via the page
   cache and the other via directio
b) the dio write completes, tries to invalidate the page cache, and fails
   because the corresponding page cannot be invalidated

At this point, the page cache contents don't reflect what's on disk, so
I don't think we can quietly ignore the situation.  Clearly, enough
people dislike the WARN to complain repeatedly, so perhaps we should try
to barf evidence of this situation up to userspace?  The dio write
succeeded, which is why we don't turn err into ret; but now that we can
store and forward error codes through the mapping, how about we just:

   errseq_set(dio->inode->i_mapping->wb_error, -EIO);

and then let the writers pick up the EIO the next time they fsync?
Though I can already imagine the complaints about writes that used to
work and suddenly start returning error codes.

--D

>                Linus
