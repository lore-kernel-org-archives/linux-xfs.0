Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:34671 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbcJEPaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 11:30:16 -0400
Date: Wed, 5 Oct 2016 11:30:14 -0400
From: tj <tj@kernel.org>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161005153014.GC26977@htj.duckdns.org>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
 <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
 <774397084.821469.1475260403929.JavaMail.zimbra@redhat.com>
 <20161003013737.GR19539@ZenIV.linux.org.uk>
 <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com>
 <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com>
 <20161004214219.GN4205@htj.duckdns.org>
 <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

Hello, CAI.

On Wed, Oct 05, 2016 at 10:09:39AM -0400, CAI Qian wrote:
> > This one seems to be the offender.  cgroup is trying to offline a
> > cpuset css, which takes place under cgroup_mutex.  The offlining ends
> > up trying to drain active usages of a sysctl table which apprently is
> > not happening.  Did something hang or crash while trying to generate
> > sysctl content?
>
> Hmm, I am not sure, since the trinity was running from an non-privileged
> user which can only read content from /proc or /sys.

So, userland, priviledged or not, can't cause this.  The ref is held
only while the kernel code is operating to generate content or
iterating, which shouldn't be affected by userland actions.  This is
caused by kernel code hanging or crashing while holding a ref.

Thanks.

-- 
tejun
