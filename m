Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:39911 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755872AbcJMU7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2016 16:59:12 -0400
Date: Thu, 13 Oct 2016 16:56:35 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <276304423.810977.1476392195227.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161013204917.GQ23194@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20161009215454.GM9806@dastard> <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com> <20161010215714.GF23194@dastard> <885869771.578073.1476301836438.JavaMail.zimbra@redhat.com> <20161012205901.GF27872@dastard> <895314622.769515.1476375930648.JavaMail.zimbra@redhat.com> <20161013204917.GQ23194@dastard>
Subject: Re: [bisected] Re: local DoS - systemd hang or timeout (WAS: Re:
 [RFC][CFT] splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sage Weil <sage@redhat.com>, Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> Sent: Thursday, October 13, 2016 4:49:17 PM
> Subject: Re: [bisected] Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
>
> Why? This isn't a security issue - CVEs cost time and effort for
> everyone to track and follow and raising them for issues like this
> does not help anyone fix the actual problem.  It doesn't help us
> track it, analyse it, communicate with the bug reporter, test it or
> get the fix committed.  It's meaningless to the developers fixing
> the code, it's meaningless to users, and it's meaningless to most
> distros that are supporting XFS because the distro maintainers don't
> watch the CVE lists for XFS bugs they need to backport and fix.
> 
> All this does is artificially inflate the supposed importance of the
> bug. CVEs are for security or severe issues. This is neither serious
> or a security issue - please have the common courtesy to ask the
> people with the knowledge to make such a determination (i.e. the
> maintainers) before you waste the time of a /large number/ of people
> by raising a useless CVE...
> 
> Yes, you found a bug. No, it's not a security bug. No, you should
> not abusing of the CVE process to apply pressure to get it fixed.
> Please don't do this again.
As far as I can tell, this is a medium-severity security issue that a
non-privileged user can exploit it to cause a system hang/deadlock.
Hence, a local DoS for other users use the system.
   CAI Qian
