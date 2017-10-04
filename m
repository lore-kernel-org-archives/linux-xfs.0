Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:3519 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751156AbdJDHSJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 03:18:09 -0400
Date: Wed, 4 Oct 2017 18:18:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171004071803.GF3666@dastard>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <1862632.MOTT9GD8nq@aspire.rjw.lan>
 <29004244.0jnB6Wc1z6@aspire.rjw.lan>
 <20171004004756.GN2294@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004004756.GN2294@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 02:47:56AM +0200, Luis R. Rodriguez wrote:
> On Tue, Oct 03, 2017 at 11:15:07PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, October 3, 2017 8:59:00 PM CEST Rafael J. Wysocki wrote:
> > > On Tuesday, October 3, 2017 8:53:13 PM CEST Luis R. Rodriguez wrote:
> > > > Now that all filesystems which used to rely on kthread
> > > > freezing have been converted to filesystem freeze/thawing
> > > > we can remove the kernel kthread freezer.
> > > > 
> > > > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > > 
> > > I like this one. :-)
> > 
> > However, suspend_freeze/thaw_processes() require some more work.
> > 
> > In particular, the freezing of workqueues is being removed here
> > without a replacement.
> 
> Hrm, where do you see that? freeze_workqueues_busy() is still called on
> try_to_freeze_tasks(). Likewise thaw_processes() also calls thaw_workqueues().
> I did forget to nuke pm_nosig_freezing though.

static int try_to_freeze_tasks(bool user_only)
{
.....
        if (!user_only)
		freeze_workqueues_begin();
.....
                if (!user_only) {
			wq_busy = freeze_workqueues_busy();
.....
}

i.e. only try_to_freeze_tasks(false) will freeze workqueues, and the
only function that calls that - freeze_kernel_threads() - is removed
by this patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
