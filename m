Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85FA229E0B
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 13:33:20 -0500 (CDT)
Message-ID: <5241DAEC.8080109@sgi.com>
Date: Tue, 24 Sep 2013 13:33:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix potential memory free issues in
	quota_group_type()
References: <1379832353.4089.10.camel@ThinkPad-T5421>
In-Reply-To: <1379832353.4089.10.camel@ThinkPad-T5421>
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

On 09/22/13 01:45, Li Zhong wrote:
> This patch tries to fix CID 997009 reported by Coverity scan, as
> suggested by sekharan
>
> If getgroups() fails, gids might be malloced, and overwritten with &gid.
> So the free() at the end of the function is trying to free a variable on
> the stack, while the pointer to the allocated memory is lost.
>
> Signed-off-by: Li Zhong<zhong@linux.vnet.ibm.com>
> ---

Looks good to me.

And it seems that dofree would always be true in the following else 
statement.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
