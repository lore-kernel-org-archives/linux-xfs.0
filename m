Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48852 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752006AbeDHBsz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 7 Apr 2018 21:48:55 -0400
Subject: Re: [PATCH 0/6] xfs: quota fixes and enhancements
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <6479893d-7f01-f262-6ec5-84a33237d2d8@sandeen.net>
 <20180408013757.GN7500@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <91de46d5-c861-655b-1961-bf4073d1c989@sandeen.net>
Date: Sat, 7 Apr 2018 20:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <20180408013757.GN7500@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 4/7/18 8:37 PM, Darrick J. Wong wrote:
> On Sat, Apr 07, 2018 at 05:00:13PM -0500, Eric Sandeen wrote:
>> On 4/4/18 1:47 PM, Eric Sandeen wrote:
>>> A semi-random smattering of quota stuff.  First three seem quite
>>> good to go, the rest are more along the lines of a suggestion
>>> or conversation-starter.  ;)
>>>
>>> (the first patch is just removing an unused arg).
>>>
>>> xfs_repair doesn't look at quota blocks.  At all.  It relies
>>> on quotacheck in the kernel to fix them up as needed.
>>
>> I'm starting to rethink a lot of this hackery.  Why doesn't xfs_repair
>> just fix things up?  (leave quotacheck to the next mount, but the
>> "repair" stuff in the kernel seems like a really strange wart.)
>>
>> I think I'll look at teaching repair to sanity check the quota
>> inodes, but if anyone knows why that's a bad idea please let me
>> know.  ;)
> 
> /me shrugs, we still need to fix the kernel's quota verifiers to check
> the uuid and all that, right?  Which means that both are going to need
> patches, afaict.

The verifiers do check UUID:

xfs_dquot_buf_read_verify
	xfs_dquot_buf_verify_crc
                if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
                        return false;

the issue is that neither the kernel nor userspace repairs this error
if it's detected.

-Eric
