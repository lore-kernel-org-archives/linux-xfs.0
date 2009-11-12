Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAC0MpE2198263 for <xfs@oss.sgi.com>; Wed, 11 Nov 2009 18:22:51 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99B2E1860184
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2009 16:23:09 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 7kY3G8IeRX4r7QRO for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2009 16:23:09 -0800 (PST)
Date: Thu, 12 Nov 2009 11:23:03 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1047569616.363721257985383289.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <200911120029.21845@zmi.at>
Subject: Re: xfs_repair question: "wrong" order of AG checks OK?
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com


----- "Michael Monnerie" <michael.monnerie@is.it-management.at> wrote:

> On Mittwoch 11 November 2009 Nathan Scott wrote:
> > Could be xfs_repair running with multiple threads in parallel?
> 
> Would it ever do that? There's no performance advantage in that, as
> that operation is disk I/O bound, isn't it?

Be worth reading the paper here:

http://xfs.org/index.php/XFS_Papers_and_Documentation
   -> "Fixing XFS Filesystems Faster"

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
