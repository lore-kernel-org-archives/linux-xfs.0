Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84C3F7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:15:45 -0500 (CDT)
Message-ID: <51938A9F.9050206@sgi.com>
Date: Wed, 15 May 2013 08:16:15 -0500
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
> ---
>

This patch has been committed:

commit 355beacfaf705294b119a3da372512589ff893e9
Author: Eryu Guan <eguan@redhat.com>
Date:   Wed May 15 07:48:41 2013 -0500

     ENOSPC in fallocate(2) could corrupt ext4 when file size > 4G

     Regression test for commit
     29ae07b ext4: Fix overflow caused by missing cast in ext4_fallocate()

     Signed-off-by: Eryu Guan <eguan@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
