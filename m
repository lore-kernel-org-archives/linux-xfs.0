Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35464 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730598AbeGRVGr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Jul 2018 17:06:47 -0400
Subject: Re: filefrag and reflink
References: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
 <20180718195940.GA4813@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <165c936c-7dc4-7336-3d7e-268ec6746b56@sandeen.net>
Date: Wed, 18 Jul 2018 13:27:40 -0700
MIME-Version: 1.0
In-Reply-To: <20180718195940.GA4813@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>



On 7/18/18 12:59 PM, Darrick J. Wong wrote:
> On Wed, Jul 18, 2018 at 12:41:27PM -0600, Chris Murphy wrote:
>> xfsprogs 4.17.0 mkfs with reflink=1
>> kernel 4.17.6
>>
>> $ fallocate -l 1g tmp2
>> $ cp --reflink tmp2 tmp3
>> $ filefrag -v *
>> Filesystem type is: 58465342
>> File size of tmp2 is 1073741824 (262144 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..  130136:         24..    130160: 130137:             unwritten
>>    1:   130137..  260280:     131082..    261225: 130144:     130161: unwritten
>>    2:   260281..  262143:     264714..    266576:   1863:     261226:
>> last,unwritten,eof
>> tmp2: 3 extents found
>> File size of tmp3 is 1073741824 (262144 blocks of 4096 bytes)
>> tmp3: 0 extents found
>> [chris@f28s xfs]$
>>
>>
>> Is this expected? When I do it on Btrfs, I see identical information
>> for the two files after reflink copy, with flags "unwritten,shared".
> 
> Yes.  xfs doesn't share unwritten extents; what would be the point?
> 
> --D

<materializes somewhere on a US western interstate>

Seems a little weird that bare cp will create a written file full of
zeros, while a cp --reflink will create a sparse file, though?

-Eric
