Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p75DrAWa122501 for <xfs@oss.sgi.com>; Fri, 5 Aug 2011 08:53:10 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E86A4C74AA
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2011 06:53:04 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id 6zwvEO0DCwa1l64G
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2011 06:53:04 -0700 (PDT)
Received: by wyh22 with SMTP id 22so2193062wyh.26
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2011 06:53:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E3BA2F7.4080500@oracle.com>
References: <4E3BA2F7.4080500@oracle.com>
Date: Fri, 5 Aug 2011 16:53:01 +0300
Message-ID: <CAOQ4uxjVPJmXAFDmWM4K6n5b36PutV1JOkRMzLqeipZkY8AhAg@mail.gmail.com>
Subject: Re: [PATCH] snapshot, defragment and raid test cases for btrfs
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
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Aditya Dani <aditya.dani@gmail.com>, Chris Mason <chris.mason@oracle.com>

Hi Anand,

Can you please post the patch in the body of the message so we can
comment on it inline.

Aditya is also working on a btrfs snapshots xfstest (currently named
257) as part of
his Google summer of code project.

It would be great if you guys can cooperate your efforts.

BTW, while running Aditya's test, Greg has stumbled upon a btrfs OOPS.
Greg can provide more details about it.

Cheers,
Amir.

On Fri, Aug 5, 2011 at 10:59 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
> Hi,
>
> =A0Attached is the patch for the xfstests, which adds snapshot,
> =A0defragment and volume management test cases for the btrfs
> =A0(257, 258 and 259 respectively).
>
> =A0This introduces a new user variable 'DISK_POOL' which should
> =A0be set to disks for the raid tests.
>
> =A0An example of usage of these tests is as below.
> ------------
> [root@localhost xfstests]# cat local.config
> TEST_DEV=3D"/dev/sdd"
> TEST_DIR=3D/btrfs
> SCRATCH_DEV=3D"/dev/sde"
> SCRATCH_MNT=3D/btrfs1
> DISK_POOL=3D"/dev/sdf /dev/sdg"
> [root@localhost xfstests]#
>
> [root@localhost xfstests]# ./check 257 258 259
> FSTYP -- btrfs
> PLATFORM -- Linux/i686 localhost 3.0.0-rc6+
> MKFS_OPTIONS -- /dev/sde
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sde /btrfs1
>
> 257 8s
> 258 3s
> 259 33s
> Ran: 257 258 259
> Passed all 3 tests
> ----------------
>
> =A0Thank you.
>
> Anand
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
