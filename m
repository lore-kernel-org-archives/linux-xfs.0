Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o050orCE160881 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 18:50:53 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61B371C2AD22
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 16:51:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UP4H0V4WRS0QqIlC for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2010 16:51:43 -0800 (PST)
Subject: Re: [PATCH] sort: Introduce generic list_sort function
From: Dave Airlie <airlied@redhat.com>
In-Reply-To: <1262649295-28427-1-git-send-email-david@fromorbit.com>
References: <1262649295-28427-1-git-send-email-david@fromorbit.com>
Date: Tue, 05 Jan 2010 10:48:26 +1000
Message-Id: <1262652506.25818.5.camel@localhost>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>, Adrian Hunter <adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, 2010-01-05 at 10:54 +1100, Dave Chinner wrote:
> There are two copies of list_sort() in the tree already, one in the DRM code,
> another in ubifs. Now XFS needs this as well. Create a generic list_sort()
> function from the ubifs version and convert existing users to it so we
> don't end up with yet another copy in the tree.

Acked-by: Dave Airlie <airlied@redhat.com>

Meant to do this myself when we imported modesetting, but never got
around to it,

Thanks,
Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
