Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C7397FD0
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 15:02:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CCBD304053
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 13:02:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0c5ZN9hquV0ITIA9 for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 13:01:59 -0700 (PDT)
Message-ID: <556F5D36.80909@sandeen.net>
Date: Wed, 03 Jun 2015 15:01:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfsprogs: zero out clean log in xfs_metadump
References: <5568B7CE.9030709@redhat.com> <5568BB5C.4080400@sandeen.net>
	<20150603171132.GD45447@bfoster.bfoster>
In-Reply-To: <20150603171132.GD45447@bfoster.bfoster>
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

On 6/3/15 12:11 PM, Brian Foster wrote:
> On Fri, May 29, 2015 at 02:17:48PM -0500, Eric Sandeen wrote:
>> When doing an xfs_metadump, if the log is clean, zero it out
>> for 2 reasons:
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
>> diff --git a/db/metadump.c b/db/metadump.c
>> index bea4e00..eb5e9da 100644
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
>> @@ -2180,6 +2183,31 @@ copy_log(void)
>>  		print_warning("cannot read log");
>>  		return !stop_on_read_error;
>>  	}
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
> 
> Hmm, so is there any reason in the future we might want a metadump with
> a clean log matching what is actually on-disk? This is a debug tool
> after all. Perhaps this is mainly covered by the unclean and/or error
> cases, but that still seems like a potential loss of capability.
> 
> Anyways, I'm wondering if we should have an 'if (obfuscate)' here.
> Thoughts?

Yeah, I had thought about that too... now, why didn't I do it ... probably
worth doing, I'll send V2 unless I think of a reason not to :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
