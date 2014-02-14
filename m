Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA4307F55
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 06:47:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A1698F8033
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 04:47:02 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id LLGbqZWorwlXYW8r (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 04:47:00 -0800 (PST)
Date: Fri, 14 Feb 2014 13:46:56 +0100
From: David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH v3 0/3] __btrfs_drop_extents() BUG_ON reproducer
Message-ID: <20140214134656.7c1f2544@plati.site>
In-Reply-To: <1391769341-20688-1-git-send-email-ddiss@suse.de>
References: <1391769341-20688-1-git-send-email-ddiss@suse.de>
Mime-Version: 1.0
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
To: linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Ping, any Btrfsers get a chance to look at this patch series?
I'd like to get it into the QA tree.

On Fri,  7 Feb 2014 11:35:38 +0100, David Disseldorp wrote:

> This patch-set provides a reproducer for hitting the 3.14.0-rc1 BUG_ON()
> at:
>  692 int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
> ...
>  839                 /*
>  840                  *  | ---- range to drop ----- |
>  841                  *      | -------- extent -------- |
>  842                  */
>  843                 if (start <= key.offset && end < extent_end) {
>  844                         BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
>  845 
>  846                         memcpy(&new_key, &key, sizeof(new_key));
> 
> The first patch adds a small cloner binary which is used by btrfs/035 to
> dispatch BTRFS_IOC_CLONE_RANGE requests.
> 
> This workload resembles that of Samba's vfs_btrfs module, when a Windows
> client restores a file from a shadow-copy (snapshot) using server-side
> copy requests.
> 
> Changes since V2:
> - Remove explicit write error checks
> 
> Changes since V1:
> - Use strtoull instead of atoi
> - Print error conditions in cloner
> - Check for cloner binary before running test
> - Continue test on failure
> - Add cloner to .gitignore
> 
> Feedback appreciated.
> 
> Cheers, David
> 
> 
>  .gitignore          |   1 +
>  configure.ac        |   1 +
>  src/Makefile        |   2 +-
>  src/cloner.c        | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/035     |  77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/035.out |   3 +++
>  tests/btrfs/group   |   1 +
>  7 files changed, 276 insertions(+), 1 deletion(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
