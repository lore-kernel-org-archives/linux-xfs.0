Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E221E7F4E
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 08:52:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C0D6E8F8033
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 06:52:44 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GUEG6JbpmZBXTdRk for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 06:52:43 -0800 (PST)
Message-ID: <52F8E7AE.8060103@sandeen.net>
Date: Mon, 10 Feb 2014 08:52:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfs: add xfs_verifier_error()
References: <52F83630.4020008@redhat.com>
	<52F83A8D.7030506@sandeen.net>	<20140210034321.GR13647@dastard>
	<52F85294.6010309@sandeen.net> <20140210111042.GY13997@dastard>
In-Reply-To: <20140210111042.GY13997@dastard>
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

On 2/10/14, 5:10 AM, Dave Chinner wrote:
> On Sun, Feb 09, 2014 at 10:16:20PM -0600, Eric Sandeen wrote:
>> On 2/9/14, 9:43 PM, Dave Chinner wrote:
>>> On Sun, Feb 09, 2014 at 08:33:49PM -0600, Eric Sandeen wrote:
>>>> We want to distinguish between corruption, CRC errors,
>>>> etc.  In addition, the full stack trace on verifier errors
>>>> seems less than helpful; it looks more like an oops than
>>>> corruption.  
>>>>
>>>> Create a new function to specifically alert the user to
>>>> verifier errors, which can differentiate between
>>>> EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
>>>> unless the xfs error level is turned up high.
>>>>
>>>> Define a new error message (EFSBADCRC) to clearly identify
>>>> CRC errors.  (Defined to EILSEQ, bad byte sequence)
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>  fs/xfs/xfs_error.c |   22 ++++++++++++++++++++++
>>>>  fs/xfs/xfs_error.h |    3 +++
>>>>  fs/xfs/xfs_linux.h |    1 +
>>>>  3 files changed, 26 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
>>>> index 9995b80..08d76f4 100644
>>>> --- a/fs/xfs/xfs_error.c
>>>> +++ b/fs/xfs/xfs_error.c
>>>> @@ -178,3 +178,25 @@ xfs_corruption_error(
>>>>  	xfs_error_report(tag, level, mp, filename, linenum, ra);
>>>>  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
>>>>  }
>>>> +
>>>> +/*
>>>> + * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
>>>> + * values, and omit the stack trace unless the error level is tuned high.
>>>> + */
>>>> +void
>>>> +__xfs_verifier_error(
>>>> +	const char		*func,
>>>> +	struct xfs_buf		*bp)
>>>> +{
>>>> +	struct xfs_mount *mp = bp->b_target->bt_mount;
>>>> +
>>>> +	xfs_alert(mp,
>>>> +"%sCorruption detected in %s, block 0x%llx. Unmount and run xfs_repair",
>>>> +		  bp->b_error == EFSBADCRC ? "CRC " : "", func, bp->b_bn);
>>>
>>> Perhaps if we do this:
>>>
>>> 	xfs_alert(mp,
>>> "Metadata %s detected at %pF, block 0x%llx. Unmount and run xfs_repair",
>>> 		  bp->b_error == EFSBADCRC ? "CRC error"
>>> 					   : "corruption", _RET_IP_, bp->b_bn);
>>>
>>> We'll get a symbol of the form caller_name+0xoffset similar to a
>>> stack dump. That way if we have multiple calls to a
>>> xfs_verifier_error() inside a single function we get something that
>>> tells us which call detected the error...
>>
>> Hm, but the point of the switch based on error nrs was to require only
>> one call in each ->verifier, and ...
> 
> Right, that's the current usage of it because we are simply
> returning true/false from the checking code. Determining the exact
> error is the report is much more useful - let's not lose sight of
> the end goal....
> 
>>> Also, the use of _RET_IP_ gets rid of the need for the wrapper
>>> macro....
>>
>> 0x${SPLAT} is a lot less useful than i.e. "xfs_agi_read_verify"
> 
> Note the format string I used: "%pF". That decodes the _RET_IP_
> into the function name and offset from the start of the function.
> i.e. it returns xfs_agi_read_verify+0x<splat>.

I forgot that it did this, TBH.  Ok, I'll rethink things a bit.

(although with multiple failure points in a verifier, +0x4a vs +0x5b
will still require some digging; a line number might be nice, but
then we'd need a wrapper again)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
