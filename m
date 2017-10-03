Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48045 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751117AbdJCVIA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 17:08:00 -0400
Date: Tue, 3 Oct 2017 23:07:55 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003210755.GJ2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <20171003210449.GO3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003210449.GO3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 08:04:49AM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 11:53:13AM -0700, Luis R. Rodriguez wrote:
> > Now that all filesystems which used to rely on kthread
> > freezing have been converted to filesystem freeze/thawing
> > we can remove the kernel kthread freezer.
> 
> Really? There's no other subsystem that relies on kernel thread
> and workqueue freezing to function correctly on suspend?

On my cover letter I noted this patch should not be consideredd
until *all* kthreads are vetted. So I agree vehemently with you.
The patch set only addressed 2 filesystem, so two kthreads. Much
other work would be needed before this lat patch could *ever*
be considered.

  Luis
