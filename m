Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9ED057F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:13:59 -0500 (CDT)
Message-ID: <51938A33.50202@sgi.com>
Date: Wed, 15 May 2013 08:14:27 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests generic 312: test fallocate(2) ENOSPC when
	file size is greater than 4G
References: <1367833355-14473-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1367833355-14473-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 05/06/2013 04:42 AM, Eryu Guan wrote:
> ENOSPC in fallocate(2) could corrupt ext4 when file size > 4G
>
> Regression test for commit
> 29ae07b ext4: Fix overflow caused by missing cast in ext4_fallocate()
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Tested fine for xfs and ext4, Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
