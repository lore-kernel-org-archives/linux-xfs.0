Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755234AbdGLLT0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 07:19:26 -0400
Date: Wed, 12 Jul 2017 07:19:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20170712111924.GB33764@bfoster.bfoster>
References: <CACw1Djo4TUtmE5jJj_2zhtL+W5SK=daA5aNyChY4Qyjv40_ckw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACw1Djo4TUtmE5jJj_2zhtL+W5SK=daA5aNyChY4Qyjv40_ckw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sergey F <sf.softevol@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2017 at 11:25:04PM +0300, Sergey F wrote:
> Hello.
> 
> on one from our server we got error
> 
> XFS (dm-0): Internal error XFS_WANT_CORRUPTED_GOTO at line 3156 of
> file fs/xfs/libxfs/xfs_btree.c. Caller xfs_free_ag_extent+0x402/0x780
> [xfs]

Failed to insert a record into a btree.

> XFS (dm-0): Internal error xfs_trans_cancel at line 990 of file
> fs/xfs/xfs_trans.c. Caller xfs_inactive_truncate+0xe5/0x120 [xfs]
> 

Shutdown due to dirty transaction abort (which is probably expected at
this point). Was any more information dumped with the error, such as a
stacktrace?

> As this error appear on our / partition - we needed to reboot our
> server through IPMI interface.
> After reboot server enter in emergency mode, where with xfs_repair -L
> option filesystem was successfully repaired and server now seems to
> works correct.
> 

I take it that log recovery failed as well?

> Last action on server was remove huge number of files (as said  person
> who execute action - 75,000+ )
> 

Given that, I suppose the error could be due to free space corruption
and resulting failure to insert a newly freed record (though I thought
we had another, more explicit check for that condition, so this could be
wrong). Either way, it's possible the corruption was latent for some
time and only once the broad file removal operation occurred was it
discovered.

> Do you have any ideas what exactly could be the reason for this issue?
> how could we investigate this issue?
> 

A metadump of the broken fs would have been nice to at least confirm the
type of corruption/problem on-disk, but it sounds like the fs has
already been recovered. I'm not sure there is much we can do to further
investigate at this point. Creating a metadump image prior to recovery
is something to consider should you run into this issue again.

Brian

> We could find similar information here:
> https://www.centos.org/forums/viewtopic.php?t=15898
> On this link topicstarter said that he could get information from xfs
> maillists, so i think that we could try to work with somebody from
> your specialists.
> 
> Server information:
> CentOS7
> LSIMegaRAIDSAS9240-4i
> 2xSeagate ST1000NM0055-1V410C
> Linux kernel version:
> uname  -a
> Linux 3.10.0-514.21.2.el7.x86_64 #1 SMP Tue Jun 20 12:24:47 UTC 2017
> x86_64 x86_64 x86_64 GNU/Linux
> XFS packages version:
> yum list installed | grep xfs
> xfsprogs.x86_64 4.5.0-10.el7_3          @updates
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
