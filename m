Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755972AbdKCOFk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Nov 2017 10:05:40 -0400
Subject: Re: [PATCH v3] common: Check for fiemap range argument support
References: <20171102031622.GV17339@eguan.usersys.redhat.com>
 <1509610421-16716-1-git-send-email-nborisov@suse.com>
 <20171102211259.GE4094@dastard>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4a351be1-a6a7-7be0-f139-a2e3aa1c648d@suse.com>
Date: Fri, 3 Nov 2017 16:05:37 +0200
MIME-Version: 1.0
In-Reply-To: <20171102211259.GE4094@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org



On  2.11.2017 23:12, Dave Chinner wrote:
> On Thu, Nov 02, 2017 at 10:13:41AM +0200, Nikolay Borisov wrote:
>> From: Nikolay Borsiov <nborisov@suse.com>
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>> v3:
>>  * Changed the way we detect ranged args. Now use a regexp which checks 
>>  explicitly for the ranged args
>>  common/rc | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index e2a8229..f7a5fe9 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2053,8 +2053,15 @@ _require_xfs_io_command()
>>  			-c "$command 4k 8k" $testfile 2>&1`
>>  		;;
>>  	"fiemap")
>> +		if echo "$param" | egrep -q "[[:digit:]]+[bskmgtpe]? [[:digit:]]+[bskmgtpe]?$"
> 
> What is that for?
> 
> If you're going to dump crazy complex regexes to match something,
> you need comments to explain it in both the commit message and the
> code.
> 
> And, really, if we need to add complex or tricky code to check a
> command exists, we've done somethign wrong. Don't make the "fiemap
> range" command by triggered/detected by an optional parameter, add a
> specific option instead e.g. "-r" for "range query":
> 
> $ xfs_io -c "fiemap -r 0 10k" /mnt/foo

Do you mean having the range params as arguments to the -r option (which
would be a bitch to parse since getopt doesn't support multiple args to
an options). Or having the -r serve as a boolean indicating we'd need to
parse the final 2 args (as it's done currently)?

> 
> Then you can test it like the falloc command tests it's different
> parameters....
> 
> -Dave.
> 
