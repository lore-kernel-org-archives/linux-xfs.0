Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ACF977F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 12:20:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 726FE304051
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 10:20:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sV8UcEtGF9qMtf94 for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 10:20:19 -0700 (PDT)
Message-ID: <521B8E51.6090405@sandeen.net>
Date: Mon, 26 Aug 2013 12:20:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix Out-of-bounds access in repair/dinode.c
References: <1376287861.2822.13.camel@ThinkPad-T5421>
	<5214EFFF.4060105@sgi.com> <20130823163828.GS5262@sgi.com>
In-Reply-To: <20130823163828.GS5262@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Rich Johnston <rjohnston@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Li Zhong <zhong@linux.vnet.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On 8/23/13 11:38 AM, Ben Myers wrote:
> Hey Rich and Li Zhong,
> 
> On Wed, Aug 21, 2013 at 11:51:11AM -0500, Rich Johnston wrote:
>> Looks good, thanks for the patch Li Zhong. it has been committed.
>>
>> --Rich
>>
>> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
>>
>> commit e7c05095f5baa9cd2e35a6de03d7dd9f51dd3910
>> Author: Li Zhong <zhong@linux.vnet.ibm.com>
>> Date:   Mon Aug 12 06:11:01 2013 +0000
>>
>>     xfsprogs: fix Out-of-bounds access in repair/dinode.c
>>
>> On 08/12/2013 01:11 AM, Li Zhong wrote:
>>> Following is reported by coverity in bug 1061528:
>>>
>>> 187                        __dirty_no_modify_ret(dirty);
>>>
>>> CID 1061528 (#1 of 1): Out-of-bounds access (OVERRUN)53. overrun-buffer-arg: Overrunning array "dinoc->di_pad" of 6 bytes by passing it to a function which accesses it at byte offset 15 using argument "16UL".
>>> 188                        memset(dinoc->di_pad, 0, 16);
>>>
>>> It seems that di_pad here should be di_pad2, as sekharan pointed out.
>>>
>>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
>>> ---
>>>  repair/dinode.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/repair/dinode.c b/repair/dinode.c
>>> index e607f0b..94bf2f8 100644
>>> --- a/repair/dinode.c
>>> +++ b/repair/dinode.c
>>> @@ -183,9 +183,9 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>>>  	}
>>>
>>>  	for (i = 0; i < 16; i++) {
>>> -		if (dinoc->di_pad[i] != 0) {
>>> +		if (dinoc->di_pad2[i] != 0) {
>>>  			__dirty_no_modify_ret(dirty);
>>> -			memset(dinoc->di_pad, 0, 16);
>>> +			memset(dinoc->di_pad2, 0, 16);
>>>  			break;
>>>  		}
>>>  	}
> 
> We also discussed this issue a bit in this thread:
> http://oss.sgi.com/archives/xfs/2013-08/msg00228.html
> 
> Looks like the loop itself is incorrect and should be removed, and Eric has
> suggested that the conditional be changed to a memcmp in case the size of the
> pad changes in the future.  Would either of you care to spin up another patch
> to clean it up?

I think I was confused; it seems fine as it is in git, not sure what I was
thinking.

memcmp can't use a bare "0" as an arg, so it's not ideal to use either.

Not a huge fan of the hard-coded 16, but I think the code is correct now; we
can probably move on to real problems.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
