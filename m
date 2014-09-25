Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B1477FDA
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 17:42:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 18E158F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 15:42:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GWYiDD27zsQetr39 for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 15:42:28 -0700 (PDT)
Date: Fri, 26 Sep 2014 08:42:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140925224225.GJ4945@dastard>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
	<20140924170105.GE27000@quack.suse.cz>
	<20140925075912.GG4758@dastard>
	<20140925135213.GB15352@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925135213.GB15352@quack.suse.cz>
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

On Thu, Sep 25, 2014 at 03:52:13PM +0200, Jan Kara wrote:
> On Thu 25-09-14 17:59:12, Dave Chinner wrote:
> > On Wed, Sep 24, 2014 at 07:01:05PM +0200, Jan Kara wrote:
> > > On Wed 24-09-14 09:26:34, Christoph Hellwig wrote:
> > > > On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> > > > > On Wed 24-09-14 22:04:30, Li Xi wrote:
> > > > > > This patch adds ioctl interface for setting/getting project of ext4.
> > > > >   The patch looks good to me. I was just wondering whether it won't be
> > > > > useful to add an ioctl() which isn't ext4 specific. We could just extend
> > > > > ->setattr() to allow setting of project ID (most filesystems would just
> > > > > return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> > > > > ->setattr from the generic ioctl. That way userspace won't have to care
> > > > > about filesystem type when setting project ID... What do others think?
> > > > 
> > > > Absolutely.  In general I also wonder why this patch doesn't implement
> > > > the full XFS API.  Maybe there is a reason it was considered and
> > > > rejected, but it would be helpful to document why.
> > >   Do you mean full get/setfsxattr API?
> > 
> > That's a good start.
> > 
> > The bigger issue in my mind is that we already have a fully featured
> > quota API that supports project quotas and userspace tools available
> > that manipulate it. xfstests already uses those tools and API
> > for testing project quotas.
>   Well, the VFS quota API is trivially extended by adding additional quota
> type so I don't really see about which reinventing of quota API are you
> speaking here...

It doesn't seem quite as trivial as you make out given  all thei
issues so far around increasing MAXQUOTA, the increase in size of
the inode, etc.

> > This whole patchset reinvents all the quota APIs, and will require
> > adding support in userspace, and hence require re-inventing all the
> > test infrastructure we already have because it won't be compatible
> > with the existing project quota test code.
>   Well, quota-tools will have to extended to know about the new quota type.
> Yes. But that's easy to do. I think teaching xfs quota tools to work with
> ext4 will be a bigger project plus I don't think I want to force sysadmins
> which are used to work with quota-tools to switch to other utilities just
> because of project quotas.
> 
> Regarding xfstests - I've checked and most of the project quota tests in
> xfs directory aren't directly usable for ext4 anyway because of other
> functionality ext4 doesn't support. So we'll need to distill the least
> common denominator from them anyway...

I just did a quick scan - of the ~13 tests in tests/xfs that
exercise project quotas, only 2 of them test things that are xfs
specific (e.g. use xfs_db to peer at things, or use xfs_admin, etc).
The rest all rely on xfs_quota to manage and configure project
quotas but otherwise don't do anything XFS specific.

We want project quotas to have the same management interface for
administrators regardless of the filesystem they are using. The only
way we can do that is to ensure that the same tools work on either
filesystem, and right now it seems to me that the ext4 NIH syndrome
is winning out over what is best for our users...

Look, I have no problems with extending the existing quota
interfaces to support project quotas, but that should be a
*secondary* improvement as userspace tools are updated. The
primary goal needs to be "works identically to XFS" and so it needs
to implement the interfaces that are currently used for management
so that we can actually test that it does work identically.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
