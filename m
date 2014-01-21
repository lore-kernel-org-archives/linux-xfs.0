Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0E8529DF8
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 01:02:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7043304048
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 23:02:48 -0800 (PST)
Received: from mail-pb0-f41.google.com (mail-pb0-f41.google.com
	[209.85.160.41]) by cuda.sgi.com with ESMTP id QPa6SZzbzPRlo6rn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jan 2014 23:02:44 -0800 (PST)
Received: by mail-pb0-f41.google.com with SMTP id up15so7453529pbc.14
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 23:02:44 -0800 (PST)
Date: Tue, 21 Jan 2014 15:07:06 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] directory quota survey on xfs
Message-ID: <20140121070706.GA1819@gmail.com>
References: <20131222095929.GA11444@gmail.com> <20131223014222.GC3220@dastard>
	<20140115081201.GA3820@gmail.com>
	<5966C533-EF18-4804-8C83-DFBD607D9BE6@dilger.ca>
	<20140115213207.GJ3431@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140115213207.GJ3431@dastard>
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
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <pkuelelixi@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>

Hi Dave,

On Thu, Jan 16, 2014 at 08:32:07AM +1100, Dave Chinner wrote:
> On Wed, Jan 15, 2014 at 11:03:22AM -0700, Andreas Dilger wrote:
> > On Jan 15, 2014, at 1:12 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > > On Mon, Dec 23, 2013 at 12:42:22PM +1100, Dave Chinner wrote:
> > >> I'd also strongly suggest that you use the XFS userspace quota API
> > >> for managing project quotas, so that we can use the same management
> > >> tools and tests to verify that they behave the same. Please don't
> > >> invent a new version of the quota API to implement this - everything
> > >> you need ifor managing project/directory quotas is already there in
> > >> xfs_quota.....
> > > 
> > > Frankly, I don't like this, really.  Now we have quota-tool to manage
> > > the quota in ext4.  So IMHO we'd better go on using this tool because it
> > > is natural for ext4 users.
> 
> Zheng - you're confusing the userspace tool that users run with
> the quotactl API the tool uses to communicate with the kernel.

Thanks for pointing it out.

> 
> > > I still couldn't accept this fact that I
> > > need to install xfsprogs for using a feature of ext4.  Further, it could
> > > make users puzzled because they use quota to control user/group quota in
> > > ext4, but it uses xfs_quota to control project quota.  It could bring
> > > some troubles for the ext4 users who have written some scripts to manage
> > > their machines.
> > 
> > Please see Li Xi's recent email "Directory/Project quota supports" on
> > the linux-ext4 list.  He has already added some prototype support for
> > project quotas to quota-tools.
> 
> So, while it is a prototype, lets do it the right way. i.e. let's
> not reinvent the wheel.

Yes, I agree with you and Andreas that we shouldn't reinvent the wheel.

> 
> > I think it might make sense to keep the same API as XFS for the ext4
> > quotas (to keep compatibility for existing XFS deployments), but add
> > support into quota-tools so that it is usable by all filesystems.
> 
> Well, yes. If you are writing a generic quota tool, then it needs to
> support all filesystems. We already have a fully featured quota API
> that can provide this support - it's the API that XFS has been using
> since it was ported to Linux.  We have the opportunity to unify the
> quota APIs that ext4 and XFS, so we should take the opportunity
> while it is here.  Don't create a new API for ext4 simply because of
> NIH syndrome.

These days I was thinking about your comment that uses quotactl API to
communicate the userspace tool with the kernel.  But I am still
confusing about your comment that unifies the quota API between ext4 and
XFS.

Now we have two flag sets in quotactl(2).  One (Q_QUOTAON, Q_GETQUOTA,
etc...) is used by extN file system (I am not sure whether other file
systems use these flags or not), and another (Q_XQUOTAON, Q_XGETQSTAT,
etc...) is used by XFS.

In xfs_quota it uses an ioctl(2) to get/set/check project id, and calls
quotactl(2) with Q_XSETQLIM/Q_XGETQUOTA to set/get project quota.  On
kernel side, ->set_dqblk()/get_dqblk() is called when we try to set/get
project quota in XFS.  In ext4 the same callback functions are used to
set/get user/group quota, although on userspace we use Q_SETQUOTA/
Q_GETQUOTA to set/get quota.  I am not sure I fully understand your
meaning that unifies the quota API between ext4 and XFS.  Do you mean
that we should use Q_XSETQLIM/Q_XGETQUOTA flags to set/get quota on ext4?
Or using quotactl(2) is fine for you.

Please correct me if I miss something.

Thanks,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
