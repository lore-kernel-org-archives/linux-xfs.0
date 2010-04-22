Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGpSLb216700 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:51:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AB2F8AA314
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:53:28 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MdTWB9MPav3AlF4T for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:53:28 -0700 (PDT)
Message-ID: <4BD07F06.70101@sandeen.net>
Date: Thu, 22 Apr 2010 11:53:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: is realtime device supported?
References: <20100422144939.GA3822@laptop.oracle.com>
	<20100422162325.GA29668@infradead.org>
In-Reply-To: <20100422162325.GA29668@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, greg.marsden@oracle.com, joe.jin@oracle.com, Wengang Wang <wen.gang.wang@oracle.com>

Christoph Hellwig wrote:
> On Thu, Apr 22, 2010 at 10:49:39PM +0800, Wengang Wang wrote:
>> Do we support realtime device?
>>
>> I got the following error:
> 
> It sounds like you do not have CONFIG_XFS_RT enable in your kernel
> configuration.  But to answer your original question the realtime
> device is not supported in the sense of actively maintained.  The
> code is still there, but more or less for legacy reasons.  I would
> not recommend it for new installations.

Agreed.

FWIW, dmesg probably gave you a more helpful error message than
mount...

                cmn_err(CE_WARN, "XFS: RT mount failed");

hm or maybe not ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
