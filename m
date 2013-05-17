Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8462F29E06
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 07:02:28 -0500 (CDT)
Message-ID: <51961C72.4020306@sgi.com>
Date: Fri, 17 May 2013 07:02:58 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 311: fsck the dmflakey device instead of the
	real device V2
References: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com

On 05/15/2013 10:20 AM, Josef Bacik wrote:
> Dave pointed out that xfs was having issues with 311 because of caching issues.
> He suggested that I fsck the dm-flakey device to make sure we don't have this
> problem.  Make _check_scratch_fs take an optional argument to use as the device
> to fsck.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

This has been committed:

commit a8c25f0702254dfd504a6fa9c9db018729ebec53
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Thu May 16 08:48:03 2013 -0500

     xfstests: 311: fsck the dmflakey device instead of the real device

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
