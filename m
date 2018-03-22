Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55170 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751641AbeCVCPL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 22:15:11 -0400
Subject: Re: [PATCH] metadump/restore: don't use errno after fwrite/fread
 failures
References: <f40f7d1b-31b5-e5a0-4077-9480530ebf0d@redhat.com>
 <20180321235839.GO4818@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <42fdc4b1-b3a5-e4cb-16d0-68acd11cf211@sandeen.net>
Date: Wed, 21 Mar 2018 21:15:10 -0500
MIME-Version: 1.0
In-Reply-To: <20180321235839.GO4818@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 3/21/18 6:58 PM, Darrick J. Wong wrote:
> On Wed, Mar 21, 2018 at 06:24:09PM -0500, Eric Sandeen wrote:
>> fread/fwrite don't set errno, so printing out strerror(errno)
>> after a failure leads to incorrect and confusing messages:
>>
>> # xfs_mdrestore pre_repair.meta pre_repair.img
>> xfs_mdrestore: error reading from file: Success
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 9d62958..231adc6 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -161,7 +161,7 @@ write_index(void)
>>  	 */
>>  	metablock->mb_count = cpu_to_be16(cur_index);
>>  	if (fwrite(metablock, (cur_index + 1) << BBSHIFT, 1, outf) != 1) {
>> -		print_warning("error writing to file: %s", strerror(errno));
>> +		print_warning("error writing to target file");
>>  		return -errno;
> 
> return -1?

Oh derp.
