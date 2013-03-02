Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 646717FF6
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 19:49:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B30C304032
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 17:49:13 -0800 (PST)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
	[209.85.217.177]) by cuda.sgi.com with ESMTP id
	SIrKRx3GUjef5CKZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 17:49:11 -0800 (PST)
Received: by mail-lb0-f177.google.com with SMTP id go11so2635803lbb.8
	for <xfs@oss.sgi.com>; Fri, 01 Mar 2013 17:49:10 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 10/10] xfstests: add disk failure simulation test
In-Reply-To: <51310B63.4070105@sgi.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-11-git-send-email-dmonakhov@openvz.org>
	<51310B63.4070105@sgi.com>
Date: Sat, 02 Mar 2013 05:49:07 +0400
Message-ID: <87621ah8q4.fsf@openvz.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Fri, 1 Mar 2013 14:11:15 -0600, Rich Johnston <rjohnston@sgi.com> wrote:
> On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> > There are many situations where disk may fail for example
> > 1) brutal usb dongle unplug
> > 2) iscsi (or any other netbdev) failure due to network issues
> > In this situation filesystem which use this blockdevice is
> > expected to fail(force RO remount, abort, etc) but whole system
> > should still be operational. In other words:
> > 1) Kernel should not panic
> > 2) Memory should not leak
> > 3) Data integrity operations (sync,fsync,fdatasync, directio) should fail
> >     for affected filesystem
> > 4) It should be possible to umount broken filesystem
> >
> > Later when disk becomes available again we expect(only for journaled filesystems):
> > 5) It will be possible to mount filesystem w/o explicit fsck (in order to caught
> 
> typo                                     s/caught/catch/g
> 
> >     issues like https://patchwork.kernel.org/patch/1983981/)
> > 6) Filesystem should be operational
> > 7) After mount/umount has being done all errors should be fixed so fsck should
> >     not spot any issues.
> >
> > This test use fault enjection (CONFIG_FAIL_MAKE_REQUEST=y config option )
>    May want to mention all the kernel config options required.
> i.e. CONFIG_FAULT_INJECTION=y ... are there others?
> CONFIG_FAULT_INJECTION_DEBUG_FS=y ???
Yes, all three options are required. 
> 
> > which force all new IO requests to fail for a given device. Xfs already has
>    to force
> 
> > XFS_IOC_GOINGDOWN ioctl which provides similar behaviour, but it is fs speciffic
> 
> typos s/behaviour/behavior/g  s/speciffic/specific
>                                          > and it does it in an easy way 
> because it perform freeze_bdev() before actual
> > shotdown.
> typo s/shotdown/shutdown/g
Agree with your diagnosis. My gramma is bad and I've forget to call spell check
before submission. Should I resend this one or you fix it manually
on commit time?
> 
> >
> > Test run fsstress in background and then force disk failure.
> > Once disk failed it check that (1)-(4) is true.
>    Once the disk fails, check that (1)-(4) are true.
> 
> > Then makes disk available again and check that (5)-(7) is also true
>         make the disk ...                                 are
> >
> > BE CAREFUL!! test known to cause memory corruption for XFS
> > see: https://gist.github.com/dmonakhov/4953045
> >
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
