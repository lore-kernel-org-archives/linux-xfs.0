Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 08:51:22 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6SFoiDW003168
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 08:50:54 -0700
Received: from omx2.sgi.com ([198.149.32.25])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6SEjsnx030993
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 09:45:54 -0500
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6SHDjGv024491
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 10:13:45 -0700
Message-ID: <44CA22F8.2040507@sgi.com>
Date: Fri, 28 Jul 2006 07:45:12 -0700
From: Madan Valluri <mvalluri@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: xfs_repair fixes for dir2 corruption
References: <20060728091735.B2196410@wobbly.melbourne.sgi.com> <200607280155.LAA12814@larry.melbourne.sgi.com> <20060728181013.C2197701@wobbly.melbourne.sgi.com>
In-Reply-To: <20060728181013.C2197701@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Barry Naujok <bnaujok@melbourne.sgi.com>, xfs@oss.sgi.com

Nathan Scott wrote:
> On Fri, Jul 28, 2006 at 11:58:52AM +1000, Barry Naujok wrote:
>   
>> This patch addresses the following xfs_repair issues:
>>     
>
> The libxfs cache stuff looks good to me.  Maybe Madan can cast
> an eye over the repair changes for ya?
>
> cheers.
>
>   
>>  
1) Since dir_hash_add can be called for both V1 and V2 directories its 
second parameter type xfs_dir2_dataptr_t should be neutral.
2) In dir_hash_add when dup is set, do you still need to add to the 
nextbyhash by list?
3) The following statement in   longform_dir2_rebuild looks odd. 
Besides, FWIW, you can match "/."

                if (p->name[0] == '/' || (p->name[0] == '.' && 
(p->namelen == 1
                                || (p->namelen == 2 && p->name[1] == '.'))))
                        continue;

Consider:

               if (((p->name[0] == '/' || p->name[0] == '.') && 
p->namelen == 1) ||
                        (p->name[0] == '.' && p->name[1] == '.' && 
p->namelen == 2))
                        continue;

4) Related to items 2&3, shouldn't the code be skipping duplicate entries?
5) Can we do anything to minimize the do_error calls in 
longform_dir2_rebuild? Seems like on a full file system, while 
rebuilding say the root directory, matters can get wacky - The directory 
is being rebuilt and we have no further room. Sounds like that this how 
it has been....

Thanks.

/Madan
