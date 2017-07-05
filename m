Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50700 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752500AbdGEU2D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jul 2017 16:28:03 -0400
Date: Wed, 5 Jul 2017 16:27:50 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170705202750.j5texbm2xdxnph6m@thunk.org>
References: <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
 <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
 <20170629045940.GB5865@birch.djwong.org>
 <20170629143551.GB1651@fieldses.org>
 <20170629172528.GA5869@birch.djwong.org>
 <20170629183053.GA4178@fieldses.org>
 <20170629185022.GB4178@fieldses.org>
 <20170704040446.GB4704@birch.djwong.org>
 <20170705011534.GC1420@fieldses.org>
 <20170705191933.GA6297@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170705191933.GA6297@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, Jul 05, 2017 at 12:19:33PM -0700, Darrick J. Wong wrote:
> 
> So, what's the probability that there are clients out there that started
> talking to a 2.2-based knfsd and will now want to talk to a modern 4.13
> kernel seventeen years later?  (Do nfs handles persist across client
> restarts/remounts?)

It's whether or not nfs handles persist across server restarts which
would be the more interesting question.  So if you had a NAS box that
was using a Linux 2.2 kernel, and you had clients access the box, and
then that box gets upgraded to use a 4.13 kernel, what happens?

In the ideal world, the client wouldn't notice, and its 2.2-based file
handles that it obtained while the 2.2 kernel was running would
continue to work after the box came back up running the new 4.13
kernel.

To be honest, I'm not sure I care that much, but I don't use NFS much
if at all these days myself.  And in reality, what's the chance that
an NAS box vendor would continue to support a box that is 17 years old
and provide an upgrade for it?  (OK, everyone can stop laughing now. :-)

    	       	       	   	- Ted
