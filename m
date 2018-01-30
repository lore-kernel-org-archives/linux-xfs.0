Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36183 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751779AbeA3Rb7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Jan 2018 12:31:59 -0500
Subject: Re: [PATCH v6 1/2] Return bytes transferred for partial direct I/O
References: <20180129145741.29486-1-rgoldwyn@suse.de>
 <98449f4d-8ab7-15e6-d3dd-f547d58177e4@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <3a01f3eb-3363-ab23-dbbc-dda45f4f0bf7@suse.de>
Date: Tue, 30 Jan 2018 11:31:54 -0600
MIME-Version: 1.0
In-Reply-To: <98449f4d-8ab7-15e6-d3dd-f547d58177e4@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, ak@linux.intel.com, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 01/29/2018 01:04 PM, Randy Dunlap wrote:
> On 01/29/2018 06:57 AM, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
> 
>> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
>> index 6c00c1e2743f..72e213d62511 100644
>> --- a/Documentation/sysctl/fs.txt
>> +++ b/Documentation/sysctl/fs.txt
>> @@ -76,6 +77,19 @@ dcache isn't pruned yet.
>>  
>>  ==============================================================
>>  
>> +dio_short_writes:
>> +
>> +In case Direct I/O encounters an transient error, it returns
> 
>                                  a transient
> 
>> +the errorcode, even if it has performed part of the write.
> 
>        error code,
> 
>> +This flag, if on (default), will return the number of bytes written
>> +so far, as the write(2) symantics are. However, some older applications
> 
>                            semantics
> 
>> +still consider a direct write as an error if all of the I/O
>> +submitted is not complete. ie write(file, count, buf) != count.
> 
>                               I.e.
> 
>> +This option can be disabled on systems in order to support
>> +existing applications which do not expect short writes.

Thanks for the comments. I will incorporate the language changes.

> 
> and if my system has a mix of older applications and new ones,
> will they all work just fine?
> 

Newer applications should treat the error as nothing is written.
But yes, I tried doing it through prctl for an individual processes, but
did not find a free bit to stick it in.

-- 
Goldwyn
