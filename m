Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E13467F5A
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:45:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0B44304048
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 12:45:07 -0800 (PST)
Message-ID: <512BCDE3.5060907@redhat.com>
Date: Mon, 25 Feb 2013 15:47:31 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/6] speculative preallocation quota throttling
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
	<512BC90A.4090206@sgi.com>
In-Reply-To: <512BC90A.4090206@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

[CC list]

On 02/25/2013 03:26 PM, Mark Tinguely wrote:
> On 02/20/13 09:10, Brian Foster wrote:
>> Hi all,
>>
>> Here is v4 of the speculative preallocation quota throttling set.
>> Patch 3 of v3
>> is dropped due to a redundancy and a few changes are made to the
>> threshold
>> management code (patch 4/6). The remaining patches are unchanged from v3.
>>
>> Brian
>>
...
>>
> 
> Since you are doing a v5 repost, you can clean up the typedefs in the
> routines that you touch:
> 

Sure, I'll make a pass through the set for such clean ups.

Brian

> For example in patch 3:
> 
> 
>         xfs_quotainfo_t         *q = mp->m_quotainfo;
> +       xfs_disk_dquot_t        *d = &dq->q_core;
>         ^^^^^^^^^
>     struct xfs_disk_dquot    d = &dq->q_core;
> ---
> patch 4:
> 
> xfs_disk_dquot_t
> 
>         xfs_quotainfo_t         *q = mp->m_quotainfo;
>         xfs_disk_dquot_t        *d = &dq->q_core;
> +       int                     prealloc = 0;
> 
> clean up the xfs_quotainfo_t and xfs_disk_dquot_t
> 
> --Mark.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
