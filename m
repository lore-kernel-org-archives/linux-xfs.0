Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4P6SCYa029680 for <xfs@oss.sgi.com>; Fri, 25 May 2012 01:28:13 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id 0DF2OgjqkzhSBXKo
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 May 2012 23:28:11 -0700 (PDT)
Received: by dadg9 with SMTP id g9so1018869dad.26
	for <xfs@oss.sgi.com>; Thu, 24 May 2012 23:28:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
References: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
Date: Fri, 25 May 2012 08:28:10 +0200
Message-ID: <CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
From: Juerg Haefliger <juergh@gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

> Does your kernel have the effect of
>
> 0bf6a5bd4b55b466964ead6fa566d8f346a828ee xfs: convert the xfsaild
> thread to a workqueue

No.


> c7eead1e118fb7e34ee8f5063c3c090c054c3820 xfs: revert to using a
> kthread for AIL pushing

No.


> In particular, is this code in xfs_trans_ail_push:
>
> =A0 =A0 =A0 smp_wmb();
> =A0 =A0 =A0 xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn=
);
> =A0 =A0 =A0 smp_wmb();

No. xfs_trans_ail_push looks like this:

void
xfs_trans_ail_push(
        struct xfs_ail  *ailp,
        xfs_lsn_t       threshold_lsn)
{
        xfs_log_item_t  *lip;

        lip =3D xfs_ail_min(ailp);
        if (lip && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
                if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0)
                        xfsaild_wakeup(ailp, threshold_lsn);
        }
}


FWIW, the XFS driver in my kernel is identical to the vanilla 2.6.38
driver. I'm still trying to get a XFS trace from a production hang. I
do have a crash dump from a production machine with /tmp hanging.
Would it be helpful to share that dump?

...Juerg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
