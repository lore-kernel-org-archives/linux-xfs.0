Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40416 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbeIRVA0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 17:00:26 -0400
Subject: Re: dm-writecache issue
From: Eric Sandeen <sandeen@sandeen.net>
References: <20180911221147.GA23308@redhat.com>
 <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918123238.GI27618@dastard>
 <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
 <alpine.LRH.2.02.1809180934040.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <8975ad6d-bfde-0a50-e60c-59228493f1b2@sandeen.net>
 <d2d949ec-b3b6-cba3-66f8-c225784d5951@sandeen.net>
 <alpine.LRH.2.02.1809181024150.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <b359bcc7-bc76-33cc-30fb-2c8ad2ba4682@sandeen.net>
 <alpine.LRH.2.02.1809181038350.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <b3a162a8-7c2b-8a66-6f11-2abff3381690@sandeen.net>
Message-ID: <128a77fc-dbcb-278f-115c-da4a3d63e58f@sandeen.net>
Date: Tue, 18 Sep 2018 10:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <b3a162a8-7c2b-8a66-6f11-2abff3381690@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>

On 9/18/18 10:04 AM, Eric Sandeen wrote:
> I cannot help but believe that ext4 occasionally
> gets harmed by this choice, because it's absolutely possible that a 4k
> metadata write gets only partly-persisted if power fails on a 512/512 disk,
> for example.  In practice it seems to generally work out ok, but it is going
> beyond what the device says it can guarantee.

(this may be a bit uninformed on my part, Darrick reminds me that jbd2's
careful use of cache flushing & FUA probably means that it won't get burned
by a partial 4k metadata update if the power fails.)

I'll stop for now and see if Dave wants to chime in on xfs's reliance on
the actual atomic IO size for metadata IO.  ;)

Thanks,
-Eric 
