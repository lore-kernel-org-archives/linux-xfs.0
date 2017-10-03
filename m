Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50469 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751267AbdJCVSt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 17:18:49 -0400
Date: Tue, 3 Oct 2017 23:18:46 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003211846.GB5659@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <20171003201204.GA23521@amd>
 <nycvar.YFH.7.76.1710032213430.17517@jbgna.fhfr.qr>
 <20171003202121.GB23521@amd>
 <nycvar.YFH.7.76.1710032230450.17517@jbgna.fhfr.qr>
 <20171003205739.GA30569@amd>
 <nycvar.YFH.7.76.1710032258540.17517@jbgna.fhfr.qr>
 <CAKocOOM6M5HbTA24wStNFnOTVR6vHc76h6cXT=OcMV2e3XSy9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOM6M5HbTA24wStNFnOTVR6vHc76h6cXT=OcMV2e3XSy9w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>, mchehab@s-opensource.com, Pavel Machek <pavel@ucw.cz>, "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, Linux PM list <linux-pm@vger.kernel.org>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org, shuahkh@osg.samsung.com

On Tue, Oct 03, 2017 at 03:09:53PM -0600, Shuah Khan wrote:
> On Tue, Oct 3, 2017 at 3:00 PM, Jiri Kosina <jikos@kernel.org> wrote:
> > On Tue, 3 Oct 2017, Pavel Machek wrote:
> >
> >> > Again, I agree that the (rare) kthreads that are actually "creating" new
> >> > I/O have to be somehow frozen and require special care.
> >>
> >> Agreed. Was any effort made to identify those special kernel threads?
> >
> > I don't think there is any other way than just inspecting all the
> > try_to_freeze() instances in the kernel, and understanding what that
> > particular kthread is doing.
> >
> > I've cleaned up most of the low-hanging fruit already, where the
> > try_to_freeze() was obviously completely pointless, but a lot more time
> > needs to be invested into this.
> >
> 
> There are about 36 drivers that call try_to_freeze() and half (18 ) of
> those are media drivers. Maybe it is easier handle sub-system by
> sub-system basis for a review of which one of these usages could be
> removed. cc'ing Mauro and linux-media

Yes :)

I guess no one reads cover letters, but indeed. To be clear, this last
patch should only go in after a few kernels from now all kthreads
are vetted for piece-meal wise.

This patch would be the nail on the kthread freezer coffin. It should
go in last, who knows how many years from now, and if ever.

  Luis
