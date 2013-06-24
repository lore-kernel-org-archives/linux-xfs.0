Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E3F27F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 22:33:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 699B7304032
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:33:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id otbdPEEgBs3rFPAB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 20:33:58 -0700 (PDT)
Message-ID: <51C7BE28.3050107@oracle.com>
Date: Mon, 24 Jun 2013 11:34:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Remove dead function prototype xfs_sync_inode_grab()
References: <51C4577B.2080208@oracle.com> <20130623231457.GE29376@dastard>
In-Reply-To: <20130623231457.GE29376@dastard>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 06/24/2013 07:14 AM, Dave Chinner wrote:

> On Fri, Jun 21, 2013 at 09:39:07PM +0800, Jeff Liu wrote:
>> rom: Jie Liu <jeff.liu@oracle.com>
> 
> From?

Ah, will repost it as well.

Thanks,
-Jeff

> 
>>
>> Remove dead function prototype xfs_sync_inode_grab() from
>> xfs_icache.h.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_icache.h |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
>> index e0f138c..a01afbb 100644
>> --- a/fs/xfs/xfs_icache.h
>> +++ b/fs/xfs/xfs_icache.h
>> @@ -40,7 +40,6 @@ void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
>>  int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
>>  void xfs_eofblocks_worker(struct work_struct *);
>>  
>> -int xfs_sync_inode_grab(struct xfs_inode *ip);
>>  int xfs_inode_ag_iterator(struct xfs_mount *mp,
>>  	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag,
>>  		int flags, void *args),
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
