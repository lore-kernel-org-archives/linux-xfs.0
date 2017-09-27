Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from synagogue.naos.co.nz ([203.171.38.148]:33598 "EHLO
        synagogue.naos.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbdI0Xgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2017 19:36:45 -0400
Subject: Re: Rationale for hardware RAID 10 su, sw values in FAQ
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
 <20170927004302.GB3666@dastard>
 <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
 <20170927043308.GC3666@dastard>
From: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Message-ID: <c7ade829-9385-c517-581b-8dc73def5693@mcneill.gen.nz>
Date: Thu, 28 Sep 2017 12:36:39 +1300
MIME-Version: 1.0
In-Reply-To: <20170927043308.GC3666@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On 27/09/17 17:33, Dave Chinner wrote:
> On Wed, Sep 27, 2017 at 02:56:16PM +1300, Ewen McNeill wrote:
>> As a suggestion the FAQ section [hint at reason for RAID10 sw=N/2]
> 
> This assumes the reader understands exactly how RAID works and how
> the different types of RAID affect IO performance. The FAQ simply
> tries to convey how to get it right without going into the
> complicated reasons for doing it that way.

Fair enough.

However, as a "sysadmin searching for answers" it is.... difficult to 
judge the up-to-date-ness and accuracy of "use these magic values" 
tuning information without some insight into why and thus whether those 
values (a) are still applicable with modern software/hardware or (b) 
applicable in one's own situation.  Particularly so when one has already 
read N different variations on recommendations, all without 
justification, some with conflicting (or confused) advice.

If the FAQ isn't the right place to even hint at the reasons, then it 
would at least be very helpful if the FAQ said "see this $REFERENCE for 
more information" and said $REFERENCE had some more "behind the scenes" 
information.

> https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
> 
> You'll see the section about all this reads: [TODO]
> because nobody (well, me, really) has had the time to write
> everything down that is needed to cover this topic sufficiently...

Perhaps the perfect is the enemy of the good here.  Would it help if I 
were to write up some text covering:

- key storage alignment tuning aims (avoid work amplification, eg RMW; 
avoid hot spots; increase parallelism)

- summary of physical storage technology concerns (4K sectors, seek 
latency, SSD erase blocks)

- summary of considerations for RAID levels (1 - none; 0 - hot spots; 
5/6 RMW, hot spots; 10 - hot spots; stripe size/width)

- summary of storage virtualisation considerations on alignment (eg, LVM)

- high level advice on determining su/sw given the above, and short 
rationale for each formula

- some observations on unit confusion (sunit/su swidth/sw, values 
supplied in 512 byte sectors / kB versus reported in usually 4kB blocks)

I'm obviously not an expert in filesystem layout optimisation.  But I 
have many years sysadmin experience dealing with lots of types of 
storage, and can write a couple of pages of text on the "background" 
bits next time I have a free moment.  The more advanced tunables could 
remain "todo" until there's time for the perfect version...

(No promises when, but "October" seems plausible if this would be useful.)

Ewen
