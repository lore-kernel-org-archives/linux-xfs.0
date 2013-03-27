Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 266377F54
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 21:05:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBCE9304067
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 19:05:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZsETWWkVt2kLXExj for <xfs@oss.sgi.com>;
	Tue, 26 Mar 2013 19:05:34 -0700 (PDT)
Date: Wed, 27 Mar 2013 13:05:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests 299-305: remove fio config files after
	finished test
Message-ID: <20130327020532.GP6369@dastard>
References: <1364127266-13325-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364127266-13325-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Sun, Mar 24, 2013 at 08:14:26PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After finished test, temporarily fio config file should be removed.
> Meanwhile in #305 poweron_scratch_dev is removed because no one uses
> it.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Cc: Dave Chinner <david@fromorbit.com>
> ---
>  299 |  9 +++++----
>  300 |  9 +++++----
>  301 |  9 +++++----
>  302 |  9 +++++----
>  303 |  9 +++++----
>  304 |  9 +++++----
>  305 | 11 ++++++-----
>  7 files changed, 36 insertions(+), 29 deletions(-)
>  mode change 100644 => 100755 299
>  mode change 100644 => 100755 300
>  mode change 100644 => 100755 301
>  mode change 100644 => 100755 302
>  mode change 100644 => 100755 303
>  mode change 100644 => 100755 304
>  mode change 100644 => 100755 305

Mode changes should be in a separate patch. And if you are going to
do this, please change all the tests that need this to be done in
one sweep.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
