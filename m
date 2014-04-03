Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C38A27FC5
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 17:19:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B70C2304066
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 15:19:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id eWpWrGAONWTkakey for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 15:19:22 -0700 (PDT)
Message-ID: <533DDE79.9050207@sandeen.net>
Date: Thu, 03 Apr 2014 16:19:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remove unused transaction pointer args
References: <53362976.3060101@sandeen.net>
	<20140331130932.GA63718@bfoster.bfoster>
In-Reply-To: <20140331130932.GA63718@bfoster.bfoster>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/31/14, 7:09 AM, Brian Foster wrote:
> On Fri, Mar 28, 2014 at 09:01:26PM -0500, Eric Sandeen wrote:
>> Several functions pass a transaction pointer around,
>> but it's never used in those callchains.  Remove it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
>> index 152543c..b308097 100644
>> --- a/fs/xfs/xfs_bmap.c
>> +++ b/fs/xfs/xfs_bmap.c
>> @@ -1675,7 +1675,6 @@ xfs_bmap_isaeof(
>>   */
>>  int
>>  xfs_bmap_last_offset(
>> -	struct xfs_trans	*tp,
>>  	struct xfs_inode	*ip,
>>  	xfs_fileoff_t		*last_block,
>>  	int			whichfork)
> 
> Seems Ok to me, but it looks like you could also kill the tp param for
> xfs_bmap_last_extent(). I don't see any callers that don't pass NULL...
> 
> Brian

Actually I think that'd be a separate change, and not totally obvious
that it's one we should make - I'm (lazily) not sure if someone might
need to pass in a tp to be used in xfs_iread_extents() some time
in the future...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
