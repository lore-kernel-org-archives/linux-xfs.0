Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6AEucaO105533 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 09:56:38 -0500
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7785035758B
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 07:57:15 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com
	[209.85.132.240]) by cuda.sgi.com with ESMTP id
	t1X4o98fGPIdiBPG for <xfs@oss.sgi.com>;
	Fri, 10 Jul 2009 07:57:15 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id b2so562800ana.32
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 07:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A56BCDE.2010609@sandeen.net>
References: <554e24be0907091624s2dd439b2vfd7062f6b866c7f@mail.gmail.com>
	<4A56BCDE.2010609@sandeen.net>
Date: Fri, 10 Jul 2009 10:57:14 -0400
Message-ID: <554e24be0907100757g7f891fa1t7517cb0258853779@mail.gmail.com>
Subject: Re: kernel BUG with xfs_quota
From: Chris Walker <christopher.walker@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thanks a lot for your response Eric, I didn't realize that debugging
could lead to problems (perhaps the EXPERIMENTAL should have warned
me!)  I will recompile without debugging.  I'm a bit surprised that
debugging could lead to general filesystem instability -- I assumed it
was a 'read-only' process.
Thanks!
Chris

On Fri, Jul 10, 2009 at 12:00 AM, Eric Sandeen<sandeen@sandeen.net> wrote:
> Chris Walker wrote:
>> Hello,
>>
>> I ran an xfs_quota command earlier (xfs_quota -x -c 'limit -g
>> bsoft=3D2048g bhard=3D2148g hepl' /seltzer_lab), which triggered a kernel
>> BUG:
>>
>> Assertion failed: dst->d_btimer !=3D 0, file:
>> fs/xfs/quota/xfs_qm_syscalls.c, line: 927
>
> Well, you hit this:
>
> #ifdef DEBUG
> =A0 =A0 =A0 =A0if (((XFS_IS_UQUOTA_ENFORCED(mp) && dst->d_flags =3D=3D
> XFS_USER_QUOTA) ||
> =A0 =A0 =A0 =A0 =A0 =A0 (XFS_IS_OQUOTA_ENFORCED(mp) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(dst->d_flags & (XFS_PROJ_=
QUOTA |
> XFS_GROUP_QUOTA)))) &&
> =A0 =A0 =A0 =A0 =A0 =A0dst->d_id !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (((int) dst->d_bcount >=3D (int) dst->d=
_blk_softlimit) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(dst->d_blk_softlimit > 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ASSERT(dst->d_btimer !=3D =
0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> ...
>
> which first raises the question, why are you running with
> CONFIG_XFS_DEBUG? :)
>
> I'm no quota guru, but this is something like...
>
> If quota is enabled and the block count is over a non-0 soft limit, then
> assert that the timer is non-0 (the timer being how much time is left
> before service is refused.
>
> It also got all those values off the disk just prior to the ASSERT.
>
> ... and I'm not sure what the problem may be. =A0But you hit an internal
> debugging assert which is only on with CONFIG_XFS_DEBUG, you may get
> away with just running without that for now :)
>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
