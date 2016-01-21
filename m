Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E2817F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 15:58:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8283CAC013
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 13:58:28 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zwq8OUqNa4F3t7e8 for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 13:58:22 -0800 (PST)
Date: Fri, 22 Jan 2016 08:58:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: introduce per-inode DAX enablement
Message-ID: <20160121215820.GA6033@dastard>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-4-git-send-email-david@fromorbit.com>
	<CAA9_cmdAYzf3DpjPRZWikNgmJT_sdDACXa_znz6j0oqmmRdLOA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA9_cmdAYzf3DpjPRZWikNgmJT_sdDACXa_znz6j0oqmmRdLOA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jan 21, 2016 at 08:37:11AM -0800, Dan Williams wrote:
> On Sun, Jan 3, 2016 at 9:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Rather than just being able to turn DAX on and off via a mount
> > option, some applications may only want to enable DAX for certain
> > performance critical files in a filesystem.
> >
> > This patch introduces a new inode flag to enable DAX in the v3 inode
> > di_flags2 field. It adds support for setting and clearing flags in
> > the di_flags2 field via the XFS_IOC_FSSETXATTR ioctl, and sets the
> > S_DAX inode flag appropriately when it is seen.
> >
> > When this flag is set on a directory, it acts as an "inherit flag".
> > That is, inodes created in the directory will automatically inherit
> > the on-disk inode DAX flag, enabling administrators to set up
> > directory heirarchies that automatically use DAX. Setting this flag
> > on an empty root directory will make the entire filesystem use DAX
> > by default.
> 
> When switching from page-cache to DAX, don't we need to flush existing
> page cache mappings and remap directly?  Or, is the thought that
> userspace needs to comprehend the presence of mixed mappings after
> changing S_DAX?

The change should be transparent to userspace. In general, I don't
expect users to change the behaviour of files that are in active use
(why would you do that?). This patch is really just introducing the
flag, the userspace API and making it propagate correctly via the
on-disk format. We'll fix up whatever problems with switching it
on/off dynamically as we go, like we do with most experimental
features once the on-disk behaviour is sorted out.

i.e. I've already got a couple of fixes we need to add to this - the
DAX flag is only valid on CRC enabled filesystems, so we need to
check that in the ioctl (general problem with using di_flags2 field,
not DAX flag specific issue). Adding a code to sync and unmap when
changing the flag is probably also necessary in the ioctl - I don't
have code to do that yet, but I have been thinking about it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
