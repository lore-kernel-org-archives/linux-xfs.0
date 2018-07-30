Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59334 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727478AbeGaBR3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 21:17:29 -0400
Subject: Re: [PATCH 2/3] libxfs: add more bounds checking to sb sanity checks
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
 <153292862122.19274.13281750487162777731.stgit@magnolia>
 <82b9a6d9-c5b9-112d-98eb-c9e7153e67da@sandeen.net>
 <20180730233835.GR30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b2743479-b33d-3488-d03b-f8ab319bd6ea@sandeen.net>
Date: Mon, 30 Jul 2018 18:40:06 -0500
MIME-Version: 1.0
In-Reply-To: <20180730233835.GR30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Bill O'Donnell <billodo@redhat.com>



On 7/30/18 6:38 PM, Darrick J. Wong wrote:
> On Mon, Jul 30, 2018 at 06:16:40PM -0500, Eric Sandeen wrote:
>> On 7/30/18 12:30 AM, Darrick J. Wong wrote:
>>> From: Bill O'Donnell <billodo@redhat.com>
>>>
>>> Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
>>> Add sanity checks for these parameters.
>>>
>>> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
>>> [darrick: port to refactored sb validation predicates]
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> comment nitpicks below, but otherwise
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>>> ---
>>>  fs/xfs/libxfs/xfs_sb.c |   12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>>> index 516bef7b0f50..64bc471d57e6 100644
>>> --- a/fs/xfs/libxfs/xfs_sb.c
>>> +++ b/fs/xfs/libxfs/xfs_sb.c
>>> @@ -153,6 +153,18 @@ xfs_validate_sb_write(
>>>  	struct xfs_mount	*mp,
>>>  	struct xfs_sb		*sbp)
>>>  {
>>> +	/*
>>> +	 * Carry out additional sb sanity checks exclusively for writes.
>>
>> We're in xfs_validate_sb_write so that's obvious, can drop this line.
>>
>>> +	 * We don't do these checks for reads, since faulty parameters could
>>> +	 * be fixed in the log, and we shouldn't prohibit mounting for those
>>> +	 * cases.
>>> +	 */
>>
>> Hm, it's not really a log reaplay issue, right?  These summary counters
>> get reinitialized at mount, so failing to mount before we overwrite them
>> anyway makes no sense.
> 
> Well, we don't reinitialize them if ( (!lazysbcount) or (clean log) )
> and (non-crazy values)...
> 
>> /*
>>  * These summary counters get re-initialized after they are read
>>  * during mount, so this is a write-only check.
> 
> They're not always re-initialized -- only if we had a dirty lazysbcont
> fs or the values were crazy.
> 
> /*
>  * Carry out additional sb summary counter sanity checks when we write
>  * the superblock.  We skip this in the read validator because there
>  * could be newer superblocks in the log and if the values are garbage
>  * even after replay we'll recalculate them at the end of log mount.
>  */

Oh, ok sure.  Given my ongoing confusion an explicit/complete comment is
probably good.  For me, if for nobody else.  ;)

Thanks,
-Eric
