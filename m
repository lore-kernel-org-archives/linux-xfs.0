Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPGTsoX249893 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 10:29:54 -0600
Received: from realbig.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE28918DE09B
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 08:30:20 -0800 (PST)
Received: from realbig.com (realbig.com [207.36.196.230]) by cuda.sgi.com with
	ESMTP id hQ5se5IsEZd9dH5H for <xfs@oss.sgi.com>;
	Wed, 25 Nov 2009 08:30:20 -0800 (PST)
Date: Wed, 25 Nov 2009 10:30:09 -0600 (CST)
From: Andy Poling <andy@realbig.com>
Subject: RE: XFS support for ARMv5
In-Reply-To: <EE71107DF0D1F24FA2D95041E64AB9E8985A59F31F@IL-MB01.marvell.com>
Message-ID: <alpine.DEB.2.00.0911251025490.28890@andydesk>
References: <14274282.01258546868484.JavaMail.root@wombat>
	<4B041AEE.4040506@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F17F@IL-MB01.marvell.com>
	<4B096C6E.8010508@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F31F@IL-MB01.marvell.com>
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
To: Ofer Heifetz <oferh@marvell.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 23 Nov 2009, Ofer Heifetz wrote:
> Here is the dmesg I got for mount /dev/sda3 /mnt/usb:
> SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> XFS mounting filesystem sda3
> Starting XFS recovery on filesystem: sda3 (logdev: internal)
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed

See this thread in the archives for a patch that may fix this:

 	http://oss.sgi.com/pipermail/xfs/2009-October/042805.html

-Andy

It ain't what you don't know that gets you into trouble.
It's what you know for sure that just ain't so. - Mark Twain

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
