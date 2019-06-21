Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33444 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFUBgx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 21:36:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5L1U5tb052983
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 01:36:51 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t7809kwfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 01:36:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5L1Zumv065991
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 01:36:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t7rdxga63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 01:36:50 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5L1aobn032735
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 01:36:50 GMT
Subject: Re: [PATCH 1/1] xfsprogs: Fix uninitialized cfg->lsunit
References: <20190619182857.9959-1-allison.henderson@oracle.com>
 <20190620153234.GV5387@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <b8319bfb-4678-afea-48e4-4a96b1f36027@oracle.com>
Date: Thu, 20 Jun 2019 18:36:48 -0700
MIME-Version: 1.0
In-Reply-To: <20190620153234.GV5387@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 8:32 AM, Darrick J. Wong wrote:
> On Wed, Jun 19, 2019 at 11:28:57AM -0700, Allison Collins wrote:
>> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
>> left uninitialized when it should not.  This is because calc_stripe_factors
>> in some cases needs cfg->loginternal to be set first.  This is done in
>> validate_logdev. So move calc_stripe_factors below validate_logdev while
>> parsing configs.
> 
> <grumble> The cfg in main() is not (in a manner easily detectable by
> toolz) uninitialized, it's zero-initialized by default and we haven't
> set cfg->loginternal correctly yet...
> 
> ...what we really need here is enum { FALSE, TRUE, FILENOTFOUND } to
> detect that we're using incorrect garbage data. :P
> 
> (Really, someone should take a closer look at whether or not there are
> other places where we do things like this...)
> 
> Anyway, this does solve a problem, so
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Alrighty, thx for the review!

Yes, I gave it a quick look over and didn't notice any other out of 
order usage, but it is really difficult to tell when one function has a 
dependency of another without just pouring through it.

Do you mean to add an enum for every member of the cfg?  That would 
work, but I guess the question then is the added complexity worth just 
making sure everything is configured linearly?

Another approach could be to initialize things to some sort of 
uninitialized signature. Like memset(&cfg, 0xFF, sizeof(struct 
mkfs_params), assuming 0xFF would never otherwise be set.  Then other 
subroutines could check to see if the configs they need are not foxed out.

I think both of these solutions have the effect of scattering default 
config handling and asserts all over the place though.  Which is 
something to consider.  I notice there's been a lot of patches to just 
try and organize things.  Technically it shouldn't be needed if we can 
be diligent about making sure every thing flows forward, but I guess 
deciding which of them is the lesser burden is really the question here. 
  :-)

Thoughts?

Allison

> 
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   mkfs/xfs_mkfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index ddb25ec..f4a5e4b 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -3995,7 +3995,6 @@ main(
>>   	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>>   
>>   	validate_rtextsize(&cfg, &cli, &ft);
>> -	calc_stripe_factors(&cfg, &cli, &ft);
>>   
>>   	/*
>>   	 * Open and validate the device configurations
>> @@ -4005,6 +4004,7 @@ main(
>>   	validate_datadev(&cfg, &cli);
>>   	validate_logdev(&cfg, &cli, &logfile);
>>   	validate_rtdev(&cfg, &cli, &rtfile);
>> +	calc_stripe_factors(&cfg, &cli, &ft);
>>   
>>   	/*
>>   	 * At this point when know exactly what size all the devices are,
>> -- 
>> 2.7.4
>>
