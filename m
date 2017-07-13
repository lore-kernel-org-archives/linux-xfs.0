Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdGMLgw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jul 2017 07:36:52 -0400
Date: Thu, 13 Jul 2017 07:36:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20170713113650.GA38569@bfoster.bfoster>
References: <CACw1Djo4TUtmE5jJj_2zhtL+W5SK=daA5aNyChY4Qyjv40_ckw@mail.gmail.com>
 <20170712111924.GB33764@bfoster.bfoster>
 <CACw1Djrg2nGYDrhfNRhCDyD6JxBiJgLCxWxHqR6-9cy_7f1fAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACw1Djrg2nGYDrhfNRhCDyD6JxBiJgLCxWxHqR6-9cy_7f1fAA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sergey F <sf.softevol@gmail.com>
Cc: linux-xfs@vger.kernel.org

cc linux-xfs. Please keep replies on list.

On Thu, Jul 13, 2017 at 01:48:01AM +0300, Sergey F wrote:
> Hello, Brian.
> 
> Thanks for your response to my issue.
> 
> >Was any more information dumped with the error, such as a
> >stacktrace?
> 
> Unfortunately, we could not login inside our server.
> And i already posted all information from server console, accessible
> through IPMI interface.
> 
> >Either way, it's possible the corruption was latent for some
> >time and only once the broad file removal operation occurred was it
> >discovered.
> 
> Is there any way to defend our servers from errors like that? May be
> you could give link to any inforamation about how to avoid situation
> like that?
> 

Corruption as such is a bug and we don't currently know the root cause
so there is no specific workaround that we know of. The best I could say
is 1.) use backups to protect your data and 2.) if you are concerned
that this may reoccur, introduce routine filesystem checks into your
workflow. For example, unmount/snapshot the volume at appropriate down
time intervals and run 'xfs_repair -n' to check the filesystem health
and hopefully detect corruption before you hit it at runtime.

If you do detect corruption, it is important to collect the metadump
image before attempting further mount/recovery operations.

> >Creating a metadump image prior to recovery
> >is something to consider should you run into this issue again.
> 
> What is the best source to read about this operation I would like to
> be prepared if any similar issues appears one more time.
> 

See 'man xfs_metadump.' It basically clones all of the metadata from the
fs (data is ignored) into an image file that developers can restore
using xfs_mdrestore and use to help diagnose problems. You can run it at
any time to familiarize yourself with the tool, just be sure not to
restore back to your original device as that will destroy your data ;)
(i.e., you can xfs_mdrestore to another file and mount it loopback).

It's usually not easy to root cause corruption after the fact, even with
a metadump image, but it helps provide a starting point at the very
least.

Brian

> Thanks.
> 
> On 12 July 2017 at 14:19, Brian Foster <bfoster@redhat.com> wrote:
> > On Tue, Jul 11, 2017 at 11:25:04PM +0300, Sergey F wrote:
> >> Hello.
> >>
> >> on one from our server we got error
> >>
> >> XFS (dm-0): Internal error XFS_WANT_CORRUPTED_GOTO at line 3156 of
> >> file fs/xfs/libxfs/xfs_btree.c. Caller xfs_free_ag_extent+0x402/0x780
> >> [xfs]
> >
> > Failed to insert a record into a btree.
> >
> >> XFS (dm-0): Internal error xfs_trans_cancel at line 990 of file
> >> fs/xfs/xfs_trans.c. Caller xfs_inactive_truncate+0xe5/0x120 [xfs]
> >>
> >
> > Shutdown due to dirty transaction abort (which is probably expected at
> > this point). Was any more information dumped with the error, such as a
> > stacktrace?
> >
> >> As this error appear on our / partition - we needed to reboot our
> >> server through IPMI interface.
> >> After reboot server enter in emergency mode, where with xfs_repair -L
> >> option filesystem was successfully repaired and server now seems to
> >> works correct.
> >>
> >
> > I take it that log recovery failed as well?
> >
> >> Last action on server was remove huge number of files (as said  person
> >> who execute action - 75,000+ )
> >>
> >
> > Given that, I suppose the error could be due to free space corruption
> > and resulting failure to insert a newly freed record (though I thought
> > we had another, more explicit check for that condition, so this could be
> > wrong). Either way, it's possible the corruption was latent for some
> > time and only once the broad file removal operation occurred was it
> > discovered.
> >
> >> Do you have any ideas what exactly could be the reason for this issue?
> >> how could we investigate this issue?
> >>
> >
> > A metadump of the broken fs would have been nice to at least confirm the
> > type of corruption/problem on-disk, but it sounds like the fs has
> > already been recovered. I'm not sure there is much we can do to further
> > investigate at this point. Creating a metadump image prior to recovery
> > is something to consider should you run into this issue again.
> >
> > Brian
> >
> >> We could find similar information here:
> >> https://www.centos.org/forums/viewtopic.php?t=15898
> >> On this link topicstarter said that he could get information from xfs
> >> maillists, so i think that we could try to work with somebody from
> >> your specialists.
> >>
> >> Server information:
> >> CentOS7
> >> LSIMegaRAIDSAS9240-4i
> >> 2xSeagate ST1000NM0055-1V410C
> >> Linux kernel version:
> >> uname  -a
> >> Linux 3.10.0-514.21.2.el7.x86_64 #1 SMP Tue Jun 20 12:24:47 UTC 2017
> >> x86_64 x86_64 x86_64 GNU/Linux
> >> XFS packages version:
> >> yum list installed | grep xfs
> >> xfsprogs.x86_64 4.5.0-10.el7_3          @updates
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
