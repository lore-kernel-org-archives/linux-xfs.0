Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750812AbdJCU1f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:27:35 -0400
Date: Tue, 3 Oct 2017 22:27:31 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003202731.GG2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <1507061605.2567.13.camel@wdc.com>
 <nycvar.YFH.7.76.1710032215140.17517@jbgna.fhfr.qr>
 <1507062101.2567.16.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507062101.2567.16.camel@wdc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jikos@kernel.org" <jikos@kernel.org>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

On Tue, Oct 03, 2017 at 08:21:42PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-03 at 22:17 +0200, Jiri Kosina wrote:
> > On Tue, 3 Oct 2017, Bart Van Assche wrote:
> > > What about the many drivers outside filesystems that use the 
> > > set_freezable() / try_to_freeze() / wait_event_freezable() API?
> > 
> > Many/most of them are just completely bogus and pointless. I've killed a 
> > lot of those in the past, but the copy/paste programming is just too 
> > strong enemy to fight against.
> 
> If just a single driver would use that API to prevent that I/O occurs while
> processes are frozen then this patch will break that driver.

Yes! And although as Jiri points out, its debatable where this is being used,
but as you suggest there may be *valid* reasons for it *now* even though
originally it *may* have been bogus...

Its why I believe this now can only be done piecemeal wise, slowly but steady.
To avoid regressions, and make this effort bisectable.

  Luis
