Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67IPZIO187883 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 13:25:35 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A17F81E5C94A
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 11:25:34 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id UPR15KNvIx15XEaL for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2011 11:25:34 -0700 (PDT)
Received: from localhost.localdomain (wombat.san-francisco.ca.us
	[75.101.60.64])
	by a.mail.sonic.net (8.13.8.Beta0-Sonic/8.13.7) with ESMTP id
	p67IPXx4032607 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 11:25:33 -0700
Date: Thu, 7 Jul 2011 11:25:32 -0700
From: Keith Keller <kkeller@sonic.net>
Subject: Re: xfs_growfs doesn't resize
Message-ID: <20110707182532.GA31319@sonic.net>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49309.1309992692@sonic.net>
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
To: xfs@oss.sgi.com

Hi all,

First, I hope that this message fixes my mail client breaking threading.

I am sorry for following up my own post (again), but I realized this
morning that there may be another possible risk I had not considered:

On Wed, Jul 06, 2011 at 03:51:32PM -0700, kkeller@sonic.net wrote:
> 
> So, here is my xfs_db output.  This is still on a mounted filesystem.

How safe/risky is it to leave this filesystem mounted and in use?
I'm not too concerned about new data, since it won't be a huge amount,
but I am wondering if data that's already been written may be at risk.
Or, it it a reasonable guess that the kernel is still working completely
with the old filesystem geometry, and so won't write anything beyond the
old limits while it's still mounted?  df certainly seems to use the old
fs size, not the new one.

Thanks again,


--keith


-- 
kkeller@sonic.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
