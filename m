Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2266A7F8A
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 02:59:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFEFDAC004
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 00:59:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dPTc82bhXgWSzyfE for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 00:59:27 -0700 (PDT)
Date: Thu, 25 Sep 2014 17:59:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140925075912.GG4758@dastard>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
	<20140924170105.GE27000@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140924170105.GE27000@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Sep 24, 2014 at 07:01:05PM +0200, Jan Kara wrote:
> On Wed 24-09-14 09:26:34, Christoph Hellwig wrote:
> > On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> > > On Wed 24-09-14 22:04:30, Li Xi wrote:
> > > > This patch adds ioctl interface for setting/getting project of ext4.
> > >   The patch looks good to me. I was just wondering whether it won't be
> > > useful to add an ioctl() which isn't ext4 specific. We could just extend
> > > ->setattr() to allow setting of project ID (most filesystems would just
> > > return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> > > ->setattr from the generic ioctl. That way userspace won't have to care
> > > about filesystem type when setting project ID... What do others think?
> > 
> > Absolutely.  In general I also wonder why this patch doesn't implement
> > the full XFS API.  Maybe there is a reason it was considered and
> > rejected, but it would be helpful to document why.
>   Do you mean full get/setfsxattr API?

That's a good start.

The bigger issue in my mind is that we already have a fully featured
quota API that supports project quotas and userspace tools available
that manipulate it. xfstests already uses those tools and API
for testing project quotas.

This whole patchset reinvents all the quota APIs, and will require
adding support in userspace, and hence require re-inventing all the
test infrastructure we already have because it won't be compatible
with the existing project quota test code.

>   That basically contains project ID,
> flags (those that are currently get/set with FS_IOC_GETFLAGS/SETFLAGS), and
> extent size hint right?

It's a different set of flag definitions. We translate the interface
XFS_XFLAG_* values to/from the inode on-disk XFS_DIFLAG_* inode values, just
like we translate the VFS FS_*_FL flags that get passed through the
FS_IOC_GETFLAGS/SETFLAGS ioctl.

> That seems workable and it would also make setting
> of PROJINHERIT flag fs agnostic. Only we would have to create some generic
> flags namespace and merge into that ext4 flags and have a translation
> function for the old ext4 flags.

The XFS_XFLAGS_* are already filesystem agnostic - they are flags
that are only used for interfacing with userspace and hence only
exist at the ioctl copy in/out layer.....

> Also I'm afraid we may quickly run out of
> 32 available flags in xflags so we'd need to extend that. But all this
> seems to be doable.

The struct fsxattr was designed to be extensible - it has unused
padding and enough space in the flags field to allow us to
conditionally use that padding....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
