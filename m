Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31141 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbdKUFwW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 00:52:22 -0500
Date: Tue, 21 Nov 2017 13:52:20 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [ANNOUNCE] xfsprogs: master updated to 5bb4307 / v4.14.0-rc2
Message-ID: <20171121055220.GL2749@eguan.usersys.redhat.com>
References: <eee6bf62-e997-ec85-5e9d-26a23f7ee9f8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eee6bf62-e997-ec85-5e9d-26a23f7ee9f8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 20, 2017 at 02:15:35PM -0600, Eric Sandeen wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated and tagged with v4.14.0-rc2 on the master
> branch.
> 
> (I've also retroactively updated the release files for rc1, and
> this is all now merged to the master branch as well).
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> The new head of the master branch is commit:
> 
> 5bb4307 xfsprogs: Release v4.14.0-rc2
> 
> This is likely the last rc; there is a remote possibility that the
> ranged fiemap patch will get in yet but I'd like to see the tests
> in place for that before merging - so it'll probably slip.

I was kinda waiting for the final expected behaviors to be determined
first :) e.g. truncate data/hole on range boundaries or not, because
your patch and Nikolay's patch are doing it differently, at least in the
"range boundary is in the middle of hole" case.

Thanks,
Eryu
