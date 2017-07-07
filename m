Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:32995 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdGGQNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jul 2017 12:13:39 -0400
Received: by mail-qt0-f179.google.com with SMTP id r30so30960361qtc.0
        for <linux-xfs@vger.kernel.org>; Fri, 07 Jul 2017 09:13:39 -0700 (PDT)
Message-ID: <1499444016.4967.1.camel@redhat.com>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 07 Jul 2017 12:13:36 -0400
In-Reply-To: <20170707155117.4zp7qkpreeptwlgc@thunk.org>
References: <20170629045940.GB5865@birch.djwong.org>
         <20170629143551.GB1651@fieldses.org>
         <20170629172528.GA5869@birch.djwong.org>
         <20170629183053.GA4178@fieldses.org> <20170629185022.GB4178@fieldses.org>
         <20170704040446.GB4704@birch.djwong.org>
         <20170705011534.GC1420@fieldses.org> <20170705191933.GA6297@magnolia>
         <20170705202750.j5texbm2xdxnph6m@thunk.org>
         <1499424697.5826.3.camel@redhat.com>
         <20170707155117.4zp7qkpreeptwlgc@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, 2017-07-07 at 11:51 -0400, Theodore Ts'o wrote:
> On Fri, Jul 07, 2017 at 06:51:37AM -0400, Jeff Layton wrote:
> > 
> > Right. That's the case today if we don't remove support for old
> > filehandles. If we were to remove them, the clients would get back
> > -ESTALE there if they tried to use the old 2.2-style fh's that they saw
> > before the upgrade.
> > 
> > The main takeaway here is that NFS filehandle lifetime is really only
> > bounded by the boot time of the oldest clients.
> 
> Well, and how long an NFS server is still up.  So one could construct
> a use case where a (hypothetical) system administrator had a RHEL 7.0
> system with a 2.2.16-22 kernel, and they try to update it to a
> (hypothetical) RHEL 10 kernel in one fell swoop with a 4.13+ kernel
> that no longer supports the 2-2-style fh's.  A client that had the
> server mounted when it was running the 2.2 kernel might only be up for
> a few hours, before the upgrade to RHEL 10 happened, and then the
> client would get ESTALE errors.
> 
> Of course, I've stopped carrying about enterprise kernel support a
> long time ago, so I just think that scenario is funny.  I recognize
> that folks who work at Red Hat have to worry about such things --- and
> I'm sorry.  :-)
> 
> In reality a server installed with RHEL 7.0 has probably died of old
> age by now --- unless someone crazy is running it in a VMware VM
> because they had some enterprise software package or some bar-code
> printing module for which they don't have source code[1], and so they are
> stuck on RHEL 7.0, even in 2017.  Have I mentioned I'm so glad I don't
> have to worry these sorts of things any more?
> 
> 					- Ted
> 
> [1] That wasn't a made up example; I once visited a customer on site,
> back in the day, that had that exact problem, and so they were stuck
> on some antique version of RHEL, and they expected me to help them.

Yep, exactly. An abrupt upgrade like that is always a possibility, but
it's pretty unlikely, and I don't have a ton of sympathy for anyone who
does that.

I guess another thing we could do as an interim step is to add a
scary-looking printk that fires when someone sends us one of these
really old-style filehandles.

That won't help the poor bastard who updates the host directly from
v2.2-era kernel to the version that eventually removes support for the
old filehandles. It might give us an idea of whether there are still
clients in the field that are still using them though.

-- 
Jeff Layton <jlayton@redhat.com>
