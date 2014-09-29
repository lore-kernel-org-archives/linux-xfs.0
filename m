Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 721077FF6
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 11:04:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F24C304051
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 09:04:39 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QiFPMSbmhJjFqYRj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 09:04:31 -0700 (PDT)
Date: Mon, 29 Sep 2014 17:55:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140929155515.GE6328@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
	<20140924170105.GE27000@quack.suse.cz>
	<20140925075912.GG4758@dastard>
	<20140925135213.GB15352@quack.suse.cz>
	<20140925224225.GJ4945@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925224225.GJ4945@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: adilger@dilger.ca, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org

On Fri 26-09-14 08:42:25, Dave Chinner wrote:
> On Thu, Sep 25, 2014 at 03:52:13PM +0200, Jan Kara wrote:
> > On Thu 25-09-14 17:59:12, Dave Chinner wrote:
> > > On Wed, Sep 24, 2014 at 07:01:05PM +0200, Jan Kara wrote:
> > > > On Wed 24-09-14 09:26:34, Christoph Hellwig wrote:
> > > > > On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> > > > > > On Wed 24-09-14 22:04:30, Li Xi wrote:
> > > > > > > This patch adds ioctl interface for setting/getting project of ext4.
> > > > > >   The patch looks good to me. I was just wondering whether it won't be
> > > > > > useful to add an ioctl() which isn't ext4 specific. We could just extend
> > > > > > ->setattr() to allow setting of project ID (most filesystems would just
> > > > > > return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> > > > > > ->setattr from the generic ioctl. That way userspace won't have to care
> > > > > > about filesystem type when setting project ID... What do others think?
> > > > > 
> > > > > Absolutely.  In general I also wonder why this patch doesn't implement
> > > > > the full XFS API.  Maybe there is a reason it was considered and
> > > > > rejected, but it would be helpful to document why.
> > > >   Do you mean full get/setfsxattr API?
> > > 
> > > That's a good start.
> > > 
> > > The bigger issue in my mind is that we already have a fully featured
> > > quota API that supports project quotas and userspace tools available
> > > that manipulate it. xfstests already uses those tools and API
> > > for testing project quotas.
> >   Well, the VFS quota API is trivially extended by adding additional quota
> > type so I don't really see about which reinventing of quota API are you
> > speaking here...
> 
> It doesn't seem quite as trivial as you make out given  all thei
> issues so far around increasing MAXQUOTA, the increase in size of
> the inode, etc.
  Well, troubles with increasing MAXQUOTAS is more about expectations
that VFS quota subsystem can support only 2 quota types. So we have to do
those changes regardless of interface we choose.

There is one change necessary in the interface (not done yet) and that is
that filesystems using VFS quotas and not supporting project quotas will
need to refuse quotactls for project quotas. This won't be necessary if we
simply refuse to manipulate project quotas using the standard VFS
interface. But I wouldn't call it difficult either.

> > > This whole patchset reinvents all the quota APIs, and will require
> > > adding support in userspace, and hence require re-inventing all the
> > > test infrastructure we already have because it won't be compatible
> > > with the existing project quota test code.
> >   Well, quota-tools will have to extended to know about the new quota type.
> > Yes. But that's easy to do. I think teaching xfs quota tools to work with
> > ext4 will be a bigger project plus I don't think I want to force sysadmins
> > which are used to work with quota-tools to switch to other utilities just
> > because of project quotas.
> > 
> > Regarding xfstests - I've checked and most of the project quota tests in
> > xfs directory aren't directly usable for ext4 anyway because of other
> > functionality ext4 doesn't support. So we'll need to distill the least
> > common denominator from them anyway...
> 
> I just did a quick scan - of the ~13 tests in tests/xfs that
> exercise project quotas, only 2 of them test things that are xfs
> specific (e.g. use xfs_db to peer at things, or use xfs_admin, etc).
> The rest all rely on xfs_quota to manage and configure project
> quotas but otherwise don't do anything XFS specific.
  Yeah, I messed up my original check (I originally found like 5 project
quota related tests and they were those problematic). I checked again and
most of them should be relatively easy to adapt (we'll need some changes
for mount options handling but that's inevitable).

> We want project quotas to have the same management interface for
> administrators regardless of the filesystem they are using. The only
> way we can do that is to ensure that the same tools work on either
> filesystem, and right now it seems to me that the ext4 NIH syndrome
> is winning out over what is best for our users...
> 
> Look, I have no problems with extending the existing quota
> interfaces to support project quotas, but that should be a
> *secondary* improvement as userspace tools are updated. The
> primary goal needs to be "works identically to XFS" and so it needs
> to implement the interfaces that are currently used for management
> so that we can actually test that it does work identically.
  So I had another look at the quotactl interface we are speaking about.
XFS has the following commands there:
Q_XQUOTAON
Q_XQUOTAOFF
  These could be relatively easily hooked up to call appropriate VFS
  functions.

Q_XQUOTARM
  This doesn't have equivalent in VFS and currently I'm not convinced we
want to do the work in filesystems to support this...

Q_XGETQSTAT
Q_XGETQSTATV
  This corresponds to Q_GETINFO of VFS quotas although it provides more
information. We don't easily have things like number of incore dquots or
number of file extents available. There's also no limit on the number of
warnings. But other than that diverting these to VFS interfaces through a
translation function should be easy. Any idea on what numbers should we
present from VFS?

BTW how do you set the information? We have Q_SETINFO for that in VFS
quotas.

Q_XSETQLIM
Q_XGETQUOTA
  These are already handled so they work regardless of the underlying fs
type.

Q_XQUOTASYNC
  This is the same as Q_SYNC. For VFS quotas we need to do some work in some
cases.

  So all in all it seems relatively easy to make the VFS and XFS quota
interfaces more compatible than they are now and it's a direction I like.
I can have a look into that once I finish patches to move i_dquot[] array
out of generic inode (which is desirable regardless of project quotas).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
