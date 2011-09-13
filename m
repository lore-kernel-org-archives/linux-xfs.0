Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DFi0H4068367 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 10:44:00 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7BFC54E28B
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:43:59 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id 6ql25qB2Reh4b4cB
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:43:59 -0700 (PDT)
Received: by fxh2 with SMTP id 2so687143fxh.26
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:43:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110913152607.GA21460@infradead.org>
References: <CADDb1s2QDk7y+JgMikoje35LviYQwzpgFihndUPuZx2VXYV4Ew@mail.gmail.com>
	<CADDb1s2S9R5RoaJ2NGSbCXORngx8PQVB6r3-QVJbjCUYh+B63Q@mail.gmail.com>
	<20110913152607.GA21460@infradead.org>
Date: Tue, 13 Sep 2011 21:13:58 +0530
Message-ID: <CADDb1s3Y1Eosf-p3a3Upm71BLDG9ReMsOMBjYF9koDb9fqkKAw@mail.gmail.com>
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

I am able to get it very frequent on both ARM/x86 with the same case
and same logs.
In particular just adding a msleep in unmount path before
xfs_log_sbcount to trigger this path - this will definetely help.
I am able to figure out the issue - there is an issue in callback and
unmount path not in sync.
unmount path does it work as required but there is a callback pending.
In normal case I can see xfslogd is used to execute callbacks - while
at the time of the issue the callback is called is called in the
context of 'umount' process - which leads to destroying AIL and
deallocating log and then using the same in callback path from
xfs_buf_iodone_callbacks --> xfs_buf_iodone

I have done some changes to get over this but further looking.

Thanks & Regards,
Amit Sahrawat

On Tue, Sep 13, 2011 at 8:56 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Sep 08, 2011 at 10:58:35PM +0530, Amit Sahrawat wrote:
>> Since this is very hard to reproduce, to make it easy to debug. This
>> can be reproduce by introducing msleep in the kernel xfs_umountfs()
>> before xfs_log_sbcount(), just add a print before this function and
>> sleep and the moment the print appear unplug the USB device, same
>> scenario will be reproduced.
>> CRASH will show the backtrace and return to normal shell, but when
>> process state is checked, khubd will be shown in TASK-UNINTERRUPTIBLE
>> state 'D'.
>> Further if sync is issued that will also get converted to 'D' state,
>> the back-trace for each of the task is same as mentioned in the
>> previous mail.
>
> I've not been able to reproduce this using that method so far.
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
