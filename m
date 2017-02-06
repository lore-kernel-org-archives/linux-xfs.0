Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdBFR7K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 12:59:10 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9038980F7D
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2017 17:59:10 +0000 (UTC)
Date: Mon, 6 Feb 2017 12:59:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] xfs/305 hangs 4.10-rc4 kernel
Message-ID: <20170206175908.GI57865@bfoster.bfoster>
References: <20170125063943.GF1859@eguan.usersys.redhat.com>
 <20170125145215.GC28388@bfoster.bfoster>
 <20170126032950.GM1859@eguan.usersys.redhat.com>
 <20170126184427.GA39683@bfoster.bfoster>
 <20170127025219.GR1859@eguan.usersys.redhat.com>
 <20170130181224.GC8737@bfoster.bfoster>
 <20170130215952.GA11230@bfoster.bfoster>
 <20170204114700.GH1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170204114700.GH1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 04, 2017 at 07:47:00PM +0800, Eryu Guan wrote:
> On Mon, Jan 30, 2017 at 04:59:52PM -0500, Brian Foster wrote:
> > 
> > I reproduced an xfs_wait_buftarg() unmount hang once that looks like a
> > separate issue (occurs after the test, long after quotaoff has
> > completed). I haven't reproduced that one again nor the original hang in
> > 100+ iterations so far. Care to give the following a whirl in your
> > environment? Thanks.
> 
> I applied your test patch on top of 4.10-rc4 stock kernel and hit
> xfs/305 hang at 82nd iteration. I attached the dmesg and sysrq-w log.
> You can login the same RH internal test host if that's helpful, I left
> the host running in the hang state.
> 

Ok, that's not too surprising. It does look like we are in some kind of
live lock situation. xfs_quota is spinning on the dqpurge and two or
three fsstress workers are spinning on xfs_iget() retries via bulkstat.

I'm going to hard reboot this box and try to restart this test with some
customized tracepoints to try and get more data..

Brian

> Thanks,
> Eryu


