Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 00:01:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J70V3U029134
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 00:00:32 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63ED191D518
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 00:02:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id EyFYpeArJtDJ5ZQm for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 00:02:03 -0700 (PDT)
Message-ID: <48D34E66.5090006@sandeen.net>
Date: Fri, 19 Sep 2008 00:01:58 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>    <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com> <59243.131.252.241.230.1221762601.squirrel@sandeen.net> <48D2F874.4060608@sgi.com>
In-Reply-To: <48D2F874.4060608@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Eric Sandeen wrote:
>> Lachlan McIlroy wrote:
>>> Russell, this fixes xfs_iext_irec_compact_full().  If we don't move
>>> all the records from the next page into the current page then we need
>>> to update the er_extoff of the modified page as we move the remaining
>>> extents up.  Would you mind giving it a go?
>>>
>>> --- a/fs/xfs/xfs_inode.c	2008-09-18 18:48:46.000000000 +1000
>>> +++ b/fs/xfs/xfs_inode.c	2008-09-18 18:57:18.000000000 +1000
>>> @@ -4623,6 +4623,7 @@ xfs_iext_irec_compact_full(
>>>  					(XFS_LINEAR_EXTS -
>>>  						erp_next->er_extcount) *
>>>  					sizeof(xfs_bmbt_rec_t));
>>> +				erp_next->er_extoff += ext_diff;
>>>  			}
>>>  		}
>> Lachlan, I concur.  I spent way too long last night looking at this and
>> arrived at the same conclusion about the root cause of the problem, but
>> didn't hae *quite* the right solution.  I blame it on 2am ;)  Your fix
>> looks right.
>>
>> (though I'd probably move the erp_next changes into the else clause? 
>> Otherwise you're changing it then freeing it.)
> I don't understand what you mean by that.  Could you elaborate?

Sorry I mis-read where the above hunk went... that makes sense as-is above.

For clarity having the erp_next->er_extoff and er_extcount adjustments
together *might* make sense but no big deal.

-Eric
