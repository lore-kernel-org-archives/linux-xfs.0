Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752273AbdK2XFi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:05:38 -0500
Date: Thu, 30 Nov 2017 00:05:32 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171129230531.GH16026@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <1862632.MOTT9GD8nq@aspire.rjw.lan>
 <29004244.0jnB6Wc1z6@aspire.rjw.lan>
 <20171004004756.GN2294@wotan.suse.de>
 <1507079033.3075.3.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507079033.3075.3.camel@wdc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

On Wed, Oct 04, 2017 at 01:03:54AM +0000, Bart Van Assche wrote:
> On Wed, 2017-10-04 at 02:47 +0200, Luis R. Rodriguez wrote:
> >   3) Lookup for kthreads which seem to generate IO -- address / review if
> >      removal of the freezer API can be done somehow with a quescing. This
> >      is currently for example being done on SCSI / md.
> >  4) Only after all the above is done should we consider this patch or some
> >     form of it.
> 
> After having given this more thought, I think we should omit these last two
> steps. Modifying the md driver such that it does not submit I/O requests while
> processes are frozen requires either to use the freezer API or to open-code it.
> I think there is general agreement in the kernel community that open-coding a
> single mechanism in multiple drivers is wrong. Does this mean that instead of
> removing the freezer API we should keep it and review all its users instead?

Agreed.

  Luis
