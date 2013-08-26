Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 416347F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 10:00:25 -0500 (CDT)
Message-ID: <521B6D88.30608@sgi.com>
Date: Mon, 26 Aug 2013 10:00:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
References: <52165830.8050006@redhat.com> <20130826041330.GU6023@dastard>
	<521B59C7.1080803@redhat.com>
In-Reply-To: <521B59C7.1080803@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 08/26/13 08:36, Brian Foster wrote:
> On 08/26/2013 12:13 AM, Dave Chinner wrote:
>> On Thu, Aug 22, 2013 at 02:28:00PM -0400, Brian Foster wrote:
>>> Hi all,
>>>
>>> I hit an assert on a debug kernel while beating on some finobt work and
>>> eventually reproduced it on unmodified/TOT xfs/xfsprogs as of today. I
>>> hit it through a couple different paths, first while running fsstress on
>>> a CRC enabled filesystem (with otherwise default mkfs options):
>>>
>>> (These tests are running on a 4p, 4GB VM against a 100GB virtio disk,
>>> hosted on a single spindle desktop box).
>>>
>>> crc=1
>>> fsstress -z -fsymlink=1 -n99999999 -p4 -d /mnt/test
>>>
>>> XFS: Assertion failed: first<= last&&  last<  BBTOB(bp->b_length),
>>
>> Directory buffer overrun.
>>
>>>   [<ffffffffa031d549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
>>>   [<ffffffffa02e7c1c>] xfs_da3_node_add+0x11c/0x210 [xfs]
>>>   [<ffffffffa02ea703>] xfs_da3_node_split+0xc3/0x230 [xfs]
>>>   [<ffffffffa02eaa18>] xfs_da3_split+0x1a8/0x410 [xfs]
>>>   [<ffffffffa02f743f>] xfs_dir2_node_addname+0x47f/0xde0 [xfs]
>>
>> During a split.
>>
>> Easily reproduced with "seq 200000 | xargs touch" as Michael Semon
>> reported last week.
>>
>> The fix demonstrates my concerns about modifying directory code -
>> the CRC changes missed a *fundamental* directory format definition,
>> and we've only just tripped over it....

I agree. As we see here, bugs in common directory code effect all 
filesystems. It may not matter if the feature the code was written for 
is enabled or not.

>>> rm -rf /mnt/test
>>>
>>> XFS: Assertion failed: first<= last&&  last<  BBTOB(bp->b_length),
>>
>> Directory buffer overrun.
>>
>>>   [<ffffffffa032b549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
>>>   [<ffffffffa02f61ff>] xfs_da3_node_unbalance+0xef/0x1d0 [xfs]
>>>   [<ffffffffa02f98b0>] xfs_da3_join+0x240/0x290 [xfs]
>>>   [<ffffffffa030659b>] xfs_dir2_node_removename+0x69b/0x8b0 [xfs]
>>
>> During a merge. Not sure why that is happening on a v4 filesystem.
>> V5 filesystem, yes, due to the above bug but v4 should not be
>> affected.
>>
>
> Interesting, thanks Dave. FWIW, I no longer reproduce the assert in
> either scenario with this patch applied. I also don't see how it would
> make a difference for a v4 superblock filesystem. Perhaps that
> particular test was bogus. I haven't heard if Mark happened to reproduce
> that one. Regardless, consider it:
>
> Tested-by: Brian Foster<bfoster@redhat.com>
>
> (xfs: fix calculation of the number of node entries in a dir3 node)

I got the XFS v4 to assert on the remove in Linux 3.10 and 3.11.

With the patch, a shorter test on Linux 3.10 did not assert. I will do 
the full test on Linux 3.10/3.11, review and report back.

>
> Brian
>
>> Cheers,
>>
>> Dave.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
