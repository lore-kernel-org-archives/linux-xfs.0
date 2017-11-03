Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34796 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754648AbdKCQPC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Nov 2017 12:15:02 -0400
Date: Fri, 3 Nov 2017 12:14:48 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/14] xfs/348: dir->symlink corruption must not be
 allowed
Message-ID: <20171103161448.gqx3odbsoppsjrld@thunk.org>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957284389.18388.370732842906149356.stgit@magnolia>
 <20171102124214.GY17339@eguan.usersys.redhat.com>
 <20171102163754.GS4911@magnolia>
 <20171103043022.GC17339@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103043022.GC17339@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Nov 03, 2017 at 12:30:22PM +0800, Eryu Guan wrote:
> > Yes, they're buggy since we shouldn't be interpreting directory entries
> > as a link target given that the zero bytes in the "link target" will
> > screw things up.
> 
> Then I'm fine with taking it, and probably will edit the commit log a
> bit to reflect that we were missing a error case previously. Thanks!

Darrick, can we add a note indicating what commit needs to be
backported to make the failure go away?

					- Ted
