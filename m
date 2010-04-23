Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3N2xxFm007610 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 21:59:59 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 102A72E8816
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 20:01:57 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id GFZKX4zOna56PyHx for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 20:01:57 -0700 (PDT)
Date: Fri, 23 Apr 2010 11:00:11 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: is realtime device supported?
Message-ID: <20100423030011.GB2949@laptop.oracle.com>
References: <20100422144939.GA3822@laptop.oracle.com>
	<20100422162325.GA29668@infradead.org> <4BD07F06.70101@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BD07F06.70101@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, greg.marsden@oracle.com, joe.jin@oracle.com, Wengang Wang <wen.gang.wang@oracle.com>

On 10-04-22 11:53, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Thu, Apr 22, 2010 at 10:49:39PM +0800, Wengang Wang wrote:
> >> Do we support realtime device?
> >>
> >> I got the following error:
> > 
> > It sounds like you do not have CONFIG_XFS_RT enable in your kernel
> > configuration.  But to answer your original question the realtime
> > device is not supported in the sense of actively maintained.  The
> > code is still there, but more or less for legacy reasons.  I would
> > not recommend it for new installations.

Yes, CONFIG_XFS_RT is disabled.
[wwg@desk linux-2.6.18.x86_64]$ grep CONFIG_XFS_RT .config
# CONFIG_XFS_RT is not set

And Ok I see. Also should we add the point to man page of mkfs.xfs?

> 
> Agreed.
> 
> FWIW, dmesg probably gave you a more helpful error message than
> mount...
> 
>                 cmn_err(CE_WARN, "XFS: RT mount failed");
> 
> hm or maybe not ;)

Only "XFS: RT mount failed" :)

Thanks all!

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
