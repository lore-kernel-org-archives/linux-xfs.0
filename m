Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OIbrTT141534 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 13:38:03 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AD7215227DC
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 11:38:37 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id C2l4tS63O11gLJx2 for
	<xfs@oss.sgi.com>; Mon, 24 Aug 2009 11:38:37 -0700 (PDT)
Message-ID: <4A92DE02.5050303@tlinx.org>
Date: Mon, 24 Aug 2009 11:37:54 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Changing a file system from case sensitive to case	insensitive...
References: <4A928413.4050205@tlinx.org> <20090824144904.GB20898@infradead.org>
	<4A92C43B.1060604@tlinx.org> <20090824174134.GA25187@infradead.org>
In-Reply-To: <20090824174134.GA25187@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>



Christoph Hellwig wrote:
> foreach diretory {
> 	read the whole directory structure into memory
> 	rewrite the btree with the case insensitive hash
> }
---
	Looks like a trivial shell script...;^)...

I'm sure there's a bash-app for that...

*sigh*

And here I thought it was as simple as setting a flag on disk.

Sounds like the implementation lends itself to having an extended-attr
to potentially set the option on a dir-by-dir basis 
similar to the +d bit, though it would only apply to dirs and files
within -- but not subdirs (due to different mount locations)?

That might certainly be more flexible than a whole disk as well if it
is practical.

Then as the 'attr' was set, the hash could be rebuilt either inplace,
or created as a newdir with files being moved to the new dir.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
