Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 08:38:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PFcoOU005647
	for <linux-xfs@oss.sgi.com>; Sun, 25 May 2008 08:38:50 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 597F41AFC7A
	for <linux-xfs@oss.sgi.com>; Sun, 25 May 2008 08:39:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id JCPF4pyFnMz5XiHL for <linux-xfs@oss.sgi.com>; Sun, 25 May 2008 08:39:40 -0700 (PDT)
Message-ID: <48398839.6060304@sandeen.net>
Date: Sun, 25 May 2008 10:39:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS for lots of small files
References: <4820832B.3070903@dubielvitrum.pl> <200805062055.36755.Martin@lichtvoll.de> <4838DC1A.5010206@sandeen.net> (sfid-20080525_131427_063047_18AAAB7D) <200805251338.48910.Martin@lichtvoll.de>
In-Reply-To: <200805251338.48910.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:
> Am Sonntag 25 Mai 2008 schrieb Eric Sandeen:
>> Martin Steigerwald wrote:
>>> And there is quite some fragmentation on it:
>>>
>>> xfs_db> frag
>>> actual 653519, ideal 587066, fragmentation factor 10.17%
>> No, there's not.
> 
> OK, so there is or better was (see below) *some* fragmentation.
> 
>> You have 653519 extents out of an "ideal" 587066.
>>
>> That is 653519/587066 = 1.113 extents per file.
>>
>> It is not "quite some" fragmentation, it is near perfect (although this
>> is subjective, and also depends on the size of your files... if they
>> are all 8k then 1.113 extents per file might be a bit high; if they
>> average 1G then 1.113 extents on average is pretty darned good.)
> 
> They vary a lot. From KMail ~/Mail directory with hundred of thousands of 
> mails in maildir format to a picture and movie collection from various 
> digicams with 150KB over 2-4 MB to 50-200 MB in size and a music 
> collection and kernel sources and and and... would need to run a tool on 
> them to gather some statistic.
> 
> Anyway, nothing that can't be optimized:

Sure... I'd just argue that it's diminishing returns :)

> shambala> xfs_db -r /dev/sda5
> xfs_db> frag
> actual 683648, ideal 617593, fragmentation factor 9.66%
> xfs_db> quit
> 
> shambala> xfs_fsr /dev/sda5
> /home start inode=0
> 
> shambala> xfs_db -r /dev/sda5
> xfs_db> frag
> actual 620316, ideal 617584, fragmentation factor 0.44%
> xfs_db> quit
> 
> xfs_fsr copied over several gigabytes and the free space of the partition 
> temporarily more than once was 4 GB less than the 20 GB of free space it 
> had before and after invoking xfs_fsr ;)

fsr needs to preallocate space to "defragment into" so this is expected,
temporarily.

> Not that I noticed a difference up to now however.

right, my original reply was meant to imply that fragmentation is not
really a problem for you.  :)

And in the larger picture, I just wanted to point out that the
"fragmentation factor" can be pretty misleading.  It reports as (actual
- ideal) / actual.

Imagine a filesystem full of 8GB dvd iso images, each with 4 2GB
extents.  The fragmentation factor would be reported as (4X - 1X) / 4X =
75%.  Which looks "bad," but really isn't.

-Eric
