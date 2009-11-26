Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAQENhdg062297 for <xfs@oss.sgi.com>; Thu, 26 Nov 2009 08:23:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDB0FB7CC8
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2009 06:24:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7BekJvYo6RivbAIk for
	<xfs@oss.sgi.com>; Thu, 26 Nov 2009 06:24:10 -0800 (PST)
Date: Thu, 26 Nov 2009 09:24:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS support for ARMv5
Message-ID: <20091126142408.GA16517@infradead.org>
References: <14274282.01258546868484.JavaMail.root@wombat>
	<4B041AEE.4040506@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F17F@IL-MB01.marvell.com>
	<4B096C6E.8010508@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F31F@IL-MB01.marvell.com>
	<alpine.DEB.2.00.0911251025490.28890@andydesk>
	<20091125210611.GA12150@infradead.org>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F895@IL-MB01.marvell.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <EE71107DF0D1F24FA2D95041E64AB9E8985A59F895@IL-MB01.marvell.com>
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
To: Ofer Heifetz <oferh@marvell.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andy Poling <andy@realbig.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 26, 2009 at 04:19:39PM +0200, Ofer Heifetz wrote:
> Hi Christoph,
> 
> I applied the patches to 2.6.31.6 and the mount passes file. I copied some data to the XFS DOK and had no problem reading the content after several system reset.
> 
> Here is a dmesg snippet:
> 
> SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> XFS mounting filesystem sda3
> Starting XFS recovery on filesystem: sda3 (logdev: internal)
> Ending XFS recovery on filesystem: sda3 (logdev: internal)
> 
> Is this patch confirmed to be mainlined in 2.6.33?
> I need to know `cos I want to run some data integrity and performance tests on this patch before I merge it.

There's no way to 100% confirm it until it's done, but it's firmly
planned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
