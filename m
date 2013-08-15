Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4CF417F4E
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:15:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BB338F8033
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:15:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1b3JZZ48kxeJSWJi for <linux-xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 14:15:21 -0700 (PDT)
Message-ID: <520D44E7.1000905@sandeen.net>
Date: Thu, 15 Aug 2013 16:15:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: don't verify checksum on non-V5 superblocks
References: <520D1BA3.1050500@redhat.com> <20130815210018.GR6023@dastard>
In-Reply-To: <20130815210018.GR6023@dastard>
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
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On 8/15/13 4:00 PM, Dave Chinner wrote:
> On Thu, Aug 15, 2013 at 01:19:15PM -0500, Eric Sandeen wrote:
>> The current test in xfs_sb_read_verify() will attempt to validate
>> an sb checksum if sb_crc is non-zero, even if the superblock is not
>> marked as being version 5.
>>
>> This runs the risk of picking up random garbage in sb_crc for non-V5
>> superblocks; such garbage is known to exist in the wild due to prior bugs.
>> This will cause verification to fail for otherwise non-fatal reasons.
>>
>> I'm not sure of the point of trying to validate a non-V5 superblock;
>> is there one?  Shouldn't this || be an &&?  (Can sb_crc validly be
>> 0 for a V5 SB?)
> 
> I don't think so.
> 
> As I mentioned on the call, the reason for this check is that if we
> have a CRC set and a non-v5 superblock version, we may have a
> corrupt superblock with bit errors in it. In this case, we check the
> CRC to determine if the superblock is intact. If the CRC validates,
> then it means that we wrote a bad superblock to disk (i.e. a code
> bug). If it doesn't validate, then the superblock is in a corrupt
> state because all fields not understood by the v4 superblock should
> be zero.
> 
> That's why if the checksum fails we are returning EFSCORRUPTED.
> 
> The problem we see here is not the validation of the primary
> superblock - it's the secondary superblocks that have been written
> by growfs that are the problem. We already know that we are
> verifying a secondary superblock by the "check_inprogress"
> parameter. Hence if we get this problem on a secondary superblock we
> can verify it against the primary superblock via the struct
> xfs_mount (i.e. mp->m_sb.sb_versionnum) and determine whether we do
> indeed have a v4 or v5 superblock and hence determine whether we
> should error out or just warn about it.

Ok, let me resend a patch under the same subject, different implementation :)

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
