Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 18:41:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m921fIh3030657
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 18:41:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9D744A2ED5
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 18:42:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 1LHU2xoXfCqX03Ir for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 18:42:55 -0700 (PDT)
Message-ID: <48E4271D.1090203@sandeen.net>
Date: Wed, 01 Oct 2008 20:42:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed>
In-Reply-To: <20081002004556.GB30001@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

Dave Chinner wrote:
> Adding xfs@oss.sgi.com to the cc list so all the XFS folk see this.
> 
> On Wed, Oct 01, 2008 at 10:38:22PM +0200, Tobias Frost wrote:
>> (Note: Please CC me, as I am NOT on the lkml!!)
>>
>> Some time ago, I discovered some problems with xfs. Unfortunatly, I had
>> no time diving into it. However, some weeks ago some other people
>> running debian on ARM machines confirmed the problem on their machines
>> starting at [1], so I think it is appropitate to at least report it.  
>> It has also been seen on 2.6.27-rc4  [2].
>>
>> summary: the xfs partition corrupts almost immediatly after creation. I
>> had the impression, that the first unlink (rm) causes the corruption,
>> but this might be just an impression.
>>
>> During the tests I made, I conserved a image of the corrupted filesystem
>> which I can make available on request (it's 26 Mbyte, gzipped).
>>
>> Please let me know how I can assist you in finding the problem. 
>>
>>
>> [1] http://lists.debian.org/debian-arm/2008/08/msg00155.html
>> [2] http://lists.debian.org/debian-arm/2008/08/msg00184.html
>>
>> Best regards,
>> Tobias Frost
>> http://blog.coldtobi.de
>>
>> PS: Thank you for your great work!

Ok, actually: first - sorry for the scattershot replies.  I thought
userspace was updated earlier, but:

xfsprogs-2.10.1 (5 September 2008)...
	- Add packed on-disk shortform directory for ARM's old ABI, thanks to
	  Eric Sandeen.

and the original kernel change:

    [XFS] Pack some shortform dir2 structures for the ARM old ABI
    architecture.
...
    Note that userspace needs a similar treatment, and any filesystems which
    were running with the previous rogue "fix" will now see corruption
...

So perhaps as a first easy test, can you please re-test with
xfsprogs-2.10.1 or newer.

Thanks,
-Eric
