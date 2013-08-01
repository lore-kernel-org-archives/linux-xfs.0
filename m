Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A642729DFB
	for <linux-xfs@oss.sgi.com>; Thu,  1 Aug 2013 09:18:47 -0500 (CDT)
Message-ID: <51FA6E47.9030607@sgi.com>
Date: Thu, 01 Aug 2013 09:18:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: avoid double-free in xfs_attr_node_addname
References: <51F9B77E.2030005@redhat.com>
In-Reply-To: <51F9B77E.2030005@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 07/31/13 20:18, Eric Sandeen wrote:
> xfs_attr_node_addname()'s error handling tests whether it
> should free "state" in the out: error handling label:
>
> out:
>          if (state)
>                  xfs_da_state_free(state);
>
> but an earlier free doesn't set state to NULL afterwards; this
> could lead to a double free.  Fix it by setting state to NULL
> after it's freed.
>
> This was found by Coverity.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> Note: Exact same patch should hit xfsprogs - I could send another,
> or maybe SGI can just apply it in both trees?
>
> Thanks,
> -Eric

Looks good. we will discuss the details at PM phone call.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
