Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42134 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfFZWKw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jun 2019 18:10:52 -0400
Subject: Re: XFS Repair Error
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
 <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
 <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <660f9958-b10a-3bf4-6910-87a811b2a7c3@sandeen.net>
Date: Wed, 26 Jun 2019 17:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rich Otero <rotero@editshare.com>, Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>, Steve Alves <steve.alves@editshare.com>

On 6/26/19 4:30 PM, Rich Otero wrote:
>> This applies
>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> kernel version: 3.12.17

~6 years old :(

> xfsprogs version: 3.1.7

8 years old :(  So, bug reports are not really useful here ;)

the filesystem seems to be a disaster, probably due to bad disks - xfs_repair can't repair bad hardware, of course.

current xfs_repair completes for me without error, after spitting out over 450,000 lines of detected corruption issues.

so my suggestions going forward would be:

1) fix storage
2) get newer admin tools for next time

I appreciate the report, but not much to do w/ such an old version (and it seems already fixed in any case).

-Eric
