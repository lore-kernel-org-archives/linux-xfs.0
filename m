Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753333AbdLFI2N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 03:28:13 -0500
Date: Wed, 6 Dec 2017 16:28:10 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v7] generic: initial fiemap range query test
Message-ID: <20171206082810.GS2749@eguan.usersys.redhat.com>
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
 <20171205082406.GK2749@eguan.usersys.redhat.com>
 <20171205165127.GD19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171205165127.GD19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Tue, Dec 05, 2017 at 08:51:27AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 05, 2017 at 04:24:06PM +0800, Eryu Guan wrote:
> > On Thu, Nov 30, 2017 at 06:05:27PM +0200, Nikolay Borisov wrote:
> > > Fiemap gained support for passing in optional offset len
> > > which denote the range requested, so this patch adds
> > > testcases for this functionality. Aditionally, a special "ranged"
> > > argument is added to the require_xfs_io_command which checks
> > > for the presence of fiemap range support.
> > > 
> > > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > > ---
> > > 
> > > For the time being this test is expected to fail on XFS. 
> > > 
> > > V7: 
> > >  * Adjusted for 64k block size filesystem
> > >  * Only use/require a test device and not a scratch device
> > 
> > v7 looks good to me, test passes on ppc64 hosts too, thanks!
> > 
> > But it seems that it's not decided yet whether xfs should trim the
> > ranged fiemap query request, I'd like to see the expected behavior
> > decided first. (BTW, v7 passes with latest RHEL7 kernel too, seems
> > extents are not trimmed there.)
> 
> The iomap callers need to tell iomap_apply if they want exactly the
> range they asked for and no more (most of the write paths) or if they
> can handle outside ranges (fiemap), and then we can turn on
> XFS_BMAPI_ENTIRE reporting in xfs_iomap_begin.

That means.. I can merge the test as-is?

Thanks,
Eryu
