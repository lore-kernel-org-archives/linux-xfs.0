Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22563 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756580AbcJMUtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2016 16:49:31 -0400
Date: Fri, 14 Oct 2016 07:49:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [bisected] Re: local DoS - systemd hang or timeout (WAS: Re:
 [RFC][CFT] splice_read reworked)
Message-ID: <20161013204917.GQ23194@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com>
 <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com>
 <20161009215454.GM9806@dastard>
 <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com>
 <20161010215714.GF23194@dastard>
 <885869771.578073.1476301836438.JavaMail.zimbra@redhat.com>
 <20161012205901.GF27872@dastard>
 <895314622.769515.1476375930648.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <895314622.769515.1476375930648.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Sage Weil <sage@redhat.com>, Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>

On Thu, Oct 13, 2016 at 12:25:30PM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > Sent: Wednesday, October 12, 2016 4:59:01 PM
> > Subject: Re: [bisected] Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> > 
> > On Wed, Oct 12, 2016 at 03:50:36PM -0400, CAI Qian wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Dave Chinner" <david@fromorbit.com>
> > > > Sent: Monday, October 10, 2016 5:57:14 PM
> > > > 
> > > > > http://people.redhat.com/qcai/tmp/dmesg
> > > > 
> > > > It's a page lock order bug in the XFS seek hole/data implementation.
> > > So reverted this commit against the latest mainline allows trinity run
> > > hours. Otherwise, it always hang at fdatasync() within 30 minutes.
> > > 
> > > fc0561cefc04e7803c0f6501ca4f310a502f65b8
> > > xfs: optimise away log forces on timestamp updates for fdatasync
> > 
> > Has nothing at all to do with the hang.
> > 
> > > PS: tested against the vfs tree's #work.splice_read with this commit
> > > reverted is now hanging at sync() instead which won't be  reproduced
> > > against the mainline so far.
> > > http://people.redhat.com/qcai/tmp/dmesg-sync
> > 
> > It is the same page lock vs seek hole/data issue.
> FYI, CVE-2016-8660 was assigned for it.

Why? This isn't a security issue - CVEs cost time and effort for
everyone to track and follow and raising them for issues like this
does not help anyone fix the actual problem.  It doesn't help us
track it, analyse it, communicate with the bug reporter, test it or
get the fix committed.  It's meaningless to the developers fixing
the code, it's meaningless to users, and it's meaningless to most
distros that are supporting XFS because the distro maintainers don't
watch the CVE lists for XFS bugs they need to backport and fix.

All this does is artificially inflate the supposed importance of the
bug. CVEs are for security or severe issues. This is neither serious
or a security issue - please have the common courtesy to ask the
people with the knowledge to make such a determination (i.e. the
maintainers) before you waste the time of a /large number/ of people
by raising a useless CVE...

Yes, you found a bug. No, it's not a security bug. No, you should
not abusing of the CVE process to apply pressure to get it fixed.
Please don't do this again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
