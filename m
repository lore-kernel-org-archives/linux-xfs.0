Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Dec 2007 15:45:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB2NiwK3009939
	for <xfs@oss.sgi.com>; Sun, 2 Dec 2007 15:45:00 -0800
Message-ID: <475343FB.3060902@sgi.com>
Date: Mon, 03 Dec 2007 10:47:07 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: ACL limit
References: <Pine.LNX.4.64.0711301902360.18767@fbirervta.pbzchgretzou.qr> <20071202223105.GS119954183@sgi.com>
In-Reply-To: <20071202223105.GS119954183@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Fri, Nov 30, 2007 at 07:07:26PM +0100, Jan Engelhardt wrote:
>> Hi,
>>
>>
>> is there any way to raise the number of ACLs that can be stored? The 
>> current limit of 25 is quite tight, where ext3 allows 124 and jfs 8192.
>> Would increasing XFS_ACL_MAX_ENTRIES work (yes, using potentially more 
>> memory), i.e. not interfering with the on-disk format?
> 
> It would be an on disk format change - older kernels would error out
> (-EINVAL) on > 25 ACLs and not check any of them. Hence we'd
> probably need a superblock feature bit to indicate that >25 ACEs are
> supported in a given ACL.
> 
> But we can work around that (superblock feature bit) and should
> be able to extend this out to ~8190 entries. We're doing an ACL
> rework ATM, so > 25 entry support should fall out of that....
> 
> Cheers,
> 
> Dave.

Yeah, it's just an array of entries in an EA value.
The EA value is limited to 64K so it's a question of how
many entries you can fit into that.
(64K - 4)/12 = 5461

(So just have to sort out the ondisk change as mentioned above)

--Tim
