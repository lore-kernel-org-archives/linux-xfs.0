Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A9777F3F
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 22:16:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F303304043
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 20:16:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xePL1KEW9LF397gn for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 20:16:22 -0800 (PST)
Message-ID: <52F85294.6010309@sandeen.net>
Date: Sun, 09 Feb 2014 22:16:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfs: add xfs_verifier_error()
References: <52F83630.4020008@redhat.com> <52F83A8D.7030506@sandeen.net>
	<20140210034321.GR13647@dastard>
In-Reply-To: <20140210034321.GR13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2/9/14, 9:43 PM, Dave Chinner wrote:
> On Sun, Feb 09, 2014 at 08:33:49PM -0600, Eric Sandeen wrote:
>> We want to distinguish between corruption, CRC errors,
>> etc.  In addition, the full stack trace on verifier errors
>> seems less than helpful; it looks more like an oops than
>> corruption.  
>>
>> Create a new function to specifically alert the user to
>> verifier errors, which can differentiate between
>> EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
>> unless the xfs error level is turned up high.
>>
>> Define a new error message (EFSBADCRC) to clearly identify
>> CRC errors.  (Defined to EILSEQ, bad byte sequence)
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  fs/xfs/xfs_error.c |   22 ++++++++++++++++++++++
>>  fs/xfs/xfs_error.h |    3 +++
>>  fs/xfs/xfs_linux.h |    1 +
>>  3 files changed, 26 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
>> index 9995b80..08d76f4 100644
>> --- a/fs/xfs/xfs_error.c
>> +++ b/fs/xfs/xfs_error.c
>> @@ -178,3 +178,25 @@ xfs_corruption_error(
>>  	xfs_error_report(tag, level, mp, filename, linenum, ra);
>>  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
>>  }
>> +
>> +/*
>> + * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
>> + * values, and omit the stack trace unless the error level is tuned high.
>> + */
>> +void
>> +__xfs_verifier_error(
>> +	const char		*func,
>> +	struct xfs_buf		*bp)
>> +{
>> +	struct xfs_mount *mp = bp->b_target->bt_mount;
>> +
>> +	xfs_alert(mp,
>> +"%sCorruption detected in %s, block 0x%llx. Unmount and run xfs_repair",
>> +		  bp->b_error == EFSBADCRC ? "CRC " : "", func, bp->b_bn);
> 
> Perhaps if we do this:
> 
> 	xfs_alert(mp,
> "Metadata %s detected at %pF, block 0x%llx. Unmount and run xfs_repair",
> 		  bp->b_error == EFSBADCRC ? "CRC error"
> 					   : "corruption", _RET_IP_, bp->b_bn);
> 
> We'll get a symbol of the form caller_name+0xoffset similar to a
> stack dump. That way if we have multiple calls to a
> xfs_verifier_error() inside a single function we get something that
> tells us which call detected the error...

Hm, but the point of the switch based on error nrs was to require only
one call in each ->verifier, and ...

> Also, the use of _RET_IP_ gets rid of the need for the wrapper
> macro....

0x${SPLAT} is a lot less useful than i.e. "xfs_agi_read_verify"

Printing the _RET_IP_ requires disassembly of that particular build
to figure out where we went wrong, whereas printing __func__ makes it
clear on the initial read of the dmesg.

> i.e. we could replace all the XFS_WANT_CORRUPTED_RETURN() calls in
> __xfs_dir3_data_check() with calls to xfs_verifier_error() so we can
> determine exactly what corruption check failed...

Well, I'm sympathetic to that goal, but I wonder if we can't do both;
print in plain english which verifier went bad, and also (when warranted)
print lower level details in some other manner...?

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
