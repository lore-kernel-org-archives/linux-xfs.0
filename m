Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E0037F56
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 08:21:02 -0500 (CDT)
Message-ID: <524ACC38.4040909@sgi.com>
Date: Tue, 01 Oct 2013 08:20:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix memory leak in xlog_recover_add_to_trans
References: <20130927140104.515578025@sgi.com> <20130930225306.GS1935@sgi.com>
In-Reply-To: <20130930225306.GS1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 09/30/13 17:53, Ben Myers wrote:
> On Fri, Sep 27, 2013 at 09:00:55AM -0500, tinguely@sgi.com wrote:
>> Free the memory in error path of xlog_recover_add_to_trans().
>> Normally this memory is freed in recovery pass2, but is leaked
>> in the error path.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>
> Applied.



Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1585,6 +1585,7 @@ xlog_recover_add_to_trans(
  		"bad number of regions (%d) in inode log format",
  				  in_f->ilf_size);
  			ASSERT(0);
+			free(ptr);

Sigh. I am a big fat, dunce-hatted, dork. This is the xfsprogs patch. 
The kernel needs kmem_free().

Please pull the patch. I will redo the whole thing to also make sure the 
list is removed on error.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
