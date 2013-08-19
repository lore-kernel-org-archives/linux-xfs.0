Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6619A7F82
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 11:05:54 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3D24AC007
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 09:05:50 -0700 (PDT)
Message-ID: <5212428C.6040305@sgi.com>
Date: Mon, 19 Aug 2013 11:06:36 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] v2 xfsprogs: fix inode crash in xfs_repair
References: <20130816181254.285296783@sgi.com>
In-Reply-To: <20130816181254.285296783@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Thanks for the patch Mark, it has been committed.

--Rich

commit 3ac87fbf6ac29494dc46134323733551aac1737c
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Fri Aug 16 18:12:43 2013 +0000

     xfsprogs: fix inode crash in xfs_repair

     Adding the lost+found in phase 6 could allocate an inode from
     a new inode chunk. Since this chunk was not around in phase 3
     when the inode chunks are verificated and added to the avl tree,
     the avl tree look up will return a NULL pointer. This results
     in a NULL defererence and segmentation fault.

     Add the newly created inode chunk as if found in the chunk
     verification phase.

     Signed-off-by: Mark Tinguely <tinguely@sgi.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
