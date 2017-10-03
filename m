Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46289 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750841AbdJCUvx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:51:53 -0400
Date: Tue, 3 Oct 2017 22:51:50 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
In-Reply-To: <nycvar.YFH.7.76.1710032215140.17517@jbgna.fhfr.qr>
Message-ID: <nycvar.YFH.7.76.1710032248470.17517@jbgna.fhfr.qr>
References: <20171003185313.1017-1-mcgrof@kernel.org>  <20171003185313.1017-6-mcgrof@kernel.org> <1507061605.2567.13.camel@wdc.com> <nycvar.YFH.7.76.1710032215140.17517@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jgross@suse.com" <jgross@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>

On Tue, 3 Oct 2017, Jiri Kosina wrote:

> > What about the many drivers outside filesystems that use the 
> > set_freezable() / try_to_freeze() / wait_event_freezable() API?
> 
> Many/most of them are just completely bogus and pointless. 

More specifically -- they don't really care at all whether they get 
scheduled out exactly at the try_to_freeze() point; they are perfectly 
happy being scheduled out at any other scheduling point, and land on 
runqueue after the resume has been completed.

Sure, certain drivers need to take action when system is undergoing 
hibernation/suspend. But that's what PM callbacks are for, not kthread 
hibernation.

-- 
Jiri Kosina
SUSE Labs

