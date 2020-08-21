Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D55C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 15:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2F5207C3
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 15:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHUPsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:48:11 -0400
Received: from sandeen.net ([63.231.237.45]:50080 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgHUPsH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Aug 2020 11:48:07 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D1E352AEF;
        Fri, 21 Aug 2020 10:48:03 -0500 (CDT)
Subject: Re: [PATCH 2/2] xfs_db: consolidate set_iocur_type behavior
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
 <8062b2d0-3fbb-0240-d5dd-c7bfb452f0b3@redhat.com>
 <20200821145210.GM6096@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d3331fa1-cf71-112c-608d-d3942b76357b@sandeen.net>
Date:   Fri, 21 Aug 2020 10:48:06 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200821145210.GM6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/21/20 9:52 AM, Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 07:09:45PM -0500, Eric Sandeen wrote:
>> Right now there are 3 cases to type_f: inode type, type with fields,
>> and a default.  The first two were added to address issues with handling
>> V5 metadata.
>>
>> The first two already use some version of set_cur, which handles all
>> of the validation etc. There's no reason to leave the open-coded bits
>> at the end, just send every non-inode type through set_cur and be done
>> with it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>>  io.c |   28 +++++-----------------------
>>  1 file changed, 5 insertions(+), 23 deletions(-)
>>
>> diff --git a/db/io.c b/db/io.c
>> index 884da599..235191f5 100644
>> --- a/db/io.c
>> +++ b/db/io.c
>> @@ -603,33 +603,15 @@ set_iocur_type(
>>  				iocur_top->boff / mp->m_sb.sb_inodesize);
>>  		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b), agino);
>>  		set_cur_inode(ino);
>> -		return;
>> -	}
>> -
>> -	/* adjust buffer size for types with fields & hence fsize() */
>> -	if (type->fields) {
>> -		int bb_count;	/* type's size in basic blocks */
>> +	} else  {
> 
> Two spaces    ^^ between the else and the paren.
> 
> I also wonder, why not leave the "return;" at the end of the
> "if (type->typnm == TYP_INODE)" part and then you can reduce the
> indenting level of the rest of the function?

Oh, that might be nice.  I'll see how that looks.

> <shrug> maintainer's prerogative on that one though.
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> /me also wonders why dquots don't get the same "save the buffer offset"
> treatment as inodes, but that's a separate question. :)

hmmmm good question tho.

Thanks for the reviews,
-Eric

> --D
> 
>> +		int bb_count = 1;	/* type's size in basic blocks */
>>  
>> -		bb_count = BTOBB(byteize(fsize(type->fields,
>> +		/* adjust buffer size for types with fields & hence fsize() */
>> +		if (type->fields)
>> +			bb_count = BTOBB(byteize(fsize(type->fields,
>>  					       iocur_top->data, 0, 0)));
>>  		set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
>>  	}
>> -	iocur_top->typ = type;
>> -
>> -	/* verify the buffer if the type has one. */
>> -	if (!bp)
>> -		return;
>> -	if (!type->bops) {
>> -		bp->b_ops = NULL;
>> -		bp->b_flags |= LIBXFS_B_UNCHECKED;
>> -		return;
>> -	}
>> -	if (!(bp->b_flags & LIBXFS_B_UPTODATE))
>> -		return;
>> -	bp->b_error = 0;
>> -	bp->b_ops = type->bops;
>> -	bp->b_ops->verify_read(bp);
>> -	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
>>  }
>>  
>>  static void
>>
> 
