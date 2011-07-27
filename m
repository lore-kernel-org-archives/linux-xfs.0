Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RJZ3Xf217906 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 14:35:03 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17971182AD80
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 12:35:01 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id HHnLH7q2SA5VeqF8 for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 12:35:01 -0700 (PDT)
Date: Wed, 27 Jul 2011 15:35:01 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <20110727181111.GA23009@infradead.org>
Message-ID: <alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Wed, 27 Jul 2011, Christoph Hellwig wrote:

> Justin,
>
> can you please run the attached test program on the affected directory
> on the server, and see if you see duplicates in the d_off colum.  Unless
> you have privacy concerns I would also love to see the full output.
>
>

Hi,

Done:

atom:/d1/motion/cam1# /root/getdents  > /tmp/cam1-out.txt
atom:/d1/motion/cam1# cd ../cam2
atom:/d1/motion/cam2# /root/getdents  > /tmp/cam2-out.txt
atom:/d1/motion/cam2# cd ../cam3
atom:/d1/motion/cam3# /root/getdents  > /tmp/cam3-out.txt
atom:/d1/motion/cam3#

Files:
http://home.comcast.net/~jpiszcz/20110727/cam1-out.txt
http://home.comcast.net/~jpiszcz/20110727/cam2-out.txt
http://home.comcast.net/~jpiszcz/20110727/cam3-out.txt

Currently I do not see any dupes, however I have a script that moves 
images out of the directory once an hour:
0 * * * * /usr/local/bin/move_to_old2.sh > /dev/null 2>&1

I'll disable that for now and see if this recurs, if it does, I'll gather 
additional output and send it out, thanks.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
