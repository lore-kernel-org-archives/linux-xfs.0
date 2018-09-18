Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbeIRUPR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 16:15:17 -0400
Date: Tue, 18 Sep 2018 10:42:21 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-writecache issue
In-Reply-To: <b359bcc7-bc76-33cc-30fb-2c8ad2ba4682@sandeen.net>
Message-ID: <alpine.LRH.2.02.1809181038350.28565@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180911221147.GA23308@redhat.com> <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com> <20180918123238.GI27618@dastard> <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net> <alpine.LRH.2.02.1809180934040.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <8975ad6d-bfde-0a50-e60c-59228493f1b2@sandeen.net> <d2d949ec-b3b6-cba3-66f8-c225784d5951@sandeen.net> <alpine.LRH.2.02.1809181024150.28565@file01.intranet.prod.int.rdu2.redhat.com> <b359bcc7-bc76-33cc-30fb-2c8ad2ba4682@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>



On Tue, 18 Sep 2018, Eric Sandeen wrote:

> On 9/18/18 9:29 AM, Mikulas Patocka wrote:
> 
> > On Tue, 18 Sep 2018, Eric Sandeen wrote:
> 
> ...
> 
> >> See also 
> >> https://www.intel.com/content/www/us/en/support/articles/000006392/memory-and-storage.html
> >>
> >> -Eric
> > 
> > And does it really support native 512-byte writes? Or does it emulate 
> > 512-byte writes by doing read-modify-write? That needs to be benchmarked, 
> > the paper doesn't say that.
> 
> Interesting from a manual tuning perspective, but not from a default
> behavior perspective.
> 
> I'm just pointing out that Intel does seem to give the user a choice about
> the /advertised/ geometry for some of their SSDs.
> 
> > Memory is expensive and reducing SSD sector size increases memory 
> > requirement on the SSD. I doubt that any SSD vendor would want to use 
> > 8-times more memory just to support 512-byte sectors natively.
> 
> Marketing decisions aside, we just can't safely ignore what the device
> tells us about these IO sizes.

No one is forcing you to use 512-byte writes. You can use 4k writes on a 
device that advertises 512-byte sectors.

ext4 uses 4k block size by default (and lets the user lower it if the user 
is tight on disk space and doesn't care about performance).

Mikulas
