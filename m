Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbdIKXpG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Sep 2017 19:45:06 -0400
Date: Mon, 11 Sep 2017 19:44:54 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Testing dm-integrity (WAS: Re: Support for data CRC)
In-Reply-To: <20170911063855.x25kajaqoxatt6zq@breakpoint.cc>
Message-ID: <alpine.LRH.2.02.1709111942050.31898@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc> <CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com> <20170822111053.7jypthbydpkn2tj4@breakpoint.cc> <CAJCQCtTF2bWgB1++v3XOwaPqpPxc7-0Lv+Qc_3bebb0zMDNszA@mail.gmail.com>
 <20170910194350.v5fzbgrzihpjg2pv@breakpoint.cc> <bb924fb0-ba74-1f14-d1ce-ea567c641c54@gmail.com> <20170911063855.x25kajaqoxatt6zq@breakpoint.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>



On Mon, 11 Sep 2017, Sebastian Andrzej Siewior wrote:

> On 2017-09-10 22:06:13 [+0200], Milan Broz wrote:
> > There is integritysetup tool (part of cryptsetup package) that automates format and mount of dm-integrity devices.
> > For now in devel git, I expect we will do some release package this month.
> > (So no need to use dmsetup here.)
> ah, good, thank. I read the documentation and it mentioned just those
> steps not a pointer to tool.
> 
> > > at some point I expected dm-integrity to check the other disk in RAID.

If you need to check the other disk in case of error, you need to put 
dm-integrity below the RAID driver - i.e. create two dm-integrity targets 
on two physical disks and put the RAID target above them.

Mikulas

> > The dm-integrity has no connection to RAID, it will just return EILSEQ (instead of EIO error)
> > to inform that the error is an data integrity error, not a media (or other) IO error.
> 
> okay. Now I have a pointer where to look next.
> 
> > Milan
> 
> Sebastian
> 
