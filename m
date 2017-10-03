Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750961AbdJCUGR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:06:17 -0400
Date: Tue, 3 Oct 2017 22:06:14 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [RFC 2/5] fs: freeze on suspend and thaw on resume
In-Reply-To: <20171003185313.1017-3-mcgrof@kernel.org>
Message-ID: <nycvar.YFH.7.76.1710032203580.17517@jbgna.fhfr.qr>
References: <20171003185313.1017-1-mcgrof@kernel.org> <20171003185313.1017-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 3 Oct 2017, Luis R. Rodriguez wrote:

> This uses the existing filesystem freeze and thaw callbacks to
> freeze each filesystem on suspend/hibernation and thaw upon resume.
> 
> This is needed so that we properly really stop IO in flight without
> races after userspace has been frozen. Without this we rely on
> kthread freezing and its semantics are loose and error prone.
> For instance, even though a kthread may use try_to_freeze() and end
> up being frozen we have no way of being sure that everything that
> has been spawned asynchronously from it (such as timers) have also
> been stopped as well.
> 
> A long term advantage of also adding filesystem freeze / thawing
> supporting durign suspend / hibernation is that long term we may
> be able to eventually drop the kernel's thread freezing completely
> as it was originally added to stop disk IO in flight as we hibernate
> or suspend.
> 
> This also implies that many kthread users exist which have been
> adding freezer semantics onto its kthreads without need. These also
> will need to be reviewed later.
> 
> This is based on prior work originally by Rafael Wysocki and later by
> Jiri Kosina.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Thanks a lot for picking this up; I never found time to actually finalize 
it.

	Acked-by: Jiri Kosina <jkosina@suse.cz>

for patches 2 and 5 (the fs agnostic code), which were in the core of my 
original work.

-- 
Jiri Kosina
SUSE Labs

