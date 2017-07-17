Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37466 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbdGQXKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2017 19:10:12 -0400
Date: Mon, 17 Jul 2017 16:10:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Parent pointers
Message-ID: <20170717231003.GH4224@magnolia>
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
 <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
 <59690307.9090407@oracle.com>
 <5d8fa5a7-110a-520f-9b13-b10627950bd3@sandeen.net>
 <20170714190740.GA43494@bfoster.bfoster>
 <20170714224658.GB4224@magnolia>
 <20170717144813.GA56739@bfoster.bfoster>
 <20170717221407.GJ17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170717221407.GJ17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Allison Henderson <allison.henderson@oracle.com>, cmaiolino@redhat.com, linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 08:14:07AM +1000, Dave Chinner wrote:
> On Mon, Jul 17, 2017 at 10:48:16AM -0400, Brian Foster wrote:
> > On Fri, Jul 14, 2017 at 03:46:58PM -0700, Darrick J. Wong wrote:
> > > On Fri, Jul 14, 2017 at 03:07:41PM -0400, Brian Foster wrote:
> > > From what I can tell, he seems to have taken Mark's patches to pass dir
> > > offsets back from the dirent manipulation functions and then started
> > > writing a simple implementation of stuffing the attrs into the attr
> > > tree.
> 
> Yup, that's the idea.
> 
> > > > FWIW, I think there was some mention of porting some of the operations
> > > > over to the deferred ops infrastructure, but it's not clear to me off
> > > > the top of my head how important (or appropriate) that is.
> > > 
> > > Most of the users of xfs_trans_roll seem to be buried in the xattr code.
> > > For example, _attr_set can end up rolling a transaction after converting
> > > an attr fork from short format to leaf format before retrying the attr
> > > add operation, but we don't use log redo items (er, defer_ops items) to
> > > make sure log recovery will restart the attr add operation if we crash
> > > before the final _trans_commit after calling _attr_{leaf,node}_addname.
> > > 
> > > In the case of a regular xattr set operation this wouldn't have been a
> > > big deal because the fsetxattr call wouldn't have returned, so all the
> > > user could possibly see is an inode with a perhaps unnecessarily large
> > > xattr fork.  Now that we need to set xattrs in the same transaction
> > > chain as a directory operation, it becomes very important that log
> > > recovery gain the ability to resume an xattr add operation no matter
> > > where the log stopped.  Creating a directory can become this longwinded
> > > pile of updates:
> > > 
> > 
> > Ok, thanks for the summary. So we have some transaction ordering down in
> > the xattr code that might no longer be sufficient to provide atomicity
> > in the context of parent pointers (via directory operations).
> 
> We already have xattr operations that are not atomic with directory
> entry creation - security xattrs (default ACL, etc). This can mean
> that after a crash and recovery, we have a newly created file
> without any security xattr on it.
> 
> This is a long standing problem - it bites SGI's HSM (DMF) all the
> time, so rather than fixing the problem 10+ years ago, they added a
> post-boot inode scan (via bulkstat) to find inodes that didn't have
> a DMF xattr.

<nod>

That reminds me, Ted was asking what _check_xfs_test_fs (in xfstests)
does.  Judging from the nonexistent xfs_repair_ipaths command, I'm
guessing that program fixed up pptr xattrs if they were
broken/missing/whatever?

> The original parent pointer patchset also had this problem the
> moment xattrs were required (i.e. first hardlink) - the creation of
> the pp xattr was not atomic with the dirent creation. To solve this
> problem, I started by moving the xattr creation into the transaction
> context of the dirent.
> 
> > I see that
> > the current patch series increases the transaction size to accommodate
> > parent pointers, but that doesn't help us deal with those situations
> > where the transaction is rolled into a new one.
> 
> Right, I hadn't got that far. The plan effective was to get a proof
> of concept running with the xattr creation within the directory
> creation xact context and get that working, knowing that it still
> wasn't properly atomic. This was done before we had deferred ops,
> and my thinking at the time was to add an intent/done pair of ops
> to tell recovery it needed to add an xattr to the dirent once the
> xattr was inside the dirent context. i.e.
> 
> 	- move xattr inside dirent ctx
> 	- add pp intent
> 	- roll transaction
> 	- add pp xattr
> 	- roll final xattr transaction rather than commit
> 	- add pp done
> 	- commit dir ctx transaction.
> 
> This doesn't help us with security context xattrs, though, so
> when deferred ops came along, it made much more sense to me to
> make the adding of an xattr a deferred op so we could use the same
> mechanism for adding all the required xattrs to the inode atomically
> and so have a mechanism for recovery to replay them appropriately.

<nod>

> > > - Allocate directory block, map into data fork, chain rmap update, add
> > >   directory entry, chain pptr update;
> > > - Add rmap entry for new directory block (more chaining to fix
> > >   freelist), finish first rmap update;
> > > - Allocate xattr block for short->leaf conversion, map into attr fork,
> > >   chain rmap update; chain xattr add operation;
> > > - Add rmap entry for new xattr block (more chaining to fix freelist),
> > >   finish second rmap update;
> > > - Add xattr entry to file, finish xattr add operation;
> > > - Finish pptr update.
> > > 
> > > Basically, I think someone's going to have to go audit all the uses of
> > > xfs_trans_roll in the attr code to figure out which operations need redo
> > > items, and how to cram everything toegether into a single xfs_defer_ops,
> > > rather than sprinkling them around the attr code like we do now, because
> > > redo items cannot be deferred from one defer_ops to another.
> 
> Probably should handle that when we dup the transaction just before
> the roll, right?

Something like that.  Ideally, I think I'd like to have two xattr redo
items: "add key => value" and "remove key", where "add key" would first
ensure xattr space, roll, and then actually add the attr & value.  A big
problem with that scheme is that we then have to log the value, which
could be ... tough.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
