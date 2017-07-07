Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:36464 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdGGKvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jul 2017 06:51:39 -0400
Received: by mail-qt0-f180.google.com with SMTP id i2so23710776qta.3
        for <linux-xfs@vger.kernel.org>; Fri, 07 Jul 2017 03:51:39 -0700 (PDT)
Message-ID: <1499424697.5826.3.camel@redhat.com>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 07 Jul 2017 06:51:37 -0400
In-Reply-To: <20170705202750.j5texbm2xdxnph6m@thunk.org>
References: <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
         <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
         <20170629045940.GB5865@birch.djwong.org>
         <20170629143551.GB1651@fieldses.org>
         <20170629172528.GA5869@birch.djwong.org>
         <20170629183053.GA4178@fieldses.org> <20170629185022.GB4178@fieldses.org>
         <20170704040446.GB4704@birch.djwong.org>
         <20170705011534.GC1420@fieldses.org> <20170705191933.GA6297@magnolia>
         <20170705202750.j5texbm2xdxnph6m@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, 2017-07-05 at 16:27 -0400, Theodore Ts'o wrote:
> On Wed, Jul 05, 2017 at 12:19:33PM -0700, Darrick J. Wong wrote:
> > 
> > So, what's the probability that there are clients out there that started
> > talking to a 2.2-based knfsd and will now want to talk to a modern 4.13
> > kernel seventeen years later?  (Do nfs handles persist across client
> > restarts/remounts?)
> 
> It's whether or not nfs handles persist across server restarts which
> would be the more interesting question.  So if you had a NAS box that
> was using a Linux 2.2 kernel, and you had clients access the box, and
> then that box gets upgraded to use a 4.13 kernel, what happens?
> 
> In the ideal world, the client wouldn't notice, and its 2.2-based file
> handles that it obtained while the 2.2 kernel was running would
> continue to work after the box came back up running the new 4.13
> kernel.
> 

Right. That's the case today if we don't remove support for old
filehandles. If we were to remove them, the clients would get back
-ESTALE there if they tried to use the old 2.2-style fh's that they saw
before the upgrade.

The main takeaway here is that NFS filehandle lifetime is really only
bounded by the boot time of the oldest clients.

> To be honest, I'm not sure I care that much, but I don't use NFS much
> if at all these days myself.  And in reality, what's the chance that
> an NAS box vendor would continue to support a box that is 17 years old
> and provide an upgrade for it?  (OK, everyone can stop laughing now. :-)

Agreed. I think we're safe enough to remove this support.

If we were really concerned about it, we could move support for it under
a Kconfig option that defaults to "off" for now, and then we could plan
to just drop it in a couple of years.

Vendors that thought they might need it could enable it and speak up
with their use case if they wanted to keep it in for future releases.
Most likely though, no-one will care.
-- 
Jeff Layton <jlayton@redhat.com>
