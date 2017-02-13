Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751679AbdBMQnJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 11:43:09 -0500
Received: from smtp.corp.redhat.com (int-mx16.intmail.prod.int.phx2.redhat.com [10.5.11.28])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 480A981127
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2017 16:43:09 +0000 (UTC)
Date: Mon, 13 Feb 2017 11:43:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] xfs/305 hangs 4.10-rc4 kernel
Message-ID: <20170213164307.GA25568@bfoster.bfoster>
References: <20170125063943.GF1859@eguan.usersys.redhat.com>
 <20170125145215.GC28388@bfoster.bfoster>
 <20170126032950.GM1859@eguan.usersys.redhat.com>
 <20170126184427.GA39683@bfoster.bfoster>
 <20170127025219.GR1859@eguan.usersys.redhat.com>
 <20170130181224.GC8737@bfoster.bfoster>
 <20170130215952.GA11230@bfoster.bfoster>
 <20170204114700.GH1859@eguan.usersys.redhat.com>
 <20170206175908.GI57865@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206175908.GI57865@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 06, 2017 at 12:59:08PM -0500, Brian Foster wrote:
> On Sat, Feb 04, 2017 at 07:47:00PM +0800, Eryu Guan wrote:
> > On Mon, Jan 30, 2017 at 04:59:52PM -0500, Brian Foster wrote:
> > > 
> > > I reproduced an xfs_wait_buftarg() unmount hang once that looks like a
> > > separate issue (occurs after the test, long after quotaoff has
> > > completed). I haven't reproduced that one again nor the original hang in
> > > 100+ iterations so far. Care to give the following a whirl in your
> > > environment? Thanks.
> > 
> > I applied your test patch on top of 4.10-rc4 stock kernel and hit
> > xfs/305 hang at 82nd iteration. I attached the dmesg and sysrq-w log.
> > You can login the same RH internal test host if that's helpful, I left
> > the host running in the hang state.
> > 
> 
> Ok, that's not too surprising. It does look like we are in some kind of
> live lock situation. xfs_quota is spinning on the dqpurge and two or
> three fsstress workers are spinning on xfs_iget() retries via bulkstat.
> 
> I'm going to hard reboot this box and try to restart this test with some
> customized tracepoints to try and get more data..
> 

I managed to get enough data to manufacture the problem locally. It
looks like quotaoff is racy with respect to inode allocation.

The latter can allocate an inode, populate the incore data structures,
etc. and set i_flags to XFS_INEW until the inode is fully populated. If
inode allocation races with quotaoff such that the alloc doesn't yet see
the quota off state and thus grabs a new dquot reference, it's possible
for the subsequent xfs_qm_dqrele_all_inodes() scan from the quota off
path to simply skip the associated inode because of its XFS_INEW state.
The associated ->i_[ugp]dquot is thus never released and the dqpurge
spins indefinitely.

I reproduce this locally by running quotaoff during an artificial delay
in xfs_finish_inode_setup() right before XFS_INEW is cleared. The least
intrusive way I can think of dealing with this is to account XFS_INEW
inodes as "skipped" inodes during the ag walk (for dqrele_all_inodes()
only) and restart the scan until they are completed.

Brian

> Brian
> 
> > Thanks,
> > Eryu
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
