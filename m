Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D88377F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 07:19:59 -0500 (CDT)
Message-ID: <51962091.1090307@sgi.com>
Date: Fri, 17 May 2013 07:20:33 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: check falloc in 285
References: <1368351729-17778-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368351729-17778-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 05/12/2013 04:42 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> As linux 3.8, ext4 has supported the seek data/hole operation for
> extent-based file and indirect-based file.  But for indirect-based file
> it can not support the fallocate(2).  This causes test 285 to fail since
> it assumes that all file systems which supports seek data/hole also
> support fallocate.  So here we need to check it.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Zheng, this has been committed:

commit fd0afdb443cae47a3963dd8a23fd9785f1f4aebc
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Thu May 16 08:49:03 2013 -0500

     xfstests: check falloc in 285

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
