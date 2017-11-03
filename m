Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46683 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755158AbdKCQbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 12:31:02 -0400
Date: Fri, 3 Nov 2017 09:30:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/14] xfs/348: dir->symlink corruption must not be
 allowed
Message-ID: <20171103163057.GI4911@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957284389.18388.370732842906149356.stgit@magnolia>
 <20171102124214.GY17339@eguan.usersys.redhat.com>
 <20171102163754.GS4911@magnolia>
 <20171103043022.GC17339@eguan.usersys.redhat.com>
 <20171103161448.gqx3odbsoppsjrld@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103161448.gqx3odbsoppsjrld@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Nov 03, 2017 at 12:14:48PM -0400, Theodore Ts'o wrote:
> On Fri, Nov 03, 2017 at 12:30:22PM +0800, Eryu Guan wrote:
> > > Yes, they're buggy since we shouldn't be interpreting directory entries
> > > as a link target given that the zero bytes in the "link target" will
> > > screw things up.
> > 
> > Then I'm fine with taking it, and probably will edit the commit log a
> > bit to reflect that we were missing a error case previously. Thanks!
> 
> Darrick, can we add a note indicating what commit needs to be
> backported to make the failure go away?

Will do when the time comes.  TBH we've not been consistent about
marking regression tests with the appropriate upstream commit id once
they're available.

--D

> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
