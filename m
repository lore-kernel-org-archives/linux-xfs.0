Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7FD267F37
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 11:26:55 -0500 (CDT)
Message-ID: <5239D44E.2090408@sgi.com>
Date: Wed, 18 Sep 2013 11:26:54 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix potential memory leak in repare/sb.c
References: <1379497242.5874.7.camel@ThinkPad-T5421>
In-Reply-To: <1379497242.5874.7.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On 09/18/13 04:40, Li Zhong wrote:
> Following Resource leak is reported by coverity:
>
> CID 997011 (#1 of 1): Resource leak (RESOURCE_LEAK)6. leaked_storage:
> Variable "buf" going out of scope leaks the storage it points to.
> 505                return(XR_EOF);
>
> Add a free(buf) to solve it.
>
> Signed-off-by: Li Zhong<zhong@linux.vnet.ibm.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
