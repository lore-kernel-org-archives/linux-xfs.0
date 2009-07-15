Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FCMYg3195039
	for <linux-xfs@oss.sgi.com>; Wed, 15 Jul 2009 07:22:35 -0500
Subject: Re: failed assertion related to realtime section
References: <h3gd94$clb$1@ger.gmane.org>
From: Olaf Weber <olaf@sgi.com>
Date: Wed, 15 Jul 2009 14:23:06 +0200
In-Reply-To: <h3gd94$clb$1@ger.gmane.org> (Roman Kononov's message of "Mon,
	13 Jul 2009 17:42:43 -0500")
Message-ID: <bzyzlb6p239.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
To: Roman Kononov <kononov@ftml.net>
Cc: linux-xfs@oss.sgi.com

Roman Kononov writes:

> Hi,
> In 2.6.30.x Linux kernel, the XFS_RT configuration option does not say
> "This feature is unsupported at this time..." any more. Nevertheless,
> when enabled, the feature crashes the file system in my setup. Is it
> expected to be functional?

I don't think a kernel oops is the expected result.

> The attached assertion log happens every time with a clean and empty
> file system.

Can you provide:

 - the options used to create the filesystem
 - the mount options of the filesystem
 - (a summary of) the commands run

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
