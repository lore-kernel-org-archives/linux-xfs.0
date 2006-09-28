Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Sep 2006 08:59:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8SFxgaG012355
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 08:59:43 -0700
Received: from smtp113.sbc.mail.mud.yahoo.com (smtp113.sbc.mail.mud.yahoo.com [68.142.198.212])
	by cuda.sgi.com (Spam Firewall) with SMTP id 8B53B463390
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 08:59:04 -0700 (PDT)
Date: Thu, 28 Sep 2006 08:32:18 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: LVM and XFS cannot set blocksize on block device
Message-ID: <20060928153218.GA26366@tuatara.stupidest.org>
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu> <20060926224053.GA31542@tuatara.stupidest.org> <451A669D.9020503@agami.com> <451BA2AF.9090703@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <451BA2AF.9090703@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: Shailendra Tripathi <stripathi@agami.com>, Rene Salmon <rsalmon@tulane.edu>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Thu, Sep 28, 2006 at 08:23:43PM +1000, Tim Shimmin wrote:

> I'll have a look soon at passing the mkfs.xfs -s option thru to
> libxfs which is consistent with the existing code.

(following up on something mentioned off the list)

When you do this change please consider *not* making the code fallback
to a different blocksize if the ioctl fails when "-s size=" is given.

The logic here is that if someone clearly wants a specific value and
if that cannot be met it should error out with a suitable message, not
silently do something else.
