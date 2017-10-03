Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46097 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751477AbdJCUtp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:49:45 -0400
Date: Tue, 3 Oct 2017 22:49:40 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003204940.GA5659@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <20171003201204.GA23521@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003201204.GA23521@amd>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 10:12:04PM +0200, Pavel Machek wrote:
> On Tue 2017-10-03 11:53:13, Luis R. Rodriguez wrote:
> > Now that all filesystems which used to rely on kthread
> > freezing have been converted to filesystem freeze/thawing
> > we can remove the kernel kthread freezer.
> 
> Are you surely-sure? You mentioned other in kernel sources of writes;
> what about those?

You perhaps did not read the cover letter, it describes this patch will very
likely take time to *ever* apply. We must cover tons of grounds first, to
address precisely what you say.

In fact other than kthreads that generate IO we may have now even crazy stupid
kthreads using the freezer API which *do not generate IO* which are totally
bogus but now acts as "features". We'll need to carefully carve out all freezer 
API uses on all kthreads. This should be done atomically to avoid regressions
and ensure bisectability.

  Luis
