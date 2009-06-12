Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C8bBmk196924 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 03:37:11 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC7921276081
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 01:44:53 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id zwvEvFeDSMZvIrQZ for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2009 01:44:53 -0700 (PDT)
Date: Fri, 12 Jun 2009 04:37:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many
 processes
In-Reply-To: <96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com>
Message-ID: <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
	<alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
	<4A313F84.20900@sandeen.net>
	<96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com>
MIME-Version: 1.0
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Thu, 11 Jun 2009, Felix Blyakher wrote:

>
> On Jun 11, 2009, at 12:31 PM, Eric Sandeen wrote:
>
>> Justin Piszcz wrote:
>>> 
>>> On Thu, 11 Jun 2009, Justin Piszcz wrote:
>>> 
> The following should fix it:
>
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 4b0f6ef..7928b99 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -6086,6 +6086,7 @@ xfs_getbmap(
>                      break;
>      }
>
> +       kmem_free(out);
>      return error;
> }
>
>
> Felix

Just FYI if anyone tries to run the patch it will not work:

# patch -p1 < ../xfs.patch 
patching file fs/xfs/xfs_bmap.c
patch: **** malformed patch at line 11: }

So just goto line ~6086 and add the kmem_free(out); above the return 
error.

Status:
This patch fixes the problem, thanks!

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
