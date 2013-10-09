Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5397C7F74
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:57:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D390304039
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:57:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id K7tMgKYdKvGPtI6g for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:57:55 -0700 (PDT)
Message-ID: <5255C34F.6020008@sandeen.net>
Date: Wed, 09 Oct 2013 15:57:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 07/32] xfs: dirent dtype presence is dependent on directory
	magic numbers
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-8-git-send-email-david@fromorbit.com>
	<525495A3.30607@sandeen.net> <20131009205131.GK4446@dastard>
In-Reply-To: <20131009205131.GK4446@dastard>
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
Cc: xfs@oss.sgi.com

On 10/9/13 3:51 PM, Dave Chinner wrote:
> On Tue, Oct 08, 2013 at 06:30:43PM -0500, Eric Sandeen wrote:
>> On 9/29/13 10:15 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> The determination of whether a directory entry contains a dtype
>>> field originally was dependent on the filesystem having CRCs
>>> enabled. This meant that the format for dtype beign enabled could be
>>> determined by checking the directory block magic number rather than
>>> doing a feature bit check. This was useful in that it meant that we
>>> didn't need to pass a struct xfs_mount around to functions that
>>> were already supplied with a directory block header.
>>>
>>> Unfortunately, the introduction of dtype fields into the v4
>>> structure via a feature bit meant this "use the directory block
>>> magic number" method of discriminating the dirent entry sizes is
>>> broken. Hence we need to convert the places that use magic number
>>> checks to use feature bit checks so that they work correctly and not
>>> by chance.
>>>
>>> The current code works on v4 filesystems only because the dirent
>>> size roundup covers the extra byte needed by the dtype field in the
>>> places where this problem occurs.
>>
>> Looks right to me.  Nitpicks & questions though:
>>
>> FWIW, I find it confusing that we call xfs_dir3_*()
>> functions from dir2 code or to find out whether the
>> dir is in fact dir2 or dir3.
>>
>> i.e.:
>>
>> return xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
> 
> It's the convention I've used since first introducing the CRC code.
> dir2 means it handles just dir2 format, dir3 means it handles either
> the dir2 or the CRC enabled format.
> 
> That said, this goes away in the directory ops vectorisation patch
> set, when dir2 means "handles dir2 format" and dir3 means "handles
> only dir3 format"....
> 
>> that just seems like an odd name to calculate the header size for
>> dir2 vs. dir3 directories.
>>
>> Also -
>>
>> Is there any pro or con to defining the 3 offsets recursively:
>>
>>  static inline xfs_dir2_data_aoff_t
>>  xfs_dir3_data_dot_offset(struct xfs_mount *mp)
>>  {
>>  	return xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
>>  }
>>  
>>  static inline xfs_dir2_data_aoff_t
>>  xfs_dir3_data_dotdot_offset(struct xfs_mount *mp)
>>  {
>>  	return xfs_dir3_data_dot_offset(mp) +
>> 		xfs_dir3_data_entsize(mp, 1);
>>  }
>>  
>>  static inline xfs_dir2_data_aoff_t
>>  xfs_dir3_data_first_offset(struct xfs_mount *mp)
>>  {
>> 	return xfs_dir3_data_dotdot_offset(mp) +
>> 		xfs_dir3_data_entsize(mp, 2);
>>  }
>>
>> vs directly, i.e.:
>>
>>  static inline xfs_dir2_data_aoff_t
>>  xfs_dir3_data_first_offset(struct xfs_mount *mp)
>>  {
>> 	return xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&mp->m_sb)) +
>> 		xfs_dir3_data_entsize(mp, 1);	/* Dot */
>> 		xfs_dir3_data_entsize(mp, 2);	/* Dotdot */
>>  }
> 
> None, really. This is just a mechanical change to fix the bug, not a
> change of logic. This is changed to the direct method in the dir ops
> vectorisation series....

Ok.  Sorry for not keeping up.

(I knew it was mechanical, didn't mean this patch was wrong, just wondering
out loud some more).

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
