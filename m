Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35516 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965519AbdI0BTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 21:19:39 -0400
Date: Tue, 26 Sep 2017 18:19:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: generic/232 test failures on 4.14-rc1
Message-ID: <20170927011929.GA5010@magnolia>
References: <20170921154846.re5vcyn3bugdbie5@localhost.localdomain>
 <20170925135946.GB8004@quack2.suse.cz>
 <20170926125831.GC13627@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170926125831.GC13627@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

[cc xfs list]

On Tue, Sep 26, 2017 at 02:58:31PM +0200, Jan Kara wrote:
> On Mon 25-09-17 15:59:46, Jan Kara wrote:
> > On Thu 21-09-17 11:48:46, Eric Whitney wrote:
> > > I'm seeing generic/232 fail from time to time when running a 4.14-rc1 kernel
> > > on xfstest-bld's most recent kvm-xfstests test appliance.  In one set of
> > > trials, it failed in the same manner 4 out of 10 times when running the 4k test
> > > configuration for ext4.
> > > 
> > > The failure bisects to "quota: Do not acquire dqio_sem for dquot overwrites in
> > > v2 format" (ab2b86360f6e).  When this patch was reverted in a 4.14-rc1 kernel,
> > > the failure did not reoccur in a series of 20 trials.
> > 
> > Thanks for debugging this! I'd just note that the commit hash of that
> > change is different for me - d2faa415166b2883428efa92f451774ef44373ac.
> > 
> > > Example output from the failed test:
> > > 
> > > QA output created by 232
> > > 
> > > Testing fsstress
> > > 
> > > seed = S
> > > Comparing user usage
> > > 218a219
> > > > #3740     --       4       0       0              1     0     0       
> > > 245a247
> > > > #45       --       0       0       0              1     0     0     
> > > 
> > > Note:  I'm also seeing a similar failure for generic/233, but the patch
> > > containing the root cause likely comes somewhere after ab2b86360f6e.  I'll post
> > > another bug report once I locate it.
> > 
> > I'll try to debug this further. Thanks for report!
> 
> Attached patch fixes the problem for me. I'll merge it through my tree.

Hi Jan,

Ever since 4.14-rc1, I've noticed the same problem (intermittent
failures of generic/{232,233,270}) that Eric Whitney was complaining
about when running xfstests against XFS.  I'll try a proper bisect
tomorrow, but given the big locking rework I wonder if that rings any
bells for you?

--D

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

> From a0ae41c2a9c204374eafd24a928e4352841bd905 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 26 Sep 2017 10:36:05 +0200
> Subject: [PATCH] quota: Fix quota corruption with generic/232 test
> 
> Eric has reported that since commit d2faa415166b "quota: Do not acquire
> dqio_sem for dquot overwrites in v2 format" test generic/232
> occasionally fails due to quota information being incorrect. Indeed that
> commit was too eager to remove dqio_sem completely from the path that
> just overwrites quota structure with updated information. Although that
> is innocent on its own, another process that inserts new quota structure
> to the same block can perform read-modify-write cycle of that block thus
> effectively discarding quota information update if they race in a wrong
> way.
> 
> Fix the problem by acquiring dqio_sem for reading for overwrites of
> quota structure. Note that it *is* possible to completely avoid taking
> dqio_sem in the overwrite path however that will require modifying path
> inserting / deleting quota structures to avoid RMW cycles of the full
> block and for now it is not clear whether it is worth the hassle.
> 
> Fixes: d2faa415166b2883428efa92f451774ef44373ac
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/quota/quota_v2.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
> index c0187cda2c1e..a73e5b34db41 100644
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -328,12 +328,16 @@ static int v2_write_dquot(struct dquot *dquot)
>  	if (!dquot->dq_off) {
>  		alloc = true;
>  		down_write(&dqopt->dqio_sem);
> +	} else {
> +		down_read(&dqopt->dqio_sem);
>  	}
>  	ret = qtree_write_dquot(
>  			sb_dqinfo(dquot->dq_sb, dquot->dq_id.type)->dqi_priv,
>  			dquot);
>  	if (alloc)
>  		up_write(&dqopt->dqio_sem);
> +	else
> +		up_read(&dqopt->dqio_sem);
>  	return ret;
>  }
>  
> -- 
> 2.12.3
> 

