Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43176 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfFZWXc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jun 2019 18:23:32 -0400
Subject: Re: XFS Repair Error
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
 <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
 <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com>
 <660f9958-b10a-3bf4-6910-87a811b2a7c3@sandeen.net>
 <CAFVd4Nuv9H4AAR9DPDhhdZtKV=QXFiC8AHZz9jb46EibuO568A@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <461eb7ec-d81f-1e2f-882a-95564153afed@sandeen.net>
Date: Wed, 26 Jun 2019 17:23:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAFVd4Nuv9H4AAR9DPDhhdZtKV=QXFiC8AHZz9jb46EibuO568A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rich Otero <rotero@editshare.com>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>, Steve Alves <steve.alves@editshare.com>



On 6/26/19 5:18 PM, Rich Otero wrote:
>> the filesystem seems to be a disaster, probably due to bad disks - xfs_repair can't repair bad hardware, of course.
>>
>> current xfs_repair completes for me without error, after spitting out over 450,000 lines of detected corruption issues.
>>
>> so my suggestions going forward would be:
>>
>> 1) fix storage
>> 2) get newer admin tools for next time
>>
>> I appreciate the report, but not much to do w/ such an old version (and it seems already fixed in any case).
> 
> Since I knew that there were issues with the hardware, that's pretty
> much what I expected to hear. It's good to know that the current
> version could repair this sort of problem. Thanks for the reply.

So to be clear, "repair this sort of problem" almost certainly means
"throw away almost everything until what remains on the filesystem
looks consistent again" ;)

Sorry for beating a dead horse, but really do want to stress that xfs_repair
is not a magical hardware fixer nor a data recovery tool.  When things have
gone very badly beneath the filesystem, xfs_repair is unlikely to make things
better.

-Eric
 
> Regards,
> Rich Otero
> EditShare
> rotero@editshare.com
> 617-782-0479
