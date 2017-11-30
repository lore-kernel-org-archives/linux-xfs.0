Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15084 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750890AbdK3Xf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 18:35:59 -0500
Date: Fri, 1 Dec 2017 10:30:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfs: remove not needed freezing calls
Message-ID: <20171130233033.GO5858@dastard>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-8-mcgrof@kernel.org>
 <20171130162155.GB28180@quack2.suse.cz>
 <CAJZ5v0hrEWOMi+C0Cw+ij_P7fwh=d7KVHAKWWTc=C2SSw=2nkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hrEWOMi+C0Cw+ij_P7fwh=d7KVHAKWWTc=C2SSw=2nkA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Jan Kara <jack@suse.cz>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, bart.vanassche@wdc.com, ming.lei@redhat.com, Ted Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jikos@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, linux-fsdevel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Todd Brandt <todd.e.brandt@linux.intel.com>, nborisov@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Oliver Neukum <ONeukum@suse.com>, oleksandr@natalenko.name, Oleg Antonyan <oleg.b.antonyan@gmail.com>, Yu Chen <yu.chen.surf@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Linux PM <linux-pm@vger.kernel.org>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Nov 30, 2017 at 09:32:53PM +0100, Rafael J. Wysocki wrote:
> On Thu, Nov 30, 2017 at 5:21 PM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 29-11-17 15:23:52, Luis R. Rodriguez wrote:
> >> This removes superflous freezer calls as they are no longer needed
> >> as the VFS now performs filesystem freezing/thaw if the filesystem has
> >> support for it.
> >>
> >> The following Coccinelle rule was used as follows:
> >>
> >> spatch --sp-file fs-freeze-cleanup.cocci --in-place fs/$FS/
> >
> > I think your rule misses WQ_FREEZABLE flag for workqueues? That would be
> > also good to get rid of...
> 
> We need that one (or equivalent) for the runtime PM workqueue at least.

I think Jan was talking about all the WQ_FREEZABLE flags in
filesystem workqueues (such as all the XFS wqs) that are no longer
necessary once filesystems are frozen appropriately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
