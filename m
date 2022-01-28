Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FA5C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241343AbiA1W2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:28:15 -0500
Received: from sandeen.net ([63.231.237.45]:43020 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235188AbiA1W1g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 17:27:36 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B5E2D78FD;
        Fri, 28 Jan 2022 16:27:22 -0600 (CST)
Message-ID: <3c99180d-4ae2-a2dc-003d-c8efbdc1fd7f@sandeen.net>
Date:   Fri, 28 Jan 2022 16:27:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH 41/45] libxfs: always initialize internal buffer map
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263806915.860211.11553766371419430734.stgit@magnolia>
 <b9f69740-0671-ab4d-a4c7-4fd158f1cab8@sandeen.net>
 <20220128220325.GH13540@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220128220325.GH13540@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/28/22 4:03 PM, Darrick J. Wong wrote:
> On Fri, Jan 28, 2022 at 02:31:11PM -0600, Eric Sandeen wrote:
>> On 1/19/22 6:21 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> The __initbuf function is responsible for initializing the fields of an
>>> xfs_buf.  Buffers are always required to have a mapping, though in the
>>> typical case there's only one mapping, so we can use the internal one.
>>>
>>> The single-mapping b_maps init code at the end of the function doesn't
>>> quite get this right though -- if a single-mapping buffer in the cache
>>> was allowed to expire and now is being repurposed, it'll come out with
>>> b_maps == &__b_map, in which case we incorrectly skip initializing the
>>> map.
>>
>> In this case b_nmaps must already be 1, right. And it's the bn and
>> length in b_maps[0] that fail to be initialized?
>>
>> I wonder, then, if it's any more clear to reorganize it just a little bit,
>> like:
>>
>>          if (!bp->b_maps) {
>>                  bp->b_maps = &bp->__b_map;
>>                  bp->b_nmaps = 1;
>>          }
>>
>>          if (bp->b_maps == &bp->__b_map) {
>>                  bp->b_maps[0].bm_bn = bp->b_bn;
>>                  bp->b_maps[0].bm_len = bp->b_length;
>>          }
>>
>> because AFAICT b_nmaps only needs to be reset to 1 if we didn't already
>> get here with b_maps == &__b_map?
> 
> That would also work, though it's less obvious (to me anyway) that
> b_nmaps is always 1 when bp->b_maps == &bp->__b_map.

Ok. I'll leave it alone.

-Eric

> 
> --D
> 
>> If this is just navel-gazing I can leave it as is. If you think it's
>> any clearer, I'll make the change. (or if I've gotten it completely wrong,
>> sorry!)
>>
>> Thanks,
>> -Eric
>>
>>> This has gone unnoticed until now because (AFAICT) the code paths
>>> that use b_maps are the same ones that are called with multi-mapping
>>> buffers, which are initialized correctly.
>>>
>>> Anyway, the improperly initialized single-mappings will cause problems
>>> in upcoming patches where we turn b_bn into the cache key and require
>>> the use of b_maps[0].bm_bn for the buffer LBA.  Fix this.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>> ---
>>>    libxfs/rdwr.c |    6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>>
>>> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
>>> index 5086bdbc..a55e3a79 100644
>>> --- a/libxfs/rdwr.c
>>> +++ b/libxfs/rdwr.c
>>> @@ -251,9 +251,11 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
>>>    	bp->b_ops = NULL;
>>>    	INIT_LIST_HEAD(&bp->b_li_list);
>>> -	if (!bp->b_maps) {
>>> -		bp->b_nmaps = 1;
>>> +	if (!bp->b_maps)
>>>    		bp->b_maps = &bp->__b_map;
>>> +
>>> +	if (bp->b_maps == &bp->__b_map) {
>>> +		bp->b_nmaps = 1;
>>>    		bp->b_maps[0].bm_bn = bp->b_bn;
>>>    		bp->b_maps[0].bm_len = bp->b_length;
>>>    	}
>>>
> 
