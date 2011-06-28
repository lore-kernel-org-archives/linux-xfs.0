Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SE37Vp229764 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 09:03:07 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A3931E5339B
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 07:03:07 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id 35S5SRLkeZHTXKX8 for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 07:03:07 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5SE00qk003948
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:00:00 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p5SE2huT021536 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:02:45 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5S82fZi015371
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 02:02:41 -0600
Message-ID: <4E09DEEB.7070908@linux.vnet.ibm.com>
Date: Tue, 28 Jun 2011 07:02:19 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 v6] XFS TESTS: ENOSPC Punch Hole: Add new test 255
References: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309239163-3975-3-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1309239163-3975-3-git-send-email-achender@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 06/27/2011 10:32 PM, Allison Henderson wrote:
> This patch adds a new test 255 that tests that a hole can be punched even when the
> disk is full.  Reserved blocks should be used to allow a punch hole to proceed even
> when there is not enough blocks to further fragment the file. To test this, the
> file system is fragmented by punching holes in regular intervals and filling
> the file system between punches. This will eventually force the file system to use
> reserved blocks to proceed with the punch hole operation.
>
> The work in this patch is a continuation from a previous patch set that has been
> partially accepted.
>
> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
> ---
>
> v5->v6
>
> Test moved out of 252 and put in its own test 255
>
> _fill_fs and _test_full_fs_punch have been moved from common.punch
> to test 255 and modified to use the _user_do routines in common.rc
>
> _fill_fs has been optimized to stop once files smaller than a block
> cannot be created.
>
> :100644 100644 1f86075... c045e70... M	group
>   group |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/group b/group
> index 1f86075..c045e70 100644
> --- a/group
> +++ b/group
> @@ -368,3 +368,4 @@ deprecated
>   252 auto quick prealloc
>   253 auto quick
>   254 auto quick
> +255 auto quick


Ah, sorry I obviously messed up the file add here. My apologies for the 
confusion!  Will resend this one.

Allison

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
