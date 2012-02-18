Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1IGUFus174892 for <xfs@oss.sgi.com>; Sat, 18 Feb 2012 10:30:15 -0600
MIME-Version: 1.0
In-Reply-To: <20120217191522.GB13870@infradead.org>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
	<20120217191522.GB13870@infradead.org>
Date: Sat, 18 Feb 2012 22:00:11 +0530
Message-ID: <CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Nam-Jae Jeon <linkinjeon@gmail.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>

Hi Christoph,

There are =912=92 scenarios which results in the similar problem related
to flushing. Both related to handling of buffer callbacks after the
corresponding mount point passed in the transactions is destroyed.

The first one reported 2 months back (in umount path) =96 which was
related with the asynchronous callback of buf-iodone handlers being
called after the freeing up of the mount point in:
void xfs_log_unmount(xfs_mount_t *mp)
{
	xfs_trans_ail_destroy(mp);
	xlog_dealloc_log(mp->m_log);
}

The complete tracing information for the first issue is available at:
http://patchwork.xfs.org/patch/2485/

For which the solution was also provided by you as -> xfs: fix buffer
flushing during unmount
(http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommitd=
iff;h=3D87c7bec7fc3377b3873eb3a0f4b603981ea16ebb)

Now, we have encountered a similar issue in mount failure path.
In this scenarios also =96 it is the calling of =91xfs_log_umount=92 without
waiting for the dependent buffer callbacks to be flushed.
xfs_mountfs()
{
=85
=85
error =3D xfs_log_mount_finish(mp);
	if (error) {
		cmn_err(CE_WARN, "XFS: log mount finish failed");
		goto out_rtunmount;
	}
=85
..
out_log_dealloc:
	xfs_log_unmount(mp);
=85
}
xfs_fs_fill_super()
{
=85
	error =3D xfs_mountfs(mp);
	if (error)
		goto out_filestream_unmount;
=85
=85
out_filestream_unmount:
	xfs_filestream_unmount(mp);
 out_free_sb:
	xfs_freesb(mp);
 out_destroy_counters:
	xfs_icsb_destroy_counters(mp);
	xfs_close_devices(mp);
}

Now, in xfs_close_devices() =96 it tries to flush all the pending buffer
callbacks =96 but because xfs_log_umount has resulted in destroying of
ail mountpoint in xfs_trans_ail_destroy(mp);
This again results in crash at
xfs_buf_iodone()
{
=85
	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
=85
}
The backtrace and exact problem was shared as part of the reply to the
patch submission mail.

So a solution to this =96 also we need to flush buffers.

And because it is a similar situation and also =96 we can make this a
generic solution.
The fix from the patch
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommitdi=
ff;h=3D87c7bec7fc3377b3873eb3a0f4b603981ea16ebb
was removed and instead tried to put it at one place which could solve
the similar issues.

Please let me know incase I am not able to clarify properly.

Thanks & Regards,
Amit Sahrawat

On Sat, Feb 18, 2012 at 12:45 AM, Christoph Hellwig <hch@infradead.org> wro=
te:
>> Whenever there is a mount/unmount failure - there is a chance of calling=
 the
>> callbacks functions once - transaction ail mount pointer is destroyed. S=
o, it results
>> in NULL pointer exception followed by hang. So, before unmount of the lo=
g - flush all
>> the pending buffers.
>
>> =A0void
>> =A0xfs_log_unmount(xfs_mount_t *mp)
>> =A0{
>> + =A0 =A0 int error =3D 0;
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Make sure all buffers have been flushed and completed bef=
ore
>> + =A0 =A0 =A0* unmounting the log.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 error =3D xfs_flush_buftarg(mp->m_ddev_targp, 1);
>> + =A0 =A0 if (error)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cmn_err(CE_WARN, "%d busy buffers during log u=
nmount.", error);
>> + =A0 =A0 xfs_wait_buftarg(mp->m_ddev_targp);
>> +
>
> We do exactly that sequence before the xfs_log_unmount_write call on
> umount. =A0Care to explain what code in xfs_log_unmount_write would
> require this to be called again?
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
