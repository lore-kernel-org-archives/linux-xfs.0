Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45022 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbeKMByA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Nov 2018 20:54:00 -0500
Subject: Re: [PATCH] Fix coding style issue in xfs_acl.c and xfs_aops.c
References: <20181111003603.7598-1-weizhefix@gmail.com>
 <20181111233305.GL19305@dastard>
 <9b618d0aa0e7c0db78e3dcaf4d3ffe2e22b92a12.camel@perches.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <73874f7f-73be-9be7-df29-d53388520764@sandeen.net>
Date: Mon, 12 Nov 2018 10:00:07 -0600
MIME-Version: 1.0
In-Reply-To: <9b618d0aa0e7c0db78e3dcaf4d3ffe2e22b92a12.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>, hmsjwzb <weizhefix@gmail.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kerticrnel@vger.kernel.org



On 11/11/18 9:04 PM, Joe Perches wrote:
> On Mon, 2018-11-12 at 10:33 +1100, Dave Chinner wrote:
>> On Sun, Nov 11, 2018 at 08:36:03AM +0800, hmsjwzb wrote:
>>> Possible unwrapped commit description (prefer a maximum 75 chars per line)
>>
>> NACK. Our preference is (and always has been) for comments to fill
>> the entire 80 columns, just like the rest of the kernel. I have no
>> idea who told you "75 columns is preferred" but they are wrong.
> 
> 75 column is the preferred commit description length
> as the general 'git log' style is indented a few chars.
> 
> This particular commit description is odd because the
> comments in the code is being wrapped, not the commit
> description.
> 
> Wei Zhe, can you please resubmit this with a better
> commit description?  Something like:
> 
> 	Wrap comments to 80 columns where appropriate.

Please do not resubmit it at all.  None of the comments in the
original patch are > 80 cols in the first place, there is no need
for any change here.

-Eric
