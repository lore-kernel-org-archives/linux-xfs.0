Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0092.outbound.protection.outlook.com ([104.47.34.92]:26607
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934131AbeFLXar (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 19:30:47 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Re: Bug report: kernel hangs when mounting a crafted xfs image
Date: Tue, 12 Jun 2018 23:30:45 +0000
Message-ID: <86416821-C693-4904-9A6E-E249722E0FA8@gatech.edu>
References: <5B6AC96A-7049-48D7-82A1-4AB42322D38B@gatech.edu>
 <20180612224028.GD10363@dastard>
In-Reply-To: <20180612224028.GD10363@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4AD9C7F7F768784095AF34216E981F4B@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Xu, Wen" <wen.xu@gatech.edu>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hi Dave,

I feel I can get your point a bit. Anyway recently I am fuzzing log section of XFS.
I reported four new bugs to mail list today. 
They are all memory corruption issues, and I think some of them are
enough to be used to perform controlled write and code execution. And I feel these bugs are not complex ones
but exist there that cannot simply be covered by CRC protection? In my humble opinions, CRC protection
mainly hardens the integrity of the metadata instead of eliminating malicious metadata leading to unexpected 
behaviors. I am not very sure considering my limited knowledge on XFS but you can take a look on them and
see the severity of these issues. 

Thanks,
Wen

> On Jun 12, 2018, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Mon, Jun 11, 2018 at 07:36:48PM +0000, Xu, Wen wrote:
>> When mounting a crafted xfs v4 image, the kernel hangs and never returns for mount operation. Suspect potential deadlock in log recovery exists. Not sure it is considered as a bug or not.
>> 
>> - Reproduce (on 4.17 upstream kernel)
>> # mkdir mnt
>> # mount -t xfs 0.img mnt
>> 
>> The image file (0.img.zip) is available here: https://bugzilla.kernel.org/attachment.cgi?id=276475
> 
> So it's a filesystem with a log that has bit corruptions in it's log
> record headers, and log CRCs are turned off. All kernels since late
> 2012 have CRC'd log records for both v4 and v5 filesystems.  Hence
> any remotely recent kernel faced wih bit errors in the journal are
> going to behave differently - corruption warnings will be issued
> first, and while v4 filesystems will continue to try to mount, a v5
> filesystem will refuse to mount. And kernels old enough not to CRC
> log records are unlikely to ever get bug fixes for maliciously
> corrupted log records.
> 
> As such, I'm going to consider this a low priority right now.
> Protecting log recovery against anything more than random bit errors
> is a fairly major undertaking, and not something I plan on doing
> in the near term...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

