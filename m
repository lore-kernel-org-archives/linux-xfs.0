Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43166 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750865AbdJDAsA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 20:48:00 -0400
Date: Wed, 4 Oct 2017 02:47:56 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171004004756.GN2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <1862632.MOTT9GD8nq@aspire.rjw.lan>
 <29004244.0jnB6Wc1z6@aspire.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29004244.0jnB6Wc1z6@aspire.rjw.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 11:15:07PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, October 3, 2017 8:59:00 PM CEST Rafael J. Wysocki wrote:
> > On Tuesday, October 3, 2017 8:53:13 PM CEST Luis R. Rodriguez wrote:
> > > Now that all filesystems which used to rely on kthread
> > > freezing have been converted to filesystem freeze/thawing
> > > we can remove the kernel kthread freezer.
> > > 
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > 
> > I like this one. :-)
> 
> However, suspend_freeze/thaw_processes() require some more work.
> 
> In particular, the freezing of workqueues is being removed here
> without a replacement.

Hrm, where do you see that? freeze_workqueues_busy() is still called on
try_to_freeze_tasks(). Likewise thaw_processes() also calls thaw_workqueues().
I did forget to nuke pm_nosig_freezing though.

Also as I have noted a few times now we have yet to determine if we can remove
all freezer calls on kthreads without causing a regression. Granted I'm being
overly careful here, I still would not be surprised to learn about a stupid use
case where this will be hard to remove now.

Only once this is done should this patch be considered. This will take time. So
I'd like more general consensus on long term approach:

  1) first address each fs to use its freezer calls on susend/hibernate / and thaw
     on resume. While at it, remove freezer API calls on their respective
     kthreads.
  2) In parallel address removing freezer API calls on non-IO kthreads, these
     should be trivial, but who knows what surprises lurk here
  3) Lookup for kthreads which seem to generate IO -- address / review if
     removal of the freezer API can be done somehow with a quescing. This
     is currently for example being done on SCSI / md.
  4) Only after all the above is done should we consider this patch or some
     form of it.

  Luis
