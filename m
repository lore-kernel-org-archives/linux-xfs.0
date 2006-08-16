Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 12:02:29 -0700 (PDT)
Received: from 217-133-29-81.b2b.tiscali.it (217-133-29-81.b2b.tiscali.it [217.133.29.81])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7GJ2HDW017941
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 12:02:17 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by 217-133-29-81.b2b.tiscali.it (Postfix) with ESMTP id 398318012F
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 20:06:11 +0200 (CEST)
Received: from 217-133-29-81.b2b.tiscali.it ([127.0.0.1])
	by localhost (solstizio.toel.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 18308-09 for <xfs@oss.sgi.com>;
	Wed, 16 Aug 2006 20:06:08 +0200 (CEST)
Received: from [10.0.11.232] (unknown [10.0.2.114])
	by 217-133-29-81.b2b.tiscali.it (Postfix) with ESMTP id 42AA08012E
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 20:06:08 +0200 (CEST)
From: "Daniele P." <daniele@interline.it>
Subject: Re: xfsdump -s unacceptable performances
Date: Wed, 16 Aug 2006 20:05:39 +0200
References: <200608161515.00543.daniele@interline.it> <44E349EE.6080905@sgi.com>
In-Reply-To: <44E349EE.6080905@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200608162005.40112.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wednesday 16 August 2006 18:38, Bill Kendall wrote:

Hi Bill,
Thanks for the explanations. I only have had a glimpse into the sources.

> And of course there's another scan for dumping the non-dir inodes.
> Keep in mind these are inode scans, which are substantially faster
> than recursing through the directories doing individual stat(2) calls.

Yes, but scanning 10.000.000 inodes when you really need to scan only 4 it's
really a waste of resource.
This is a corner case. But usually I want to backup only 10% of the entire
filesystem.
At this point I have to redesign my backup strategy taking care of
xfsdump strength and weakness.

> Nonetheless, these scans could be optimized by seeking the scan to
> the next inode of interest, which could be found using xfsdump's inomap
> (created in the first scan). This would be beneficial to -s and
> incremental dumps.

That's interesting.

> > Are all there scan really necessary?
>
> A lot of this stuff could be done in a single scan in a disk-to-disk
> backup approach. But in the current scheme, they are necessary.
>
> > Could we expect a performance fix?
> > Is there a workaround?
>
> Nothing is planned, but patches are always welcome.

This too, but for me the xfs filesystem it's a big black box.

Thanks again,
Daniele
