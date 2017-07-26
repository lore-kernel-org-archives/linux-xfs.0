Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751013AbdGZKnr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jul 2017 06:43:47 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D83C7EA8B
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2017 10:43:47 +0000 (UTC)
Date: Wed, 26 Jul 2017 18:43:45 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [BUG] xfs/305 hangs 4.10-rc4 kernel
Message-ID: <20170726104345.GZ9167@eguan.usersys.redhat.com>
References: <20170126032950.GM1859@eguan.usersys.redhat.com>
 <20170126184427.GA39683@bfoster.bfoster>
 <20170127025219.GR1859@eguan.usersys.redhat.com>
 <20170130181224.GC8737@bfoster.bfoster>
 <20170130215952.GA11230@bfoster.bfoster>
 <20170204114700.GH1859@eguan.usersys.redhat.com>
 <20170206175908.GI57865@bfoster.bfoster>
 <20170213164307.GA25568@bfoster.bfoster>
 <20170726050952.GT9167@eguan.usersys.redhat.com>
 <20170726103502.GA59833@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170726103502.GA59833@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2017 at 06:35:03AM -0400, Brian Foster wrote:
> On Wed, Jul 26, 2017 at 01:09:52PM +0800, Eryu Guan wrote:
> > Hi Brian,
> > 
> > [sorry for bringing up an old thread, but this seems relavent]
> > 
[snip]
> > 
> > Is xfs/305 supposed to pass with 4.13-rc2 kernel now? I know there're
> > some quota patches went in XFS recently, but I'm not sure if there's any
> > known leftover bug.
> > 
> > Anyway, I hit a test hang with 4.13-rc2 kernel with xfs/305 again, test
> > configuration is rmapbt XFS with 4k block size on ppc64le host. But I
> > haven't tried to reproduce it yet. Just want to confirm with you first.
> > 
> 
> I believe it is still possible for quotaoff to deadlock the log. It is
> not shown below, but I assume you have a blocked xfs_quota process
> attempting to run a quotaoff..? How big is your fs/log?

I'm not sure if there's a quotaoff blocked too, that's all I have for
now, this was an automated test job and it didn't print any sysrq-w
output as expected. The fs is 15G but I don't know much about the log,
the host host was returned to the test pool..

> 
> I sent a patch a while ago, but it wasn't safe because it could
> potentially lead to nested transactions in the quotaoff context. We
> don't have a proper fix for this as of yet.

Ok, thanks! At least this isn't something totally surprising people,
I'll see if I can hit it again in future test runs.

Thanks,
Eryu
