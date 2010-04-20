Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KFPCwP045797 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 10:25:13 -0500
Received: from mail-ew0-f223.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2569E15445BA
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 08:27:11 -0700 (PDT)
Received: from mail-ew0-f223.google.com (mail-ew0-f223.google.com
	[209.85.219.223]) by cuda.sgi.com with ESMTP id
	jo23hSZpVXr32JTy for <xfs@oss.sgi.com>;
	Tue, 20 Apr 2010 08:27:11 -0700 (PDT)
Received: by ewy23 with SMTP id 23so3629745ewy.34
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 08:27:10 -0700 (PDT)
Date: Tue, 20 Apr 2010 17:27:06 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: do we support using a file as logdev?
Message-ID: <20100420152706.GA4548@teal.hq.k1024.org>
References: <20100420143656.GA3634@laptop.oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420143656.GA3634@laptop.oracle.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, xfs@oss.sgi.com

On Tue, Apr 20, 2010 at 10:36:56PM +0800, Wengang Wang wrote:
> Hi experts,
> 
> Do we support using a file as log device?
> If no, it's strange that we support running xfs on a file but don't support log
> file.

Have you tried using losetup and passing the loop device instead?

regards,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
