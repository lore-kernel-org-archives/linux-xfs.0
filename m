Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 06:15:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4LDFkfB015539
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 06:15:47 -0700
Message-ID: <46519B81.2000202@sandeen.net>
Date: Mon, 21 May 2007 08:15:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix up xfstests a bit for linux+udf
References: <464C871B.3090402@sandeen.net> <F928335EB5A7F2983790993C@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <F928335EB5A7F2983790993C@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Thanks, Eric.
> 
> We probably should make all ACL/EA tests load up common.attr
> (update ones which aren't already - likely the non-acl tests
> as common.attr really has acl stuff at the moment)
> and then do the udf/linux test in common.attr.

ok, I can do that.  I hit a couple other changes, I'll send them all 
along when I can.

-Eric

> --Tim
> 
> --On 17 May 2007 11:47:23 AM -0500 Eric Sandeen <sandeen@sandeen.net> 
> wrote:
> 
>> udf on linux doesn't support acls or attrs, so prevent those tests 
>> from running.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>
>> Index: xfstests/020
>> ===================================================================
>> --- xfstests.orig/020
>> +++ xfstests/020
>> @@ -65,7 +65,7 @@ _attr_list()
>>    # real QA test starts here
>> -_supported_fs xfs udf
>> +_supported_fs xfs
>>  _supported_os Linux
>>   [ -x /usr/bin/attr ] || _notrun "attr is not installed"
>> Index: xfstests/051
>> ===================================================================
>> --- xfstests.orig/051
>> +++ xfstests/051
>> @@ -56,7 +56,7 @@ _cleanup()
>>  #
>>   # real QA test starts here
>> -_supported_fs xfs udf
>> +_supported_fs xfs
>>  _supported_os Linux
>>   [ -x /usr/bin/chacl ] || _notrun "chacl executable not found"
>> Index: xfstests/062
>> ===================================================================
>> --- xfstests.orig/062
>> +++ xfstests/062
>> @@ -102,7 +102,7 @@ _create_test_bed()
>>  }
>>   # real QA test starts here
>> -_supported_fs xfs udf nfs
>> +_supported_fs xfs nfs
>>  _supported_os Linux
>>   _require_scratch
>> Index: xfstests/070
>> ===================================================================
>> --- xfstests.orig/070
>> +++ xfstests/070
>> @@ -33,6 +33,7 @@ _cleanup()
>>  _supported_fs xfs udf nfs
>>  _supported_os IRIX Linux
>>  +[ "$FSTYP" == udf -a "$HOSTOS" == Linux ] && _notrun "Linux UDF does 
>> not support extended
>> attributes"
>>  _setup_testdir
>>   $FSSTRESS_PROG \
>> Index: xfstests/105
>> ===================================================================
>> --- xfstests.orig/105
>> +++ xfstests/105
>> @@ -35,6 +35,8 @@ _cleanup()
>>  _supported_fs xfs udf
>>  _supported_os IRIX Linux
>>  +[ "$FSTYP" == udf -a "$HOSTOS" == Linux ] && _notrun "Linux UDF does 
>> not support ACLS"
>> +
>>  # real QA test starts here
>>   rm -f $seq.full
>>
> 
> 
> 
> 
