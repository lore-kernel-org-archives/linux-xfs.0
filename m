Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:53342 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbeARV7H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 16:59:07 -0500
Date: Thu, 18 Jan 2018 13:59:05 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: xfs_repair: couldn't map inode 2089979520, err = 117
In-Reply-To: <20180118183636.GB56446@bfoster.bfoster>
Message-ID: <alpine.DEB.2.21.9.1801181351550.14759@trent.utfs.org>
References: <alpine.DEB.2.21.9.1801172204210.14759@trent.utfs.org> <20180118183636.GB56446@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, 18 Jan 2018, Brian Foster wrote:
> Christian, for the time being I suppose you could try a slightly older
> xfs_repair and see if that gets you anywhere. v4.10 or so appears to not
> include the associated commits.

OK, I've compiled v4.10.0 from source and gave it a try - and it 
succeeded: http://nerdbynature.de/bits/4.14/xfs/xfs_6.log 

This time it was able to complete phase 6 and 7 and moved 4.3 GB to 
lost+found (not bad for a 3.7 TB file system :)) 

I tried again with xfs_repair -n v4.12, but didn't dare running it w/o -n 
just yet: http://nerdbynature.de/bits/4.14/xfs/xfs_7.log

Thanks for your help here! If there are patches to try, let me know...

Christian.
-- 
BOFH excuse #66:

bit bucket overflow
