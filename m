Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55798 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750965AbdLAFAU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 00:00:20 -0500
Subject: Re: [PATCH 5/5] man: describe the metadata scrubbing ioctl
From: Eric Sandeen <sandeen@sandeen.net>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094863117.27182.9043322726761011548.stgit@magnolia>
 <2ba89a66-4426-8462-4b9b-59121b8101f6@sandeen.net>
Message-ID: <a9514761-4885-30c0-a2fa-0e4d1ee857af@sandeen.net>
Date: Thu, 30 Nov 2017 23:00:19 -0600
MIME-Version: 1.0
In-Reply-To: <2ba89a66-4426-8462-4b9b-59121b8101f6@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 11/30/17 10:34 PM, Eric Sandeen wrote:
> On 11/17/17 1:57 PM, Darrick J. Wong wrote:

...

>> +.B sm_ino
>> +and
>> +.BR sm_gen "; "
>> +if not specified, then the file described by
>> +.B dest_fd
>> +will be examined.
>> +
>> +.PP
>> +.nf
>> +.B XFS_SCRUB_TYPE_BMBTD
>> +.B XFS_SCRUB_TYPE_BMBTA
>> +.fi
>> +.TP
>> +.B XFS_SCRUB_TYPE_BMBTC
> 
> why are these set apart with .nf/.fi?


oops nvm on this, I see what this is for.

-Eric
