Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42095 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751742AbdJCUPD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:15:03 -0400
Date: Tue, 3 Oct 2017 22:15:00 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
In-Reply-To: <20171003201204.GA23521@amd>
Message-ID: <nycvar.YFH.7.76.1710032213430.17517@jbgna.fhfr.qr>
References: <20171003185313.1017-1-mcgrof@kernel.org> <20171003185313.1017-6-mcgrof@kernel.org> <20171003201204.GA23521@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 3 Oct 2017, Pavel Machek wrote:

> Can knfsd be a problem?

It'd actually be useful to walk through all the 'try_to_freeze()' 
instances in kthreads, and analyze those. I've started this effort, and as 
a result I removed most of them; but there are still quite a few 
remaining. And knfsd is one of those.

> Can memory management doing background writes be a problem?

This point I don't understand. What exactly do you mean?

-- 
Jiri Kosina
SUSE Labs

