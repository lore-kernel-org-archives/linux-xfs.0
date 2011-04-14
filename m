Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3EJCF1K013286 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 14:12:15 -0500
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id DE5F41D5AF38
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 12:15:36 -0700 (PDT)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id 7UgOaSAOtatzipoA
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 12:15:36 -0700 (PDT)
Message-ID: <4DA74771.5010103@draigBrady.com>
Date: Thu, 14 Apr 2011 20:13:53 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net>	<4DA7182B.8050409@draigBrady.com>
	<878vvcspz0.fsf@rho.meyering.net>
In-Reply-To: <878vvcspz0.fsf@rho.meyering.net>
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
To: Jim Meyering <jim@meyering.net>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

On 14/04/11 18:27, Jim Meyering wrote:
> =

> FYI, I see the same failure now using ext3 (and but not w/ext4)
> with rawhide's 2.6.39-0.rc2.git0.0.fc16.x86_64:
> =

>   + df -t ext3 .

Not with ext3 ...

>   + mkfs -t ext4 -F blob

... but with ext4 loop back

>   + perl -e 'BEGIN { $n =3D 1 * 1024; *F =3D *STDOUT }' -e 'for (1..1) { =
sysseek (*F, $n, 1)' -e '&& syswrite (*F, chr($_)x$n) or die "$!"}'

>   + cp --sparse=3Dalways j1 j2
>   + cmp j1 j2
>   j1 j2 differ: char 1, line 1     <<<<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

But there was no preallocation done above.
So this was the original sync issue, which doesn't seem to be working :(
Is there a chance the rawhide kernel hasn't included that change?
Unlikely as it's 2.6.39-rc2.

cheers,
P=E1draig.

p.s. I will do some checking with ext3 to ensure everything is OK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
