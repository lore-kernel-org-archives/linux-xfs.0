Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751468AbdCAD1N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:27:13 -0500
Date: Wed, 1 Mar 2017 11:20:13 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/4] reflink: test adjacency of reflinked blocks
Message-ID: <20170301032013.GA14226@eguan.usersys.redhat.com>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
 <148798517790.25833.2585159479268361866.stgit@birch.djwong.org>
 <20170228081502.GG16443@eguan.usersys.redhat.com>
 <20170228163150.GA26275@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228163150.GA26275@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@djwong.org>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Feb 28, 2017 at 08:31:50AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 28, 2017 at 04:15:02PM +0800, Eryu Guan wrote:
> > On Fri, Feb 24, 2017 at 05:12:57PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > If we reflink a file with N blocks to another file one block at a time,
> > > does the destination file end up with the same number of extents as the
> > > source file?  In other words, does the filesystem succeed at combining
> > > adjacent mappings into a maximal extents?
> > 
> > I'm not sure if this is a standard behavior and applies to btrfs too?
> > But btrfs is failing this test now:
> > 
> > +f1 (1) != f2 (32)
> > +s1 (1) != s2 (32)
> > 
> > Fix test or btrfs? I'm taking it if btrfs is the one to be fixed :)
> 
> btrfs has that weird behavior where it doesn't merge the adjacent
> extents at all (at least not according to FIEMAP) until you remount the
> filesystem.  After the remount it's fine, but... WTF? :)
> 
> So yes, the test is working as designed.  btrfs needs fixing, or I guess
> worst case we can _notrun it on btrfs.

Thanks for the explanation! I'll take it as it is at this moment then.

> 
> Snark aside, it was intended originally to make sure that XFS is
> properly merging the extent records together; then it occurred to me to
> rewrite it with fiemap and make it one of the generic reflink tests so
> that ocfs2 can get tested too.

Ah, that reminds me that I need to do testing with ocfs2 too, and test
passed :)

Thanks,
Eryu
