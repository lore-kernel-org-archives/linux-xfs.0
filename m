Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbdIAHpk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 03:45:40 -0400
Date: Fri, 1 Sep 2017 15:45:38 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 00/14] Crash consistency xfstest using dm-log-writes
Message-ID: <20170901074538.GS27835@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxh8av5H87SHdFw92BDTvCtYgd9chS2Nfv5fA4=upoqRfA@mail.gmail.com>
 <20170830152326.vil3fhsrecp2ccql@destiny>
 <CAOQ4uxjE20+vY4OPWM3Z=FU-+4oC1KrYtJ5e7-rQDW4xx5t4RA@mail.gmail.com>
 <20170831033818.GH27835@eguan.usersys.redhat.com>
 <CAOQ4uxiYqo9w7Qf_CmaViUiVicPgQ_hr==r5waLTC-wrdTSbMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiYqo9w7Qf_CmaViUiVicPgQ_hr==r5waLTC-wrdTSbMg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Sep 01, 2017 at 10:29:38AM +0300, Amir Goldstein wrote:
> On Thu, Aug 31, 2017 at 6:38 AM, Eryu Guan <eguan@redhat.com> wrote:
> ...
> > The first 6 patches are all prepare work and seem fine, so I probably
> > will push them out this week. But I may need more time to look into all
> > these log-writes dm target and fsx changes.
> >
> > But seems that there're still problems not sorted out (e.g. this
> > log-write bug), I'd prefer, when they get merged, removing the auto
> > group for now until things settle down a bit.
> >
> 
> I don't object to removing the auto group, but keep in mind that this test
> is opt-in anyway, because it requires to define LOGWRITES_DEV

That's a good point.

> (well it SHOULD require, I actually forgot to check it...)
> 
> For now, it seems that the problem observed with kvm-xfstests
> is specific to kvm-qemu aio=threads config, so you shouldn't have any
> problems trying out the test on non kvm setup.

Thanks for the heads-up! I'll run this test and look into the code
closely and see what's the best option.

Thanks,
Eryu
