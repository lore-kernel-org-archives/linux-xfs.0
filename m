Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C8067CA0
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 00:28:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE8EEAC002
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 22:28:41 -0700 (PDT)
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60]) by cuda.sgi.com
	with ESMTP id qAs5nM5C3E32IDNi for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 22:28:38 -0700 (PDT)
Date: Wed, 15 Jun 2016 07:28:31 +0200
From: Willy Tarreau <w@1wt.eu>
Subject: Re: Something badly broken with the latest XFS changeset in all
	stable kernels?
Message-ID: <20160615052831.GA3452@1wt.eu>
References: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
	<20160615000241.GC26977@dastard> <20160615013056.GA23074@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160615013056.GA23074@kroah.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Greg KH <greg@kroah.com>
Cc: "Thomas D." <whissi@whissi.de>, spender@grsecurity.net, stable@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 14, 2016 at 06:30:56PM -0700, Greg KH wrote:
> As the patch was tagged with 3.10+, I assumed that it was safe to be
> merged to those older kernels, otherwise I would never have done so.  We
> do have ways to mark external things like this for stable patches, it's
> a great help when doing backports.

I guess only 3.14.72 was affected in the end. 3.18.35 has the fix but my
understanding is that after 3.17 it's OK. Apparently it's not yet queued
for 3.16. Jiri has queued it for 3.12 but not yet released it. For 3.10
I only pick patches that are already in a 3.14 release so I didn't have
the time to backport it to 3.10 yet as the preview started before the
release. Overall the regression lived only 8 days in a single branch, I
guess it shows that our process works rather well and limits the exposure
to regressions.

Brad, it would have been nice to report it to the stable team especially
since you rely on these kernels for yours as well.

Regards,
Willy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
