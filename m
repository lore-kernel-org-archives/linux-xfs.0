Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 543137F73
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 13:32:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31D85304039
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:32:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WaqqtWJ3meFABrku for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 11:32:18 -0700 (PDT)
Message-ID: <5575DFB1.4010004@sandeen.net>
Date: Mon, 08 Jun 2015 13:32:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4 V2] xfsprogs: zero out clean log in xfs_metadump
References: <5568B7CE.9030709@redhat.com> <5568BB5C.4080400@sandeen.net>
	<5575AF7A.8050306@sandeen.net>
	<20150608182947.GA18211@bfoster.bfoster>
In-Reply-To: <20150608182947.GA18211@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 6/8/15 1:29 PM, Brian Foster wrote:
> On Mon, Jun 08, 2015 at 10:06:34AM -0500, Eric Sandeen wrote:
>> When doing an obfuscated xfs_metadump, if the log is clean, zero
>> it out for 2 reasons:
>>
>>  * It'll make the image more compressible
>>  * It'll eliminate an un-obfuscated metadata source
>>
>> If the log isn't clean, and the user expected obfuscation, warn
>> that metadata in the log will not be obfuscated.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: If not obfuscating, copy log as-is
>>
> 
> FYI, I think v1 of this was already pulled into the for-next branch.
> Anyways...

Yeah, I noticed - I'll ask dave to fix it (that one rebases, right?) :)

>> diff --git a/db/metadump.c b/db/metadump.c
>> index bea4e00..67de0c5 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -17,6 +17,7 @@
>>   */
>>  
>>  #include <libxfs.h>
>> +#include <libxlog.h>
>>  #include "bmap.h"
>>  #include "command.h"
>>  #include "metadump.h"
>> @@ -2169,6 +2170,8 @@ copy_sb_inodes(void)
>>  static int
>>  copy_log(void)
>>  {
>> +	int dirty;
>> +
>>  	if (show_progress)
>>  		print_progress("Copying log");
>>  
>> @@ -2180,6 +2183,36 @@ copy_log(void)
>>  		print_warning("cannot read log");
>>  		return !stop_on_read_error;
>>  	}
>> +
>> +	/* If not obfuscating, just copy the log as it is */
>> +	if (!obfuscate)
>> +		goto done;
>> +
>> +	dirty = xlog_is_dirty(mp, &x, 0);
>> +
>> +	switch (dirty) {
>> +	case 0:
>> +		/* clear out a clean log */
>> +		if (show_progress)
>> +			print_progress("Zeroing clean log");
>> +		memset(iocur_top->data, 0,
>> +			mp->m_sb.sb_logblocks * mp->m_sb.sb_blocksize);
>> +		break;
>> +	case 1:
>> +		/* keep the dirty log */
>> +		if (obfuscate)
> 
> The 'if (obfuscate)' checks here and below are pointless with the
> !obfuscate bypass above. Seems fine otherwise.

Oh hell, I forgot I had those.

V3 coming.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
