Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58054 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752094AbcLORxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 12:53:22 -0500
Subject: Re: [PATCH 1/1 linux-next] xfs: remove unnecessary return
References: <1481352729-7020-1-git-send-email-fabf@skynet.be>
 <7ce30624-de82-f682-776c-7b6f1757026d@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7e956ae4-bb46-383a-05fe-b9ac2eb9f855@sandeen.net>
Date: Thu, 15 Dec 2016 11:53:18 -0600
MIME-Version: 1.0
In-Reply-To: <7ce30624-de82-f682-776c-7b6f1757026d@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Fabian Frederick <fabf@skynet.be>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/14/16 10:17 PM, Eric Sandeen wrote:
> On 12/10/16 12:52 AM, Fabian Frederick wrote:
>> Commit f7a136aee3c1
>> ("xfs: several xattr functions can be void")
>>
>> updated 2 end of function return 0 to return in void
>> functions. Remove it.
>>
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> 
> Oh, sure.  :)
> 
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

On second thought, it seems to be quite common in 
xfs to have a last "return;" in void functions:

# grep -n -B1 ^} fs/xfs/*.c fs/xfs/*/*.c | grep "return;" | wc -l
14

so it's really just a style issue, and probably no reason
to change it in just these 2 cases... *shrug* dchinner, take
it or leave it as you see fit.  :)

-Eric
 
>> ---
>>  fs/xfs/xfs_attr_list.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 97c45b6..5aa46c3 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -433,7 +433,6 @@ xfs_attr3_leaf_list_int(
>>  		cursor->offset++;
>>  	}
>>  	trace_xfs_attr_list_leaf_end(context);
>> -	return;
>>  }
>>  
>>  /*
>> @@ -543,7 +542,6 @@ xfs_attr_put_listent(
>>  	alist->al_offset[context->count++] = context->firstu;
>>  	alist->al_count = context->count;
>>  	trace_xfs_attr_list_add(context);
>> -	return;
>>  }
>>  
>>  /*
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
