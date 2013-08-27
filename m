Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 929737CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 12:46:13 -0500 (CDT)
Message-ID: <521CE61E.2010606@sgi.com>
Date: Tue, 27 Aug 2013 12:47:10 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: zero out unused parts of superblocks
References: <520C3C60.3090500@redhat.com> <520D0A15.1050304@allmail.net>
	<520E3FBF.7070708@redhat.com>
In-Reply-To: <520E3FBF.7070708@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Michael Maier <m1278468@allmail.net>, xfs-oss <xfs@oss.sgi.com>

On 08/16/2013 10:05 AM, Eric Sandeen wrote:
> On 8/15/13 12:04 PM, Michael Maier wrote:
>> Eric Sandeen wrote:
>>> Prior to:
>>> 1375cb65 xfs: growfs: don't read garbage for new secondary superblocks
>>>
>>> we ran the risk of allowing garbage in secondary superblocks
>>> beyond the in-use sb fields.  With kernels 3.10 and beyond, the
>>> verifiers will kick these out as invalid, but xfs_repair does
>>> not detect or repair this condition.
>>>
>>> There is superblock stale-data zeroing code, but it is under a
>>> narrow conditional - the bug addressed in the above commit did not
>>> meet that conditional.  So change this to check unconditionally.
>>>
>>> Further, the checking code was looking at the in-memory
>>> superblock buffer, which was zeroed prior to population, and
>>> would therefore never possibly show any stale data beyond the
>>> last up-rev superblock field.
>>>
>>> So instead, check the disk buffer for this garbage condition.
>>>
>>> If we detect garbage, we must zero out both the in-memory sb
>>> and the disk buffer; the former may contain unused data
>>> in up-rev sb fields which will be written back out; the latter
>>> may contain garbage beyond all fields, which won't be updated
>>> when we translate the in-memory sb back to disk.
>>>
>>> The V4 superblock case was zeroing out the sb_bad_features2
>>> field; we also fix that to leave that field alone.
>>>
>>> Lastly, use offsetof() instead of the tortured (__psint_t)
>>> casts & pointer math.
>>>
>>> Reported-by: Michael Maier <m1278468@allmail.net>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> Michael - this will need slight tweaking to apply against
>>> older xfsprogs.
>>>
>>> Also:
>>>
>>> With more of Dave's changes, I think we can swap out:
>>>
>>> 		size = offsetof(xfs_sb_t, sb_lsn)
>>> 			+ sizeof(sb->sb_lsn);
>>> for
>>> 		size = xfs_sb_info[XFS_SBS_LSN + 1].offset;
>>>
>>> but this version is a bit easier to backport, and works in the
>>> current git tree...
>>
>> I tested with current git tree and it worked as expected for me!
>> Afterwards I was able to run xfs_growfs (from 3.1.11) w/o any problem.
>>
>> Please excuse me - forgot to set the english locale before starting.
>> Hope you can guess what it should be in english :-).
>>
>
> Kein Problem, ich kann etwas Deutsch zu lesen. :)

Ich auch :)

Code looks good.
Reviewed-by: Rich Johnston <rjohnston@sgi.com>


>
> Glad it worked for you!
>
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
