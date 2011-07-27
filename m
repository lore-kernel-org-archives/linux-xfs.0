Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RJiM46218194 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 14:44:22 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 874091514796
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 12:44:32 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id z0m8royKXT1LFoRy for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 12:44:32 -0700 (PDT)
Date: Wed, 27 Jul 2011 15:44:20 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <20110727193937.GA5354@infradead.org>
Message-ID: <alpine.DEB.2.02.1107271540100.1451@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
	<alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
	<20110727193937.GA5354@infradead.org>
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

> On Wed, Jul 27, 2011 at 03:35:01PM -0400, Justin Piszcz wrote:
>> Currently I do not see any dupes, however I have a script that moves
>> images out of the directory once an hour:
>> 0 * * * * /usr/local/bin/move_to_old2.sh > /dev/null 2>&1
>
> Do you keep adding files to the directory while you move files out?
Yes, otherwise there are too many files in the directory and viewers, e.g.,
each geeqie (picture viewer) will use > 4-6GB of memory, so I try to keep
it around 5,000 pictures or less.

> What's the rate of additions/removals to the directory?
Additions it depends, around 5,000 over a 12hr period, 416/hr, current:

atom:/d1/motion# find cam1|wc
    5215    5215  166853
atom:/d1/motion# find cam2|wc
    5069    5069  162181
atom:/d1/motion# find cam3|wc
    5594    5594  178981
atom:/d1/motion#

>
> If we add files to the directory while removing others we could easily
> re-use the same offset for a different file.
>

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
