Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QGjsF5242426 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 11:45:54 -0500
Message-ID: <508ABF0E.70800@sgi.com>
Date: Fri, 26 Oct 2012 11:49:18 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests: optionally run all tests under quota
References: <4B71B6E7.1000203@redhat.com>
In-Reply-To: <4B71B6E7.1000203@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 02/09/2010 01:26 PM, Eric Sandeen wrote:
> This patch might be a little heavy handed, but it seems to
> work; if you set USE_QUOTA=1 in your environment, all
> tests should be run with quota on and enabled.
>
> This will hopefully help shake out some of the ext4
> quota problems, although one needs to keep an eye
> on the console to see whether warnings scroll by.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>
> ---
>
>
> diff --git a/common.rc b/common.rc
> index 6424871..4fde921 100644
> --- a/common.rc
> +++ b/common.rc

Looks good

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Eric,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, 
master branch, commit ID edd6bcf9.


Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
