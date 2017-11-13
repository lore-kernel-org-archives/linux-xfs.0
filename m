Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:40896 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752241AbdKMWBi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 17:01:38 -0500
MIME-Version: 1.0
In-Reply-To: <20171113215601.GD6246@magnolia>
References: <CA+55aFxSJGeN=2X-uX-on1Uq2Nb8+v1aiMDz5H1+tKW_N5Q+6g@mail.gmail.com>
 <20171029225155.qcum5i75awrt5tzm@wfg-t540p.sh.intel.com> <20171030072021.gcgpaolo5m3myuln@wfg-t540p.sh.intel.com>
 <20171030074429.GC3283@eguan.usersys.redhat.com> <20171031001041.5qjzn5pjertpdc3e@wfg-t540p.sh.intel.com>
 <20171031065417.GD3283@eguan.usersys.redhat.com> <20171106011306.GB11631@zzz.localdomain>
 <20171113191322.GA123488@gmail.com> <ff823a95-3dff-0f2b-13ab-aab9bed7b0d3@kernel.dk>
 <CA+55aFxv4jVzoa_NpYOq=+TVpBvbSmJq++dPW5nmWNdxUEc-8Q@mail.gmail.com> <20171113215601.GD6246@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Nov 2017 14:01:36 -0800
Message-ID: <CA+55aFzQM747SW959w3CDD=6UypUa7XTqEyHnPaTcFCX+vDLGA@mail.gmail.com>
Subject: Re: [btrfs] WARNING: CPU: 0 PID: 6379 at fs/direct-io.c:293 dio_complete+0x1d4/0x220
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers3@gmail.com>, Eryu Guan <guaneryu@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 13, 2017 at 1:56 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> Wellll... the WARN_ON in question happens when:
>
> a) two programs race to write to the same part of a file, one via the page
>    cache and the other via directio
> b) the dio write completes, tries to invalidate the page cache, and fails
>    because the corresponding page cannot be invalidated
>
> At this point, the page cache contents don't reflect what's on disk, so
> I don't think we can quietly ignore the situation.

Direct-IO causing cache coherency issues? Really? I'm shocked and
surptised that that could _possibly_ happen.

But why the hell would you want a back-trace for it?

IOW, if you want to warn about it, use "pr_warn_ratelimited()" or
something. What did the backtrace and "looks like a kernel oops"
really help with?

And in the end, maybe even the warning is pointless. You used
direct-IO and cached IO at the same time, and you got coherency
issues. What did you expect? directio is fundamentally broken.

                 Linus
