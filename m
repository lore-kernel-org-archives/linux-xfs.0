Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7S5isLd048895 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 00:44:54 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	gtdYmr00CXyEDeLW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 22:45:45 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so7446577obb.26
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 22:45:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503C0582.3080009@sandeen.net>
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
	<1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
	<CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
	<alpine.LRH.2.02.1208270952390.8166@mail.vlasiu.net>
	<CAAxjCEynRoS3AfYer=is725XR+kZEwe_SPxt_iDTJNRMo2UxOA@mail.gmail.com>
	<alpine.LRH.2.02.1208271016440.10454@mail.vlasiu.net>
	<503C0582.3080009@sandeen.net>
Date: Tue, 28 Aug 2012 07:45:44 +0200
Message-ID: <CAAxjCExbX0_Nvq-C0e9DEjR+2APUpPPSHUdgfcu8sygvZdSvwA@mail.gmail.com>
Subject: Re: umount doesn't seem to really unmount
From: Stefan Ring <stefanrin@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Linux fs XFS <xfs@oss.sgi.com>

> Gah, is umount replaced by something via systemd?  I mean.... umount is
> still umount, no?
>
> IOW is this just doing a lazy unmount behind your back?

My interpretation is that at the time a service is started, the entire
filesystem "namespace" is copied to a secret place, including the
mounts. Then, when I issue umount, it is actually unmounted from the
main namespace, but from the viewpoint of the filesystem, it's still
mounted, precisely in the hidden namespace that got created for the
running service. Only when this service quits, its namespace will be
destroyed, and with it the filesystem's refcount will drop to 0. At
this point, the real "unmount", or rather "close" will happen.

Apparently, this is not usually a problem, but for me it is, because
at that time, the iSCSI storage device is gone. Gabriel has filed a
bug here: [1]. Unfortunately, I have no hope that this will ever be
"fixed", because it behaves just the way it was designed :(.

At least  it has become clear that this has nothing to do with XFS,
although subjectively my feeling is that the effects (i.e., data loss)
are felt more with XFS than with ext4.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=851970

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
