Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38F9A7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 21:21:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E8188F8049
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 19:21:49 -0700 (PDT)
Received: from mail-qc0-f169.google.com (mail-qc0-f169.google.com
	[209.85.216.169]) by cuda.sgi.com with ESMTP id
	WvcvLAcbAWC9IVI2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 19:21:47 -0700 (PDT)
Received: by mail-qc0-f169.google.com with SMTP id i17so4886739qcy.28
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 19:21:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535AE19D.8@sandeen.net>
References: <CACyNnZMtP87y6VHum+J4xKEZqaYp2YERVnt3YuaCmeiZBmMTzQ@mail.gmail.com>
	<5359912A.70603@sandeen.net>
	<CACyNnZPV89C87DggE4fiJX+_r3zh1hKhcX3ExmXRzpLLhWJ6CQ@mail.gmail.com>
	<535AE19D.8@sandeen.net>
Date: Fri, 25 Apr 2014 23:21:46 -0300
Message-ID: <CACyNnZPzJGCQf5FYm+Oqkw5U3Ggm8wQd5LKC5Jnwiyksa-K1OA@mail.gmail.com>
Subject: Re: How to find the inodes in XFS
From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hello,

Thanks a lot! Based on your tips I found the issue and now it is
working =) My failure was trying to convert sb_inopblog and other log2
values from big endian to native endian .... it utilized a 16-bit
routine swapping routine, and when assigning back the value it would
cut the higher bits ... leaving zero =o

Of course 8-bit values don't need endian conversion, so just removing
that fixed the issue =)

thanks,

Felipe Monteiro de Carvalho


On Fri, Apr 25, 2014 at 7:28 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/25/14, 4:51 PM, Felipe Monteiro de Carvalho wrote:
>> Thanks a lot! That's really helpful =)
>>
>> Unfortunately something is going wrong here, and the implementation of
>> XFS_INO_TO_FSB is quite intrincated, enough that it is hard to be sure
>> what is wrong here ... I am trying to resolve the location of the root
>> inode, which has number 128, but my XFS_INO_TO_FSB call is resolving
>> to $80000 which is not an inode.
>
> Then perhaps you have mp set up wrong?  Or maybe it's an endian isue?
>
> If I stuff:
>
> printf("%lld\n", XFS_INO_TO_FSB(mp, 128));
>
> into, say, xfs_repair where we have a valid mp, I get "8"
>
> And xfs_db agrees:
>
> xfs_db> inode 128
> xfs_db> fsblock
> current fsblock is 8
> xfs_db>
>
>
>> XFS_INO_AGINO_BITS returns m_agino_log which is defined as sb_inopblog
>> + sb_agblklog. Both are zero here, so this whole part resolves to
>> zero.
>
> 0, really?
>
>         __uint16_t      sb_inopblock;   /* inodes per block */
>         __uint8_t       sb_inopblog;    /* log2 of sb_inopblock */
>
> Even with maximally-sized inodes at 2k, sb_inopblog would be 1.
>
>
>> About sb_agcount I read and reread the code and it is really hard to
>> figure what number it should have in this part of the code, but in my
>> superblock it comes with value 4, so I am using this.
>>
>> XFS_INO_TO_AGNO = (i) shr XFS_INO_AGINO_BITS, with i (inode nr) =128
>> shr 0 = so this part resolves to 128
>>
>> XFS_INO_TO_AGBNO = (i shr XFS_INO_OFFSET_BITS(m_sb)) and
>> XFS_INO_MASK(XFS_INO_AGBNO_BITS(m_sb));
>>
>> XFS_INO_OFFSET_BITS = sb_inopblog which is 0 in my partition
>>
>> XFS_INO_AGBNO_BITS = sb_agblklog which is 0 in my partition
>
> That doesn't sound right:
>
> xfs_db> sb 0
> xfs_db> p inopblog
> inopblog = 4
> xfs_db> p agblklog
> agblklog = 20
> xfs_db>
>
> -Eric
>
>
>> XFS_INO_MASK = (1 shl k) - 1; with k=0 it resolves to 0
>>
>> #define XFS_INO_TO_AGBNO(mp,i) \
>> (((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
>> XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
>>
>> With i=128 >> 0 we get 0, but then we have & 0, so this whole part
>> resolves to zero
>>
>> So now we are left with         XFS_AGB_TO_FSB(mp, 128, 0)
>>
>> #define XFS_AGB_TO_FSB(mp,agno,agbno) \
>> (((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
>>
>> Which resolves to 128 because 128 << 0 | 0 = 128
>>
>> So I calculate 128 * block_size, I have a blocksize of $1000 in my
>> supernode, so that's how I arrived at $80000
>>
>> But looking inside my partition I'm pretty sure that $80000 is not an inode....
>>
>> Any ideas where I got things wrong?? =( I've been trying for hours to
>> figure where I got things wrong but no ideas yet =/
>>
>> I can post my superblock content here if it would be helpful.
>>
>> thanks again =)
>>
>> Felipe Monteiro de Carvalho
>>
>> On Thu, Apr 24, 2014 at 7:33 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 4/24/14, 5:09 PM, Felipe Monteiro de Carvalho wrote:
>>>> Hello,
>>>>
>>>> I am writing an application which reads XFS partitions, so I am trying
>>>> to understand the internal working of XFS. I read the documentation
>>>> here: http://www.dubeyko.com/development/FileSystems/XFS/xfs_filesystem_structure.pdf
>>>>
>>>> But I am stuck at a particular point. To get to the inodes I see that
>>>> I should first read xfs_agi_t, no problem here, then its root field
>>>> points to a block which contains xfs_inobt_block_t + a sequence of
>>>> xfs_inobt_rec_t records and those records are supposed to show me
>>>> where the inodes are, but there is no field in xfs_inobt_rec_t such as
>>>> a block number =( Any idea how to get then the physical position in
>>>> the disk where the inodes are from xfs_inobt_block_t + a sequence of
>>>> xfs_inobt_rec_t?
>>>
>>> The inode's location is encoded in its inode number.
>>>
>>> See for example:
>>>
>>>
>>> /*
>>>  * Inode number format:
>>>  * low inopblog bits - offset in block
>>>  * next agblklog bits - block number in ag
>>>  * next agno_log bits - ag number
>>>  * high agno_log-agblklog-inopblog bits - 0
>>>  */
>>>
>>>
>>> #define XFS_INO_TO_FSB(mp,i)            \
>>>         XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
>>>
>>> -Eric
>>>
>>>> thanks,
>>>>
>>>
>>
>>
>>
>



-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
