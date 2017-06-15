Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51332 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751620AbdFOAGy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jun 2017 20:06:54 -0400
Subject: Re: [PATCH 1/2] metadump: warn about corruption if log is dirty
References: <20170413081354.22170-1-jtulak@redhat.com>
 <20170413081354.22170-2-jtulak@redhat.com>
 <20170413115408.GA24893@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5bb73256-ff28-6b3e-0bc4-91402174d96a@sandeen.net>
Date: Wed, 14 Jun 2017 19:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <20170413115408.GA24893@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/13/17 6:54 AM, Brian Foster wrote:
> On Thu, Apr 13, 2017 at 10:13:53AM +0200, Jan Tulak wrote:
>> Add a warning about possible corruption when exporting a dirty log, as
>> the log content does not agree with obfuscated metadata.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>> Change: More elaborate warning message.
>> ---
>>  db/metadump.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 66952f6..2dd8593 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -2726,7 +2726,9 @@ copy_log(void)
>>  		/* keep the dirty log */
>>  		if (obfuscate)
>>  			print_warning(
>> -_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
>> +_("Warning: log recovery of an obfuscated metadata image can leak "
>> +"unobfuscated metadata and/or cause image corruption. Please mount "
>> +"the source filesystem to clean the log or disable obfuscation, if possible."));
>>  		break;
> 
> Thanks Jan, just one very minor nit having read this again... could we
> put the "if possible" closer to the part about mounting the source
> image? Otherwise it reads to me that it might not be technically
> possible to disable obfuscation, which is not the case (though the user
> may not want to do that as a matter of policy). For example:
> 
> "... Please mount the source filesystem to clean the log, if possible,
> or disable obfuscation."

Hoovering up old patches ... 

To me, Jan's original is ok.  "If possible" applying to both replay and
disabling obfuscation seems reasonable, because "policy" may make it
impossible ;)  So I hate to direct the user to disable obfuscation.

"If possible, please mount the filesystem to clean the log, or disable
obfuscation."

Is that OK?  Gives the user options, and wiggle room..

-Eric

> With that tweak:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
>>  	case -1:
>>  		/* log detection error */
>> -- 
>> 2.1.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
