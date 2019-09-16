Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5730C4CEC7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 02:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2162077C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 02:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VIgA9LMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfIPCLZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Sep 2019 22:11:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35481 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfIPCLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Sep 2019 22:11:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id 205so21954449pfw.2;
        Sun, 15 Sep 2019 19:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/20H7XMmrapmq88RmPL+YUYB/9nIDUeRs7x4/PTNO0g=;
        b=VIgA9LMljQeaLBajBdOktQP/aIaMsHCdubJ3L6UUmrNB/KMbI2V3qwB/WurlUnKEjW
         63TuTjXiq+6pIxqZHf1xsWxpy8xVh7SK91VwAsF9r3qYZVVvRuRg0hksJYfCHaUTdnOh
         hDjpuHhOw6Oud/PBRSLmNIybgjb79mv5J3eVS//rGylRLBp9at8BEIb3cTjWikzZs6qx
         M1PaqXp4dD1qsVo6CGNXgljjbFraprl34YAo8HPjUqLcjIs3jecYwz+UKN++Krjc+gFU
         OqftP5HXrAAeJR5+lG0Tl7DpsHutg+yvEijf1UFLvGvKwtfTjrP99EDFP75rZ2Utqku7
         dIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/20H7XMmrapmq88RmPL+YUYB/9nIDUeRs7x4/PTNO0g=;
        b=ParmozvyBCaOcvzo2WiahzsaYyJF08Astv19EpJ6SBCnsnVgYCJcj5ibs8hpMiPcbX
         P78Av7oEqp2zc1dA8+ZCafw6Quz/F0Efhc5V53sLB287ltkD1aTn0n0DTqV7i5KLzTOX
         pqCoN5HIFkz8mzFN9ot3a6FluMmgOrMZfPwaGqobwHcxTbrEXTrm6ptfAsyQjiNFU+Dg
         d6y/RroAFlIghFGJienheWU8zj41O6LD2uD9fFvXIQ4WWIXLaCfKm1UJHHaQRc1Yl78p
         Mw2/rfjeeIsB1m6pHx3zi0Rv6rzdT82I+JUlEFJCJ5d3mwLYLizj/yIf6Ya/HlBGnLIH
         3LXQ==
X-Gm-Message-State: APjAAAWghCUmZAzFRUUe3iqJhMqytexaojg01d7N47xVhgMOvMrSl35V
        +8IT1lFO1g153tQO26vRYA==
X-Google-Smtp-Source: APXvYqw+4hqQ6NTudjvCqG2QeqL948LS8AEBQMYKdQULyw1PG8pCSeFVtTlCzCxlnLU7CxGqJs4jcQ==
X-Received: by 2002:a17:90a:8d0c:: with SMTP id c12mr18220258pjo.119.1568599884696;
        Sun, 15 Sep 2019 19:11:24 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id l6sm21036663pje.28.2019.09.15.19.11.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 19:11:24 -0700 (PDT)
Subject: Re: [PATCH 1/2] common: check if a given rename flag is supported in
 _requires_renameat2
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <719f7bb3-96db-7563-56d8-56ed765fabc4@gmail.com>
 <20190913173614.GC28512@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <8b088d88-6134-fde6-36e5-34118e4f77c5@gmail.com>
