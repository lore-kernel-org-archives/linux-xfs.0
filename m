Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 06EFD7F66
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:51:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68D89AC003
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 18:51:01 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2y60icDUo2U3F6ro (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 18:51:00 -0700 (PDT)
Message-ID: <53683FFE.2080909@oracle.com>
Date: Tue, 06 May 2014 09:50:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] xfsprogs: get rid of XFS_IALLOC_BLOCKS macros
References: <536784CD.60900@oracle.com> <20140505211009.GD13973@laptop.bfoster>
In-Reply-To: <20140505211009.GD13973@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 05/06 2014 05:10 AM, Brian Foster wrote:
> On Mon, May 05, 2014 at 08:32:13PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Get rid of XFS_IALLOC_BLOCKS() macros, use mp->m_ialloc_blks directly.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  db/check.c                |  2 +-
>>  db/frag.c                 |  2 +-
>>  db/metadump.c             |  2 +-
>>  include/xfs_ialloc.h      |  5 -----
>>  include/xfs_trans_space.h |  2 +-
>>  libxfs/xfs_ialloc.c       |  8 ++++----
>>  libxfs/xfs_trans_resv.c   |  8 ++++----
>>  mkfs/proto.c              |  2 +-
>>  repair/dino_chunks.c      | 24 ++++++++++++------------
>>  repair/prefetch.c         |  2 +-
>>  repair/xfs_repair.c       |  4 ++--
>>  11 files changed, 28 insertions(+), 33 deletions(-)
>>
<snip>

>> diff --git a/mkfs/proto.c b/mkfs/proto.c
>> index 5a47e27..2689f75 100644
>> --- a/mkfs/proto.c
>> +++ b/mkfs/proto.c
>> @@ -39,7 +39,7 @@ static long filesize(int fd);
>>   * (basically no fragmentation).
>>   */
>>  #define	MKFS_BLOCKRES_INODE	\
>> -	((uint)(XFS_IALLOC_BLOCKS(mp) + ((mp)->m_in_maxlevels - 1)))
>> +	((uint)(mp->m_ialloc_blks + ((mp)->m_in_maxlevels - 1)))
> Nit:		(mp) 
> 
> Probably not necessary here anyways...

Nice catch, thanks for your review.


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
