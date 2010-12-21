Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLAdt3n007006 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 04:39:55 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F9601CE3B30
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 02:41:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vHTl7bDpcwQSlBVC for
	<xfs@oss.sgi.com>; Tue, 21 Dec 2010 02:41:52 -0800 (PST)
Date: Tue, 21 Dec 2010 11:41:42 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Add test 248: Check filesystem FITRIM implementation
In-Reply-To: <20101220174146.GA32680@infradead.org>
Message-ID: <alpine.LFD.2.00.1012211132450.6010@dhcp-lab-213.englab.brq.redhat.com>
References: <1291996407-26251-1-git-send-email-lczerner@redhat.com>
	<20101220174146.GA32680@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, esandeen@redhat.com, xfs@oss.sgi.com

On Mon, 20 Dec 2010, Christoph Hellwig wrote:

> Hi Lukas,
> 
> I've looked over it a bit again, and I can't really comment on the code
> too much, as my bash fu is nowhere near a level to actually make sense
> of most of the testcase.   I have however ran it in a few setups and
> can comment based on that.
> 
> First your current first discard to check if we actually support it is
> not handled correctly.  Running the test on a filesystem that doesn't
> support it currently fails the test for me with:
> 
> @@ -1,3 +1,2 @@
> QA output created by 249
> -Checking FITRIM support: done.
> -Running the test: done.
> +Checking FITRIM support: fstrim: FSTRIM: Inappropriate ioctl for device
> 
> This should be easily fixable by redirecting the output of the test
> command to /dev/null and do a _notrun if it exited with an error value,
> just like other tests that require non-standard behaviour.
> 
> Second using data from /usr/share/doc seems a bit non-deterministic to
> me, as the content will be different on every system.  Any chance you
> could just use the xfstests source code instead?
> 
> Third the testcase runs forever, e.g. 93 minutes in my KVM setup, even
> using a no-op discard implementation.  While this is useful for burn in
> testing having a shorter run time version that can be run automatically
> would be really useful.  I tried to figure out what paramters control
> the runtime, but as mentioned above my bash skill really aren't enough
> to do that.
You can lower the "nproc" variable, optionally you can also lower
"repeat" variable in run_process().



Hi Christoph,

thanks a lot for review. I certainly can use xfstests source code, so
I'll change that. Regarding the duration of the test, it is kind of hard
to determine the right amount of load, because the devices and machines
differs a lot. It also involves a LOT of copying files so I guess it
might be a little slow. However I need to be careful with reducing
number of concurrent processes, because with less stress it might be
harder to hit potential problem. (you can always

But I'll try to test it an find just the right balance. Thanks again.

-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
