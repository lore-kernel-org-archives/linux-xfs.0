Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37029 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdG1Oof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2017 10:44:35 -0400
Received: by mail-wm0-f43.google.com with SMTP id e199so21809333wmd.0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2017 07:44:34 -0700 (PDT)
Subject: Re: [PATCH 1/5 v2] mkfs: replace variables with opts table: -b,d,s
 options
References: <20170720095156.35417-2-jtulak@redhat.com>
 <20170721123448.6956-1-jtulak@redhat.com>
 <20170727163935.GL18884@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <7bcbb410-ed94-27db-0f85-cdfd4ab267b4@redhat.com>
Date: Fri, 28 Jul 2017 16:44:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170727163935.GL18884@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On 27/07/2017 18:39, Luis R. Rodriguez wrote:

> On Fri, Jul 21, 2017 at 02:34:48PM +0200, Jan Tulak wrote:
>> @@ -1609,6 +1593,7 @@ main(
>>   			break;
>>   		case 'b':
>>   			p = optarg;
>> +			uint64_t tmp;
> Note:
>
> An extra variable added, just so we can get the current value parsed
> so we can then convert it to also set similar collateral variables.
>
>>   			while (*p != '\0') {
>>   				char	**subopts =
>>   						(char **)opts[OPT_B].subopts;
>> @@ -1616,19 +1601,17 @@ main(
>>   
>>   				switch (getsubopt(&p, subopts, &value)) {
>>   				case B_LOG:
>> -					blocklog = parse_conf_val(OPT_B, B_LOG,
>> -								  value);
>> -					blocksize = 1 << blocklog;
>> +					tmp = parse_conf_val(OPT_B, B_LOG,
>> +							     value);
>> +					set_conf_val(OPT_B, B_SIZE, 1 << tmp);
> So here when BLOG is set we update B_SIZE as collateral.
>
>>   					blflag = 1;
>> -					set_conf_val(OPT_B, B_SIZE, blocksize);
>>   					break;
>>   				case B_SIZE:
>> -					blocksize = parse_conf_val(OPT_B,
>> -								   B_SIZE,
>> -								   value);
>> -					blocklog = libxfs_highbit32(blocksize);
>> +					tmp = parse_conf_val(OPT_B, B_SIZE,
>> +							     value);
>> +					set_conf_val(OPT_B, B_LOG,
>> +						libxfs_highbit32(tmp));
> Here is the reverse, when B_SIZE is set we set B_LOG as well.
>
>>   					bsflag = 1;
>> -					set_conf_val(OPT_B, B_LOG, blocklog);
>>   					break;
>>   				default:
>>   					unknown('b', value);
>> @@ -1641,18 +1624,17 @@ main(
>>   				char	**subopts =
>>   						(char **)opts[OPT_D].subopts;
>>   				char	*value;
>> +				uint64_t tmp;
>> +
>>   
>>   				switch (getsubopt(&p, subopts, &value)) {
>>   				case D_AGCOUNT:
>> -					agcount = parse_conf_val(OPT_D,
>> -								 D_AGCOUNT,
>> -								 value);
>> +					parse_conf_val(OPT_D, D_AGCOUNT,
>> +						       value);
> If parse_conf_val() could just update the collateral values for us then main()
> would be much cleaner.
It didn't occurred to me that these collaterals could be put into 
parse_conf_val(). That would certainly help both with the main and with 
spotting bugs where some collateral is not set correctly in all cases. 
It seems there should be no issue with that, so I will try to change it 
in the next revision of this set.

> Here parse_conf_val() is used only to update D_AGCOUNT based on the parsed
> value. But note that the return value is ignored. In some other places the
> return value is used. This is inconsistent, and I realize that the reason
> we ignore errors is that getnum() is used, however now is a good time to
> consider if we should just allow the caller to check the error value and
> return a proper error message and bail on their own. This would allow for
> better contextual error messages as the code grows. We can discuss this in
> the patch that adds parse_conf_val().
The returned value is used to shorter parse_conf_val(X); tmp = 
get_conf_val(X); to just tmp = parse_conf_val();, not for testing for 
errors.
>
>> @@ -2464,10 +2517,20 @@ _("rmapbt not supported with realtime devices\n"));
>>   		sb_feat.log_version = 2;
>>   	}
>>   
>> -	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
>> +	int dsunit = get_conf_val(OPT_D, D_SUNIT);
>> +	int dswidth = get_conf_val(OPT_D, D_SWIDTH);
> Is int proper here?
>
calc_stripe_factors() has all arguments as int since 2002, so I see no 
issue here - it doesn't change anything.

Jan

