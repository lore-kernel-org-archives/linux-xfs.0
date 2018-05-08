Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47904 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbeEHVOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 17:14:21 -0400
Subject: Re: [PATCH 20/21] xfsprogs: Add parent pointers during protofile
 creation
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-21-git-send-email-allison.henderson@oracle.com>
 <20180508174305.GT11261@magnolia>
 <782721c1-f929-a5a6-ed45-b7f42b3a5c05@sandeen.net>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6bad30c4-7bd0-5f87-8ded-c464d9991c73@oracle.com>
Date: Tue, 8 May 2018 14:14:16 -0700
MIME-Version: 1.0
In-Reply-To: <782721c1-f929-a5a6-ed45-b7f42b3a5c05@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 05/08/2018 01:39 PM, Eric Sandeen wrote:
> 
> 
> On 5/8/18 12:43 PM, Darrick J. Wong wrote:
>> On Mon, May 07, 2018 at 09:41:18PM -0700, Allison Henderson wrote:
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> ---
>>>   mkfs/proto.c         | 59 ++++++++++++++++++++++++++++++++++------------------
>>>   repair/attr_repair.c | 16 ++------------
>>>   repair/phase6.c      | 47 +++++++++++++++++++++++++----------------
> 
>> Separate patches for separate utilities, please.
> 
> Or at least patch per functional change; it's not at all clear to me how protofile
> creation has anything to do with xfs_repair, and there's nothing in the commit
> log to help me figure it out.  :)
> 
> (I think it doesn't have anything to do w/ protofile creation, and the repair
> patches are fixing up orphanage entry creation; the attr_repair changes seem
> like some third thing that I don't grok yet, sorry - removing namecheck() for
> some reason?).
> 
> -Eric

Ok, it took me a minute to remember why I did this too.  We had ended up 
adding a parameter to libxfs_dir_createname to get the offset needed for 
creating the parent pointer in the protofile, and I ended up following 
the compiler errors back around the repair code that uses the same 
function calls as well.

Maybe I should make a separate patch just for the offset like the kernel 
space set does, and then have two smaller patches for the protofile and 
repair code.

Allison

>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=RAhvaxRO4Y3BuEWfKCiKHMUeNpZj53frHeTCh1R64dU&s=KTNiitB11SrpPwMvBXEQzon_G1JLFHAd69coCAKx8_Y&e=
> 
