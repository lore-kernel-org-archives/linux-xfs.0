Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 98E417F4E
	for <linux-xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:36:14 -0500 (CDT)
Message-ID: <523A0EBD.2060705@sgi.com>
Date: Wed, 18 Sep 2013 15:36:13 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: initialize filetype for xfs_name_dot
References: <523889DB.1000001@redhat.com>
In-Reply-To: <523889DB.1000001@redhat.com>
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

On 09/17/13 11:56, Eric Sandeen wrote:
> If we add the '.' entry in repair, make sure it has a file type
> initialized.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

This looks good.

looks like shared code xfs_dir_lookup() returns the ci match in a 
xfs_name without a file type. Not used now, but may be handy.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
