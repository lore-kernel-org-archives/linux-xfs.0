Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9ANr1K9212977 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 18:53:02 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E4151C7D994
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 16:53:01 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	hemGWjeymGCEX4rn for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 16:53:01 -0700 (PDT)
Received: by iahk25 with SMTP id k25so2785890iah.26
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 16:53:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E936BFB.5060907@mnsu.edu>
References: <201110071352.20135@zmi.at> <20111007233450.GK3159@dastard>
	<201110100829.45823@zmi.at>
	<CAGpXXZJs8kjZaSp248rA+-d=gpwWe=oK0xtUUirv+zgE3Vq3kA@mail.gmail.com>
	<4E936BFB.5060907@mnsu.edu>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 10 Oct 2011 19:52:29 -0400
Message-ID: <CAGpXXZK9sbVweP-6hDnB2Ds3B8RY-F_DK1SGu5od_ckTdcXOTQ@mail.gmail.com>
Subject: Re: TRIM on XFS
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
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 6:04 PM, Jeffrey Hundstad
<jeffrey.hundstad@mnsu.edu> wrote:
> On 10/10/2011 03:28 PM, Greg Freemyer wrote:
>>
>> fitrim is the batch mode.
>>
>> To enable realtime discard, add --discard to your mount options.
>>
>> Documented
>> athttp://lxr.linux.no/#linux+v3.0.4/Documentation/filesystems/xfs.txt
>>
>> To invoke batch mode, simply use fstrim from user space.
>
> Hello,
>
> I'm also trying to use FITRIM on a simple XFS partition on a spinning
> magnetic hard drive (remember those). =A0I haven't had much luck. =A0I'm =
doing
> this just to get used to the commands when using this against a thinly
> provisioned disk. =A0I have no idea if this should work in this configura=
tion.
>
> On a Debian system with Linux 3.0.0-2-amd64 when I issue:
> # fstrim /
>
> I receive:
> fstrim: /: FITRIM ioctl failed: Operation not supported
>
> With an strace this looks like:
> open("/", O_RDONLY) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 3
> ioctl(3, 0xc0185879, 0x7fff4ea851b0) =A0 =A0=3D -1 EOPNOTSUPP (Operation =
not
> supported)
>
> My fstrim is from util-linux-2.19.1-5
>
> I'd be happy to try to diagnose this further if people are interested. =
=A0Any
> suggestions where I should start would be much appreciated.
>
> --
> Jeffrey Hundstad

I just tried it with a 3.1.0-rc9 kernel and had the same problem.

I just checked xfstests group file and see that test 251 (the fstrim
one) is not in the auto group, so I haven't been running it.

Same is true of btrfs and ext4.  I've only been running the auto group
recently.  And mostly against btrfs and ext4.

Hopefully someone can explain it to us both.
Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
