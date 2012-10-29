Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TEtSh5173944 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 09:55:28 -0500
Message-ID: <508E99B1.9060209@sgi.com>
Date: Mon, 29 Oct 2012 09:58:57 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests 250: remove unwanted new line in 250.out
References: <1350618284-11708-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1350618284-11708-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 10/18/2012 10:44 PM, Eryu Guan wrote:
> Additional new line at the end of 250.out will fail the test, remove it.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> ---
> 250.out | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/250.out b/250.out
> index 2225d6e..acb042a 100644
> --- a/250.out
> +++ b/250.out
> @@ -12,4 +12,3 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>   *** unmount loop filesystem
>   *** check loop filesystem
>   *** done
> -
>

Eryu,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests 
master branch, commit d1ffc87.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
