Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8ND3mQa098136 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 08:03:49 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECF28141237E
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 06:09:16 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	XAt66TEKjiWIsZti for <xfs@oss.sgi.com>;
	Fri, 23 Sep 2011 06:09:16 -0700 (PDT)
Received: by gyd10 with SMTP id 10so3408775gyd.26
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 06:03:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316722702.2009.59.camel@doink>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
	<1316722702.2009.59.camel@doink>
Date: Fri, 23 Sep 2011 16:03:41 +0300
Message-ID: <CANOLnOPm+BEQ0QOYnYRkJqpGPwyUD9D+23dJe2OwgrHXqYFyVA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add new getdents test
From: Grazvydas Ignotas <notasas@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-13"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 22, 2011 at 11:18 PM, Alex Elder <aelder@sgi.com> wrote:
> On Mon, 2011-09-12 at 03:19 +0300, Grazvydas Ignotas wrote:
>> The test checks if no duplicate d_off values are returned and that
>> those values are seekable to the right inodes.
>>
>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>
> I have two minor comments on the C program below,
> but even if you don't want to address them this
> looks good.
>
> Reviewed-by: Alex Elder <aelder@sgi.com>
>
> . . .
>
>> +#include <sys/syscall.h>
>> +
>> +struct linux_dirent64 {
>> + =A0 =A0 uint64_t =A0 =A0 =A0 =A0d_ino;
>> + =A0 =A0 uint64_t =A0 =A0 =A0 =A0d_off;
>> + =A0 =A0 unsigned short =A0d_reclen;
>> + =A0 =A0 unsigned char =A0 d_type;
>> + =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0d_name[0];
>> +};
>> +
>> +#define BUF_SIZE 4096
>> +#define HISTORY_LEN 1024
>> +
>> +static uint64_t d_off_histoty[HISTORY_LEN];
>> +static uint64_t d_ino_histoty[HISTORY_LEN];
>
> Is "histoty" intentional or a typo?

whoops, it's a typo. I might send a patch for this later.

>
>> +int
>> +main(int argc, char *argv[])
>> +{
>> + =A0 =A0 int fd, nread;
>> + =A0 =A0 char buf[BUF_SIZE];
>
> . . .
>
>> +
>> + =A0 =A0 /* check if seek works correctly */
>> + =A0 =A0 d =3D (struct linux_dirent64 *)buf;
>> + =A0 =A0 for (i =3D total - 1; i >=3D 0; i--)
>> + =A0 =A0 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 lret =3D lseek(fd, i > 0 ? d_off_histoty[i - 1=
] : 0, SEEK_SET);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (lret =3D=3D -1) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 perror("lseek");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit(EXIT_FAILURE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 nread =3D syscall(SYS_getdents64, fd, buf, BUF=
_SIZE);
>
> You could just use sizeof (struct linux_dirent_64) rather than
> BUF_SIZE here. =A0I suppose it doesn't hurt but there's no real
> sense in reading more than the one you're going to look at.

I'm not sure if reading partial entry is allowed, manpage says it may
fail with EINVAL if buffer size is too small..


-- =

Gra=FEvydas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