Date:   Mon, 16 Sep 2019 10:11:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190913173614.GC28512@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/9/14 1:36, Brian Foster wrote:
> On Wed, Sep 11, 2019 at 09:15:16PM +0800, kaixuxia wrote:
>> Some testcases may require a special rename flag, such as RENAME_WHITEOUT,
>> so add support check for if a given rename flag is supported in
>> _requires_renameat2.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
> 
> Looks mostly reasonable...
> 
>>  common/renameat2  | 41 +++++++++++++++++++++++++++++++++++++++--
>>  tests/generic/024 | 13 +++----------
>>  tests/generic/025 | 13 +++----------
>>  tests/generic/078 | 13 +++----------
>>  4 files changed, 48 insertions(+), 32 deletions(-)
>>
>> diff --git a/common/renameat2 b/common/renameat2
>> index f8d6d4f..7bb81e0 100644
>> --- a/common/renameat2
>> +++ b/common/renameat2
>> @@ -103,10 +103,47 @@ _rename_tests()
>>  #
>>  _requires_renameat2()
>>  {
>> +	local flags=$1
>> +	local rename_dir=$TEST_DIR/$$
>> +
>>  	if test ! -x src/renameat2; then
>>  		_notrun "renameat2 binary not found"
>>  	fi
>> -	if ! src/renameat2 -t; then
>> -		_notrun "kernel doesn't support renameat2 syscall"
>> +
>> +	if test -z "$flags"; then
>> +		src/renameat2 -t
>> +		[ $? -eq 0 ] || _notrun "kernel doesn't support renameat2 syscall"
>> +		return
>>  	fi
>> +
>> +	case $flags in
>> +	"noreplace")
>> +		mkdir $rename_dir
>> +		touch $rename_dir/foo
>> +		if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
>> +			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
>> +			_notrun "fs doesn't support RENAME_NOREPLACE"
>> +		fi
>> +		;;
>> +	"exchange")
>> +		mkdir $rename_dir
>> +		touch $rename_dir/foo $rename_dir/bar
>> +		if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
>> +			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
>> +			_notrun "fs doesn't support RENAME_EXCHANGE"
>> +		fi
>> +		;;
>> +	"whiteout")
>> +		mkdir $rename_dir
>> +		touch $rename_dir/foo $rename_dir/bar
>> +		if ! src/renameat2 -t -w $rename_dir/foo $rename_dir/bar; then
>> +			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
>> +			_notrun "fs doesn't support RENAME_WHITEOUT"
>> +		fi
>> +		;;
>> +	*)
>> +		_notrun "only support noreplace,exchange,whiteout rename flags, please check."
>> +		;;
>> +	esac
> 
> ... but it seems like this could be simplified to reduce (duplicate)
> code. For example:
> 
> 	mkdir $rename_dir
> 	touch $rename_dir/foo
> 	cmd=""
> 	case $flags in
> 	"noreplace")
> 		cmd="-n $rename_dir/foo $rename_dir/bar"
> 		;;
> 	"exchange")
> 		touch $rename_dir/bar
> 		cmd="-x $rename_dir/foo $rename_dir/bar"
> 		;;
> 	"whiteout")
> 		touch $rename_dir/bar
> 		cmd="-w $rename_dir/foo $rename_dir/bar"
> 		;;
> 	...
> 	if ! src/renameat2 -t $cmd; then
> 		rm -rf $rename_dir
> 		_notrun "fs doesn't support renameat2"
> 	fi
> 	rm -rf $rename_dir
> 
> Hm?
> 
Yeah, make more sense.

> Brian
> 
>> +	rm -fr $rename_dir
>>  }
>> diff --git a/tests/generic/024 b/tests/generic/024
>> index 2888c66..9c1161a 100755
>> --- a/tests/generic/024
>> +++ b/tests/generic/024
>> @@ -29,20 +29,13 @@ _supported_fs generic
>>  _supported_os Linux
>>  
>>  _require_test
>> -_requires_renameat2
>> +_requires_renameat2 noreplace
>>  _require_test_symlinks
>>  
>> -rename_dir=$TEST_DIR/$$
>> -mkdir $rename_dir
>> -touch $rename_dir/foo
>> -if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
>> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
>> -    _notrun "fs doesn't support RENAME_NOREPLACE"
>> -fi
>> -rm -f $rename_dir/foo $rename_dir/bar
>> -
>>  # real QA test starts here
>>  
>> +rename_dir=$TEST_DIR/$$
>> +mkdir $rename_dir
>>  _rename_tests $rename_dir -n
>>  rmdir $rename_dir
>>  
>> diff --git a/tests/generic/025 b/tests/generic/025
>> index 0310efa..1ee9ad6 100755
>> --- a/tests/generic/025
>> +++ b/tests/generic/025
>> @@ -29,20 +29,13 @@ _supported_fs generic
>>  _supported_os Linux
>>  
>>  _require_test
>> -_requires_renameat2
>> +_requires_renameat2 exchange
>>  _require_test_symlinks
>>  
>> -rename_dir=$TEST_DIR/$$
>> -mkdir $rename_dir
>> -touch $rename_dir/foo $rename_dir/bar
>> -if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
>> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
>> -    _notrun "fs doesn't support RENAME_EXCHANGE"
>> -fi
>> -rm -f $rename_dir/foo $rename_dir/bar
>> -
>>  # real QA test starts here
>>  
>> +rename_dir=$TEST_DIR/$$
>> +mkdir $rename_dir
>>  _rename_tests $rename_dir -x
>>  rmdir $rename_dir
>>  
>> diff --git a/tests/generic/078 b/tests/generic/078
>> index 9608574..37f3201 100755
>> --- a/tests/generic/078
>> +++ b/tests/generic/078
>> @@ -29,20 +29,13 @@ _supported_fs generic
>>  _supported_os Linux
>>  
>>  _require_test
>> -_requires_renameat2
>> +_requires_renameat2 whiteout
>>  _require_test_symlinks
>>  
>> -rename_dir=$TEST_DIR/$$
>> -mkdir $rename_dir
>> -touch $rename_dir/foo $rename_dir/bar
>> -if ! src/renameat2 -t -w $rename_dir/foo $rename_dir/bar; then
>> -    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
>> -    _notrun "fs doesn't support RENAME_WHITEOUT"
>> -fi
>> -rm -f $rename_dir/foo $rename_dir/bar
>> -
>>  # real QA test starts here
>>  
>> +rename_dir=$TEST_DIR/$$
>> +mkdir $rename_dir
>>  _rename_tests $rename_dir -w
>>  rmdir $rename_dir
>>  
>> -- 
>> 1.8.3.1
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
