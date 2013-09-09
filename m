Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90AD17F55
	for <linux-xfs@oss.sgi.com>; Mon,  9 Sep 2013 16:16:06 -0500 (CDT)
Message-ID: <522E3A95.40309@sgi.com>
Date: Mon, 09 Sep 2013 16:16:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs: be more forgiving of a v4 secondary sb w/ junk
	in v5 fields
References: <520D1BA3.1050500@redhat.com> <20130815210018.GR6023@dastard>
	<520D44E7.1000905@sandeen.net> <520D592D.4040600@redhat.com>
	<522E3099.1040503@sandeen.net> <522E38DB.4020408@sgi.com>
	<522E393E.10902@sandeen.net>
In-Reply-To: <522E393E.10902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On 09/09/13 16:10, Eric Sandeen wrote:
> On 9/9/13 4:08 PM, Mark Tinguely wrote:
>> On 09/09/13 15:33, Eric Sandeen wrote:
>>> Today, if xfs_sb_read_verify encounters a v4 superblock
>>> with junk past v4 fields which includes data in sb_crc,
>>> it will be treated as a failing checksum and a significant
>>> corruption.
>>>
>>> There are known prior bugs which leave junk at the end
>>> of the V4 superblock; we don't need to actually fail the
>>> verification in this case if other checks pan out ok.
>>>
>>> So if this is a secondary superblock, and the primary
>>> superblock doesn't indicate that this is a V5 filesystem,
>>> don't treat this as an actual checksum failure.
>>>
>>> We should probably check the garbage condition as
>>> we do in xfs_repair, and possibly warn about it
>>> or self-heal, but that's a different scope of work.
>>>
>>> Stable folks: This can go back to v3.10, which is what
>>> introduced the sb CRC checking that is tripped up by old,
>>> stale, incorrect V4 superblocks w/ unzeroed bits.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>>> ---
>>>
>>> V2: Comment changes: More!  (No code changes)
>>>
>>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>>> index 2b0ba35..b2deab1 100644
>>> --- a/fs/xfs/xfs_mount.c
>>> +++ b/fs/xfs/xfs_mount.c
>>> @@ -749,6 +749,11 @@ xfs_sb_verify(
>>>     * single bit error could clear the feature bit and unused parts of the
>>>     * superblock are supposed to be zero. Hence a non-null crc field indicates that
>>>     * we've potentially lost a feature bit and we should check it anyway.
>>> + *
>>> + * However, past bugs (i.e. in growfs) left non-zeroed regions beyond the
>>> + * last field in V4 secondary superblocks.  So for secondary superblocks,
>>> + * we are more forgiving, and ignore CRC failures if the primary doesn't
>>> + * indicate that the fs version is V5.
>>>     */
>>>    static void
>>>    xfs_sb_read_verify(
>>> @@ -769,8 +774,12 @@ xfs_sb_read_verify(
>>>
>>>            if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
>>>                          offsetof(struct xfs_sb, sb_crc))) {
>>> -            error = EFSCORRUPTED;
>>> -            goto out_error;
>>> +            /* Only fail bad secondaries on a known V5 filesystem */
>>> +            if (bp->b_bn != XFS_SB_DADDR&&
>>> +                xfs_sb_version_hascrc(&mp->m_sb)) {
>>> +                error = EFSCORRUPTED;
>>> +                goto out_error;
>>> +            }
>>>            }
>>>        }
>>>        error = xfs_sb_verify(bp, true);
>>
>> This moved to fs/xfs/xfs_sb.c in TOT, but the patch looks good to me.
>
> Whoops, sorry.  Thanks for the review.  Want a resend?

Since Ben will do all the work, not necessary. ;)

>
> (Any idea why your mail client eats spaces? "if (bp->b_bn != XFS_SB_DADDR&&" isn't
> in the original patch...)

Dave mentioned that too before, I will check into it.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
