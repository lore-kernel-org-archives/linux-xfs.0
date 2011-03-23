Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NEXRmB098902 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 09:33:32 -0500
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C1FD36E1D9
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:36:17 -0700 (PDT)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	jFTeZfFSq1TgSniL for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2011 07:36:17 -0700 (PDT)
Received: by qyg14 with SMTP id 14so7219758qyg.5
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:36:17 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Mar 2011 16:36:17 +0200
Message-ID: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
Subject: xfstests: failure to umount ext4
From: Amir Goldstein <amir73il@gmail.com>
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
To: XFS <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>

On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> I've been running xfstests on ext4 and I always get annoying failures to =
umount:
>
> 213 8s ... 31s
> umount: /mnt/test/ext4: device is busy.
> =A0 =A0 =A0 =A0(In some cases useful info about processes that use
> =A0 =A0 =A0 =A0 the device is found by lsof(8) or fuser(1))
>
> post 198 mostly fails to umount as well.
> and post 124 always fails to umount.
>
> My server is Ubuntu 10.10, running kernel 2.6.38.
>
> Is there any known issue about this? because I could find it on google
> or on the XFS list.
>

Hi All,

Has anyone seen these failures when running xfstests on ext4?
My test and scratch partitions are dedicated for xfstests.

Thanks,
Amir.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
