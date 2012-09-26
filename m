Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QKIeW9249616 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 15:18:40 -0500
Message-ID: <50636369.4010402@sgi.com>
Date: Wed, 26 Sep 2012 15:19:53 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] xfs: Fix m_agirotor reset during AG selection
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348147961-7520-2-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 09/20/12 08:32, Carlos Maiolino wrote:
> xfs_ialloc_next_ag() currently resets m_agirotor when it is equal to m_maxagi:
>
>           if (++mp->m_agirotor == mp->m_maxagi)
> 	         mp->m_agirotor = 0;
>
> But, if for some reason mp->m_maxagi changes to a lower value than current
> m_agirotor, this condition will never be true, causing m_agirotor to exceed the
> maximum allowed value (m_maxagi).
>
> This implies mainly during lookups for xfs_perag structs in its radix tree,
> since the agno value used for the lookup is based on m_agirotor. An out-of-range
> m_agirotor may cause a lookup failure which in case will return NULL.
>
> As an example, the value of m_maxagi is decreased during inode64->inode32
> remount process, case where I've found this problem.
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
