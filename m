Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6A367F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 09:39:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47BC6AC003
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 07:39:02 -0700 (PDT)
Received: from mail-ea0-f180.google.com (mail-ea0-f180.google.com
	[209.85.215.180]) by cuda.sgi.com with ESMTP id
	aCKQ6uNsi5Bbevsz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 07:38:57 -0700 (PDT)
Received: by mail-ea0-f180.google.com with SMTP id k10so1889664eaj.25
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 07:38:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130615010313.GA29338@dastard>
References: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
	<20130615010313.GA29338@dastard>
Date: Mon, 17 Jun 2013 18:38:56 +0400
Message-ID: <CA+aXbB5b0Vqp9mTPUiV4x_bGkVfbnCTErW-QoX=SMjv0mADf-w@mail.gmail.com>
Subject: Re: possible null pointer in xlog_iodone
From: Vlad Bespalov <vlad.botanic@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

CentOS 6.4 kernel 2.6.32-358.2.1.el6.x86_64
i`ll try to make a script that can be used out-of-house.

several requests may have failed (un)conveniently, so we have passed
through setting XLOG_IO_ERROR in xfs_log_force_unmount() and
eventually skipped xlog_wait altogether:
-----------------
<1>XFS (<device>): metadata I/O error: block 0xa03e1d ("xlog_iodone")
error 5 buf count 1024
<5>XFS (<device>): xfs_do_force_shutdown(0x2) called from line 1052 of
file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0559e51
<1>XFS (<device>): Log I/O Error Detected.  Shutting down filesystem
<1>XFS (<device>): Please umount the filesystem and rectify the problem(s)
<4>XFS (<device>): xfs_log_force: error 5 returned.
<5>XFS (<device>): xfs_do_force_shutdown(0x1) called from line 1063 of
file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xffffffffa0575
<4>XFS (<device>): xfs_log_force: error 5 returned.
<4>XFS (<device>): xfs_log_force: error 5 returned.
...
<1>XFS (mtab~): metadata I/O error: block 0xa03e1b ("xlog_iodone")
error 5 buf count 1024
---------------
Thanks.

On 15 June 2013 05:03, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jun 14, 2013 at 09:15:04PM +0400, Vlad Bespalov wrote:
>> i`m running an xfs filesystem over device going offline/online and
>> sometimes offline may be done in parallel with unmounting
>>
>> at some point i got several crashes with null pointer panic in
>> xlog_iodone: xlog_t structure taken from input buffer is null
>>
>> i wonder if the following call path combined with disk online/offline
>> handling could have led to this crash:
>>
>> --------------
>> xfs_unmountfs()
>>     xfs_log_unmount_write(mp)
>>         xlog_state_release_iclog(log)
>>             xlog_sync(log, iclog = log->l_iclog)
>>             (bp=iclog->ic_bp)
>>                 xlog_bdstrat(bp)
>>                 (iclog->ic_state != XLOG_STATE_ERROR ? )
>>                     xfs_buf_iorequest(bp)
>>                         xfs_buf_ioend (called with scheduling (*) )
>>                         (queues  : bp->b_iodone_work,
>>                          callback: xlog_iodone)
>
> Which is followed by:
>
>                 if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
>                       iclog->ic_state == XLOG_STATE_DIRTY)) {
>                         if (!XLOG_FORCED_SHUTDOWN(log)) {
>                                 xlog_wait(&iclog->ic_force_wait,
>                                                         &log->l_icloglock)
>
> Which is supposed to wait for the log IO to complete and hence
> xlog_iodone() is supposed to have been run by the time this code
> completes.
>
> What kernel are you tesing on? Do you have a script that reproduces
> it?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
