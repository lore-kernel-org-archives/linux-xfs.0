Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56032 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfEOQCh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 12:02:37 -0400
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
 <4a47cdc4-4a96-cf78-9e48-83d6cd0fe65f@sandeen.net>
 <CAEFkGAx1A3-XXqWSssa3QQsTZW-8BuVU_D+Dq2sYfKAKs0+t_w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7b246a93-cadf-e510-af95-466b99029c2a@sandeen.net>
Date: Wed, 15 May 2019 11:02:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAEFkGAx1A3-XXqWSssa3QQsTZW-8BuVU_D+Dq2sYfKAKs0+t_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Guerra <jorge.guerra@gmail.com>
Cc: linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

On 5/15/19 10:57 AM, Jorge Guerra wrote:
> Thanks Eric,
> 
> I'm addressing these comments.  Will send an update once we have an
> agreement with Dave into how and where to implement this.

Might want to give Dave's concerns thought before doing too much
editing of this patch, but it's up to you.  :)

(same style comments will apply to any solution, though)

Thanks,
-Eric

> On Tue, May 14, 2019 at 1:02 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 5/14/19 1:50 PM, Jorge Guerra wrote:
>>> +             dbprintf(_("capacity used (bytes): %llu (%.3f %cB)\n"),
>>> +             extstats.logicalused, answer, iec_prefixes[i]);
>>
>> I think I missed this instance of "indent please" and probably others...
>>
>> (I'm kind of wondering about carrying 'used' in bytes, but I suppose we're
>> ok until we really get zettabyte filesytems in the wild) ;)
>>
>> -Eric
> 
> 
> 
