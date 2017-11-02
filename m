Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53861 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbdKBG77 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 02:59:59 -0400
Subject: Re: [PATCH v2 1/4] common: Check for fiemap range argument support
References: <1509459011-7398-1-git-send-email-nborisov@suse.com>
 <1509459096-7585-1-git-send-email-nborisov@suse.com>
 <20171102031622.GV17339@eguan.usersys.redhat.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <48f9cb81-4d22-1682-4205-6bb1bbfd4989@suse.com>
Date: Thu, 2 Nov 2017 08:59:56 +0200
MIME-Version: 1.0
In-Reply-To: <20171102031622.GV17339@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, darrick.wong@oracle.com



On  2.11.2017 05:16, Eryu Guan wrote:
> On Tue, Oct 31, 2017 at 04:11:33PM +0200, Nikolay Borisov wrote:
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  common/rc | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index e2a8229..673f9ef 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2053,8 +2053,15 @@ _require_xfs_io_command()
>>  			-c "$command 4k 8k" $testfile 2>&1`
>>  		;;
>>  	"fiemap")
>> +		if [ ! -z "$param" ]
>> +		then
>> +			$XFS_IO_PROG -c "help fiemap" | head -n 1 | grep -q "[offset [len]]" || \
>                                                                             ^^^^^^^^^^^^^^^^
> this doesn't look correct to me, the "bracket expression" is a
> "Character Classes", grep matches any single char in the char set. A
> quick test shows it only matches the last two chars, that's "n]"
> 
> $ echo "[offset len]" | grep  "[offset [len]]"
> [offset len]
>           ^^ highlighted
> 
> fgrep should work, or grep -q "\[offset \[len\]\]"
> 
> But now the fiemap check in _require_xfs_io_command checks range support
> on whatever $param it takes, even the '[-al] [-n nx]' param that have
> nothing to do with range.

Fair enough, my testing shows that something like that ought to work:
grep "[[:digit:]]\+[bskmgtpe]\? [[:digit:]]\+[bskmgtpe]\?$" to match
only the last two numbers

> 
> Thanks,
> Eryu
> 
>> +				_notrun "xfs_io $command range param support is missing"
>> +		fi
>> +
>>  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
>>  			-c "fiemap -v $param" $testfile 2>&1`
>> +
>>  		param_checked=1
>>  		;;
>>  	"flink" )
>> -- 
>> 2.7.4
>>
> 
