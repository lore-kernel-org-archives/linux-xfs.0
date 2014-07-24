Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B72C7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 13:38:12 -0500 (CDT)
Message-ID: <53D1528F.5090906@sgi.com>
Date: Thu, 24 Jul 2014 13:38:07 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/18] xfs: define sparse inode chunks v5 sb feature bit
	and helper function
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-4-git-send-email-bfoster@redhat.com>
	<53D13D94.9030607@sgi.com> <20140724173701.GD37832@bfoster.bfoster>
In-Reply-To: <20140724173701.GD37832@bfoster.bfoster>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 07/24/14 12:37, Brian Foster wrote:
> On Thu, Jul 24, 2014 at 12:08:36PM -0500, Mark Tinguely wrote:
>> On 07/24/14 09:22, Brian Foster wrote:
>>> The sparse inode chunks feature will use the helper function to enable
>>> the allocation of sparse inode chunks. The incompatible feature bit is
>>> set on disk once a sparse inode chunk is allocated to prevent older
>>> drivers from mounting an fs with sparse chunks.
>>>
>>> Note that the feature is hardcoded disabled and the feature bit not
>>> included in the all features mask until fully implemented.
>>>
>>> Signed-off-by: Brian Foster<bfoster@redhat.com>
>>> ---
>>
>> Sorry if I missed it in the series but is there an
>> XFS_FSOP_GEOM_FLAGS_SPINODES for xfs_info/growfs?
>>
>
> Nope, looks like I missed it. It probably slipped my mind as I haven't
> got into userspace yet and thus hadn't thought about xfs_info. I'll make
> a note to add it, thanks!
>
> Brian

Again forgive my quick scanning of the series, but am I correct in 
thinking that this does not change the minimum number of reserved blocks 
for create like fs ops. The create/rename do some attempts to continue 
when it cannot get the full number of reserved blocks. Would allocating 
a sparse inode chunk make sense in that case? My gut says the 
complication does not.

Thanks again,

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
