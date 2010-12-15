Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBFN2llX247140 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 17:02:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5296A1F5FD6
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 15:04:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	fF72Po2IrNzDEDJV for <xfs@oss.sgi.com>;
	Wed, 15 Dec 2010 15:04:39 -0800 (PST)
Date: Thu, 16 Dec 2010 10:04:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS in LINUX embedded environment
Message-ID: <20101215230421.GI9925@dastard>
References: <6385EF5E30011E42B75895D851412B2A64BB14EFEA@ILMA1.IL.NDS.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6385EF5E30011E42B75895D851412B2A64BB14EFEA@ILMA1.IL.NDS.COM>
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
To: "Zak, Semion" <SZak@nds.com>
Cc: XTV FS Group <XTVFSGroup@nds.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Dec 15, 2010 at 05:39:03PM +0200, Zak, Semion wrote:
> Hi,
> I try to use XFS in LINUX embedded environment, without virtual memory.

Can you describe your platform and environment for us? Does
"without virtual memory" mean you are using a uclinux variant? Or
does it mean you are simply not using any swap?

> In one of the tests I got "Out of memory" error.

Can you provide the test case and details of the OOM error?

> My question is:
> 
> Is it possible to bound or decrease memory use by XFS?

Not directly - same as every other linux filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
