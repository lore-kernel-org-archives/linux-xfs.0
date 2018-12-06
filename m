Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59124 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbeLFUXQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 15:23:16 -0500
Subject: Re: [PATCH v5 0/5] Try to squash metadump data leaks
References: <20181105213145.7560-1-stefanrin@gmail.com>
 <CAAxjCExC1iysfNx7PE-xd5yRhZiexA3vmoWyHRDb43pFBt8enQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b04b116b-b154-53cc-c4d2-57e7cf22d1ca@sandeen.net>
Date: Thu, 6 Dec 2018 14:23:14 -0600
MIME-Version: 1.0
In-Reply-To: <CAAxjCExC1iysfNx7PE-xd5yRhZiexA3vmoWyHRDb43pFBt8enQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org



On 12/6/18 11:04 AM, Stefan Ring wrote:
> On Mon, Nov 5, 2018 at 10:32 PM Stefan Ring <stefanrin@gmail.com> wrote:
>>
>> Another round... I'm starting to feel quite confident about it this time.
>>
>> Since last time:
>>
>> - Fixed the attribute corruption in the last patch.
>> - Changed the accidental 'a' and 'b' I had left in the code back to zeroes.
>> - Brought the flag for crc recalc a tiny bit more in line with the single_fsb code.
>> - Fixed the wrong control flow in the interim patch which duplicates a TODO comment in the code only to get rid of it in the next patch.
>>
>>
>> Stefan Ring (5):
>>   xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
>>   xfs_metadump: Zap multi fsb blocks
>>   xfs_metadump: Zap freeindex blocks in directory inodes
>>   xfs_metadump: Zap unused space in inode btrees
>>   xfs_metadump: Zap dev inodes
>>
>>  db/metadump.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 113 insertions(+), 15 deletions(-)
> 
> Is this an appropriate time interval for pinging?
> 

Yeah, this is back on my radar today as I try to assemble an xfsprogs-4.20.

Sorry for the delay, and thanks for the work.

-Eric
