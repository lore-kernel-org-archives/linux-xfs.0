Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1FA47FB2
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 17:48:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B184F8F8054
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 15:48:10 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id ApptGYKOPP4kPsuQ
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 15:48:09 -0800 (PST)
Message-ID: <52E1AA35.4050803@fb.com>
Date: Thu, 23 Jan 2014 18:48:05 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: add test for btrfs incremental send infinite
	loop issue
References: <1390348610-8098-1-git-send-email-fdmanana@gmail.com>
	<1390520280-19282-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390520280-19282-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org


On 01/23/2014 06:38 PM, Filipe David Borba Manana wrote:
> Regression test for btrfs' incremental send feature:
>
> 1) Create several nested directories;
>
> 2) Create a read only snapshot;
>
> 3) Change the parentship of some of the deepest directories in a reverse
>     way, so that parents become children and children become parents;
>
> 4) Create another read only snapshot and use it for an incremental send
>     relative to the first snapshot.
>
> At step 4 btrfs' send entered an infinite loop, increasing the memory it
> used while building path strings until a krealloc was unable to allocate
> more memory, which caused a warning dump in dmesg.
>
> The following linux kernel patch fixes this issue.
>
>     Btrfs: fix infinite path build loops in incremental send
>     (https://patchwork.kernel.org/patch/3522361/)
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
