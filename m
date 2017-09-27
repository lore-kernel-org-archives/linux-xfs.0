Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752016AbdI0JmG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Sep 2017 05:42:06 -0400
Date: Wed, 27 Sep 2017 11:33:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: generic/232 test failures on 4.14-rc1
Message-ID: <20170927093315.GA25746@quack2.suse.cz>
References: <20170921154846.re5vcyn3bugdbie5@localhost.localdomain>
 <20170925135946.GB8004@quack2.suse.cz>
 <20170926125831.GC13627@quack2.suse.cz>
 <20170927011929.GA5010@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170927011929.GA5010@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

Hi Darrick!

On Tue 26-09-17 18:19:29, Darrick J. Wong wrote:
> On Tue, Sep 26, 2017 at 02:58:31PM +0200, Jan Kara wrote:
> > On Mon 25-09-17 15:59:46, Jan Kara wrote:
> > > On Thu 21-09-17 11:48:46, Eric Whitney wrote:
> > > > I'm seeing generic/232 fail from time to time when running a 4.14-rc1 kernel
> > > > on xfstest-bld's most recent kvm-xfstests test appliance.  In one set of
> > > > trials, it failed in the same manner 4 out of 10 times when running the 4k test
> > > > configuration for ext4.
> > > > 
> > > > The failure bisects to "quota: Do not acquire dqio_sem for dquot overwrites in
> > > > v2 format" (ab2b86360f6e).  When this patch was reverted in a 4.14-rc1 kernel,
> > > > the failure did not reoccur in a series of 20 trials.
> > > 
> > > Thanks for debugging this! I'd just note that the commit hash of that
> > > change is different for me - d2faa415166b2883428efa92f451774ef44373ac.
> > > 
> > > > Example output from the failed test:
> > > > 
> > > > QA output created by 232
> > > > 
> > > > Testing fsstress
> > > > 
> > > > seed = S
> > > > Comparing user usage
> > > > 218a219
> > > > > #3740     --       4       0       0              1     0     0       
> > > > 245a247
> > > > > #45       --       0       0       0              1     0     0     
> > > > 
> > > > Note:  I'm also seeing a similar failure for generic/233, but the patch
> > > > containing the root cause likely comes somewhere after ab2b86360f6e.  I'll post
> > > > another bug report once I locate it.
> > > 
> > > I'll try to debug this further. Thanks for report!
> > 
> > Attached patch fixes the problem for me. I'll merge it through my tree.
> 
> Ever since 4.14-rc1, I've noticed the same problem (intermittent
> failures of generic/{232,233,270}) that Eric Whitney was complaining
> about when running xfstests against XFS.  I'll try a proper bisect
> tomorrow, but given the big locking rework I wonder if that rings any
> bells for you?

Hum, no idea. XFS uses its own thing for quotas so my changes don't
influence it at all. I don't know much about XFS internal quota
implementation so I don't have a good guess what could have caused the
breakage you see. I'm sorry.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
