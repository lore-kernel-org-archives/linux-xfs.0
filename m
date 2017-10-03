Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751194AbdJCUYx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:24:53 -0400
Date: Tue, 3 Oct 2017 22:24:51 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
In-Reply-To: <1507062101.2567.16.camel@wdc.com>
Message-ID: <nycvar.YFH.7.76.1710032223170.17517@jbgna.fhfr.qr>
References: <20171003185313.1017-1-mcgrof@kernel.org>  <20171003185313.1017-6-mcgrof@kernel.org>  <1507061605.2567.13.camel@wdc.com>  <nycvar.YFH.7.76.1710032215140.17517@jbgna.fhfr.qr> <1507062101.2567.16.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

On Tue, 3 Oct 2017, Bart Van Assche wrote:

> If just a single driver would use that API to prevent that I/O occurs while
> processes are frozen then this patch will break that driver. I would like to
> know your opinion about the following patch in particular: "[PATCH v4 1/7] md:
> Make md resync and reshape threads freezable"
> (https://www.spinics.net/lists/linux-block/msg17854.html).

Alright, if there are kthreads which are actually *creating* new I/O 
(contrary to kthreads being I/O completion helpers) -- which apparently is 
the md case here, then those definitely have to be frozen in some form.

-- 
Jiri Kosina
SUSE Labs

