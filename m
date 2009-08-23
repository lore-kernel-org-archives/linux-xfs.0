Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7NIHQwv073212 for <xfs@oss.sgi.com>; Sun, 23 Aug 2009 13:17:36 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0CBC1D5EEB0
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2009 11:17:46 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id xThJ9HJiRHUYKzZY for
	<xfs@oss.sgi.com>; Sun, 23 Aug 2009 11:17:46 -0700 (PDT)
Received: from [10.1.1.11] (OSH-NAT-213-122.onshore.net [66.146.213.122])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 86596204544
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2009 18:17:44 +0000 (UTC)
Message-ID: <4A9187C7.9010206@jquigley.com>
Date: Sun, 23 Aug 2009 13:17:43 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with power failure
References: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<4A8C1E6E.8020405@jquigley.com>
In-Reply-To: <4A8C1E6E.8020405@jquigley.com>
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
To: XFS Development <xfs@oss.sgi.com>

John Quigley wrote:
> We've distilled this into a reproducible environment with a stack of NFS + XFS 
> to a local disk + automated sysrq 'b' reboots.  We're working on getting 
> this bundled up into a nice little package as a VirtualBox vm for your 
> consumption.  Please tell me if this is not desirable.

The self-contained and reproducible environment can be downloaded from the following location:

  http://www.jquigley.com/tmp/xfsVM.tar.bz2

That's a ~550 MB (compressed) image that can be 'imported' directly into the latest VirtualBox.  Instructions for setting up the environment (trivial, should take you a mere couple of minutes):

  http://www.jquigley.com/tmp/README.txt

The basic concept here is to use the VM as the file server, accessing the XFS file system thereon through the guest OS which acts as the NFS client.  Automated reboots are effected with cron and sysrq 'b', so you can just set this up and run it until failure.

Hope this helps lend insight - if there are any questions, please ask.  Thanks for your time.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
