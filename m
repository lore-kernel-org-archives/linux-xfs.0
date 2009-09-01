Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81JGMS9201750 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 14:16:33 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45C07418225
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 12:17:14 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id bG3IWaspvvqtWdfm for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 12:17:14 -0700 (PDT)
Received: from [10.1.1.10] (OSH-NAT-213-67.onshore.net [66.146.213.67])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 6F926204052
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 19:17:11 +0000 (UTC)
Message-ID: <4A9D7334.2040500@jquigley.com>
Date: Tue, 01 Sep 2009 14:17:08 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with power failure
References: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	<4A8C1E6E.8020405@jquigley.com>
	<4A9187C7.9010206@jquigley.com>
In-Reply-To: <4A9187C7.9010206@jquigley.com>
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
> John Quigley wrote:
>> We've distilled this into a reproducible environment with a stack of 
>> NFS + XFS to a local disk + automated sysrq 'b' reboots.  We're 
>> working on getting this bundled up into a nice little package as a 
>> VirtualBox vm for your consumption.  Please tell me if this is not 
>> desirable.

By way of an update, the corruption is definitely specific to Linux nfsd access to XFS at time of power failure.  We've be unable to reproduce the problem in any other context except when running IO through NFS to the underlying XFS mount.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
