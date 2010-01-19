Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J13lec143936 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 19:03:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F6A211F8D1E
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 17:04:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	mk8S1cyHOYwNDQry for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 17:04:46 -0800 (PST)
Date: Tue, 19 Jan 2010 12:04:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: don't warn about topology when mkfsing a file
Message-ID: <20100119010443.GK7264@discord.disaster>
References: <4B54B4D1.7020500@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B54B4D1.7020500@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 18, 2010 at 01:21:53PM -0600, Eric Sandeen wrote:
> Some tests were failing for me like:
> 
>  QA output created by 206
>  === truncate file ===
>  === mkfs.xfs ===
> +warning: unable to probe device toplology for device /mnt/test/fsfile.21615
> ...
> 
> I thought about filtering the tests, but ...
> 
> It seems that we shouldn't even be trying to get topology for a
> plain file, should we?  And then we won't warn about failure.
> 
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Sound pretty sane to me.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
