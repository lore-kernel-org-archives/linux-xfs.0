Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8BGl270200919 for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 11:47:02 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B8EB153388
	for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 09:47:00 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id qaZEJ2EKFSjZCXs9
	for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 09:47:00 -0700 (PDT)
Received: by fxh2 with SMTP id 2so746827fxh.26
	for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 09:47:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110910183028.GA23537@infradead.org>
References: <CADDb1s2QDk7y+JgMikoje35LviYQwzpgFihndUPuZx2VXYV4Ew@mail.gmail.com>
	<20110910183028.GA23537@infradead.org>
Date: Sun, 11 Sep 2011 22:16:59 +0530
Message-ID: <CADDb1s1fr8fiRMAUTvnSqpKeLGJdUPAbEfLNpwb2-iVd+mjw4w@mail.gmail.com>
Subject: Re: XFS: Observed Crash followed by deadlock of khubd/sync/XFS
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
Cc: xfs@oss.sgi.com

Yes, the patch is applied and the crash is still appearing easily.

On Sun, Sep 11, 2011 at 12:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Sep 08, 2011 at 04:35:28PM +0530, Amit Sahrawat wrote:
>> Kernel Version: 2.6.39.4
>> Target: ARM
>>
>> Observed while doing:
>> Copy some file (any size, I tried with 10MB, 100MB) to XFS partition
>> After Copy do???sync???
>> Now immediately, unplug the device.
>
> Does this still happen with the patch below applied?
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
