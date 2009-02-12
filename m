Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CLnxT5087014 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 15:49:59 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AF07118E6B
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:49:22 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	GWSmlQYKmHtuYckt for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 13:49:22 -0800 (PST)
Date: Fri, 13 Feb 2009 08:49:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
Message-ID: <20090212214916.GS8830@disturbed>
References: <407126.80177.qm@web30205.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <407126.80177.qm@web30205.mail.mud.yahoo.com>
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
To: raksac@yahoo.com
Cc: xfs@oss.sgi.com

On Tue, Feb 10, 2009 at 11:16:25PM -0800, raksac@yahoo.com wrote:
> 
> Hello,
> 
> I am running the 2.6.28 based xfs kernel driver on a
> custom kernel with following kernel config enabled.
> 
> CONFIG_PREEMPT
> CONFIG_DETECT_SOFTLOCKUP
> 
> Running the following xfsqa causes a soft lockup. The
> configuration is a x86 with Hyperthreading, 4GB RAM
> and a AHCI connected JBOD. Its 100% reproducible.

Is the system making progress, or has it hung? i.e. does the test
complete?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
