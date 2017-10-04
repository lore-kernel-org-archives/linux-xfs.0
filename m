Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750797AbdJDGHX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Oct 2017 02:07:23 -0400
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <3eb4e33b-6e6b-e71b-c3db-49f98591f9c6@suse.de>
Date: Wed, 4 Oct 2017 08:07:19 +0200
MIME-Version: 1.0
In-Reply-To: <20171003185313.1017-6-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/03/2017 08:53 PM, Luis R. Rodriguez wrote:
> Now that all filesystems which used to rely on kthread
> freezing have been converted to filesystem freeze/thawing
> we can remove the kernel kthread freezer.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  Documentation/power/freezing-of-tasks.txt |  9 ------
>  drivers/xen/manage.c                      |  6 ----
>  include/linux/freezer.h                   |  4 ---
>  kernel/power/hibernate.c                  | 10 ++-----
>  kernel/power/power.h                      | 20 +------------
>  kernel/power/process.c                    | 47 -------------------------------
>  kernel/power/user.c                       |  9 ------
>  tools/power/pm-graph/analyze_suspend.py   |  1 -
>  8 files changed, 3 insertions(+), 103 deletions(-)
> 
Weelll ... have you checked MD?
It's using kernel threads, which probably should be stopped, too, when
going into suspend. After all, MD might be doing on of it's internal
operations (eg resync) at that time, which will generate quite some I/O.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
