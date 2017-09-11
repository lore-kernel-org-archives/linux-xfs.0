Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51310 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751038AbdIKGi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 02:38:59 -0400
Date: Mon, 11 Sep 2017 08:38:56 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Testing dm-integrity (WAS: Re: Support for data CRC)
Message-ID: <20170911063855.x25kajaqoxatt6zq@breakpoint.cc>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com>
 <20170822111053.7jypthbydpkn2tj4@breakpoint.cc>
 <CAJCQCtTF2bWgB1++v3XOwaPqpPxc7-0Lv+Qc_3bebb0zMDNszA@mail.gmail.com>
 <20170910194350.v5fzbgrzihpjg2pv@breakpoint.cc>
 <bb924fb0-ba74-1f14-d1ce-ea567c641c54@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bb924fb0-ba74-1f14-d1ce-ea567c641c54@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 2017-09-10 22:06:13 [+0200], Milan Broz wrote:
> There is integritysetup tool (part of cryptsetup package) that automates format and mount of dm-integrity devices.
> For now in devel git, I expect we will do some release package this month.
> (So no need to use dmsetup here.)
ah, good, thank. I read the documentation and it mentioned just those
steps not a pointer to tool.

> > at some point I expected dm-integrity to check the other disk in RAID.
> 
> The dm-integrity has no connection to RAID, it will just return EILSEQ (instead of EIO error)
> to inform that the error is an data integrity error, not a media (or other) IO error.

okay. Now I have a pointer where to look next.

> Milan

Sebastian
