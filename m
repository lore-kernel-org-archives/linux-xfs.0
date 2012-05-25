Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PH3BWJ143709 for <xfs@oss.sgi.com>; Fri, 25 May 2012 12:03:11 -0500
Received: from mail-qc0-f181.google.com (mail-qc0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	ushncz00Ha3hDIwS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 10:03:05 -0700 (PDT)
Received: by qcsk26 with SMTP id k26so861339qcs.26
	for <xfs@oss.sgi.com>; Fri, 25 May 2012 10:03:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
References: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
	<CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
Date: Fri, 25 May 2012 13:03:04 -0400
Message-ID: <CAH4wwdFu7DEkHFZ5Bf7_PtLPsG0hUyUDoov03q=82R6t+QkERg@mail.gmail.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
From: Peter Watkins <treestem@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Juerg Haefliger <juergh@gmail.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Fri, May 25, 2012 at 2:28 AM, Juerg Haefliger <juergh@gmail.com> wrote:
>> Does your kernel have the effect of
>>
>> 0bf6a5bd4b55b466964ead6fa566d8f346a828ee xfs: convert the xfsaild
>> thread to a workqueue
>
> No.
>
>
>> c7eead1e118fb7e34ee8f5063c3c090c054c3820 xfs: revert to using a
>> kthread for AIL pushing
>
> No.
>
>
>> In particular, is this code in xfs_trans_ail_push:
>>
>> =A0 =A0 =A0 smp_wmb();
>> =A0 =A0 =A0 xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_ls=
n);
>> =A0 =A0 =A0 smp_wmb();
>
> No. xfs_trans_ail_push looks like this:
>
> void
> xfs_trans_ail_push(
> =A0 =A0 =A0 =A0struct xfs_ail =A0*ailp,
> =A0 =A0 =A0 =A0xfs_lsn_t =A0 =A0 =A0 threshold_lsn)
> {
> =A0 =A0 =A0 =A0xfs_log_item_t =A0*lip;
>
> =A0 =A0 =A0 =A0lip =3D xfs_ail_min(ailp);
> =A0 =A0 =A0 =A0if (lip && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (XFS_LSN_CMP(threshold_lsn, ailp->xa_ta=
rget) > 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfsaild_wakeup(ailp, thres=
hold_lsn);
> =A0 =A0 =A0 =A0}
> }
>
>
> FWIW, the XFS driver in my kernel is identical to the vanilla 2.6.38
> driver. I'm still trying to get a XFS trace from a production hang. I
> do have a crash dump from a production machine with /tmp hanging.
> Would it be helpful to share that dump?
>
> ...Juerg

It looks like the combined effect of those patches, perhaps the write
barriers, fix one log space hang. That problem exists in 2.6.38.

Reading bug #922 I see your test case reproduces in recent kernels, so
there must be a newer problem also.

I find the reproducer the most useful, so no need to upload the dump.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
