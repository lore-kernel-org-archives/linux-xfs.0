Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04B597F4E
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 16:34:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA4538F804C
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 14:34:44 -0700 (PDT)
Received: from mail-vb0-f43.google.com (mail-vb0-f43.google.com
	[209.85.212.43]) by cuda.sgi.com with ESMTP id mhsFTFG0LB8yUuKr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Sep 2013 14:34:43 -0700 (PDT)
Received: by mail-vb0-f43.google.com with SMTP id h11so2754720vbh.16
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 14:34:42 -0700 (PDT)
Message-ID: <5240B3F1.4040305@gmail.com>
Date: Mon, 23 Sep 2013 17:34:41 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix node forward in xfs_node_toosmall
References: <20130920220519.585903357@sgi.com>
In-Reply-To: <20130920220519.585903357@sgi.com>
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

On 09/20/2013 06:05 PM, Mark Tinguely wrote:
> Commit f5ea1100 cleans up the disk to host conversions for
> node directory entries, but because a variable is reused in
> xfs_node_toosmall() the next node is not correctly found.
> If the original node is small enough (<= 3/8 of the node size),
> this change may incorrectly cause a node collapse when it should
> not. That will cause an assert in xfstest generic/319:
> 
>    Assertion failed: first <= last && last < BBTOB(bp->b_length),
>    file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569
> 
> Keep the original node header to get the correct forward node.

This works for xfstests generic/319 on 32-bit x86.  The xfstests 
run was okay, with a lockdep in the middle and a crash in xfs/300. 
Neither the lockdep nor the crash could reproduced by running 
individual tests one by one.

generic/319 itself fails only because it couldn't find its 
_cleanup routine.  I'm not sure if I'm using v1 or v2 of 
generic/319.

The kernel is set to the commit just before the latest aio-next 
merge, which is causing severe problems here.  xfsprogs was the 
latest production xfsprogs because my copy of xfstests is having 
trouble checking v4 XFS filesystems otherwise.

Will test xfs_node_toosmall patch v2 once I get home.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
