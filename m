Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p45BPwlj129214 for <xfs@oss.sgi.com>; Thu, 5 May 2011 06:25:58 -0500
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id BD3B2432330
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 04:29:35 -0700 (PDT)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id jN0PVZ6G6JwPcluP
	for <xfs@oss.sgi.com>; Thu, 05 May 2011 04:29:35 -0700 (PDT)
Message-ID: <4DC28A00.7010309@draigBrady.com>
Date: Thu, 05 May 2011 12:29:04 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>	<4DA70BD3.1070409@draigBrady.com>	<4DA717B2.3020305@sandeen.net>	<4DA7182B.8050409@draigBrady.com>	<4DA71920.9@sandeen.net>	<BANLkTikW72q_2pEoVTmag8+gMsCcZ-fR8w@mail.gmail.com>
	<BANLkTimoLeWMJgNFGW+zdeUeJyZ-_+8fMQ@mail.gmail.com>
In-Reply-To: <BANLkTimoLeWMJgNFGW+zdeUeJyZ-_+8fMQ@mail.gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

On 14/04/11 17:10, Yongqiang Yang wrote:
> Hi,
> =

> I am off my working computer.  Maybe below fix could fix the problem.
> =

> fs/ext4/extent.c
> static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> 1877                 } else if (block >=3D le32_to_cpu(ex->ee_block)) {
> 1878                         /*
> 1879                          * some part of requested space is covered
> 1880                          * by found extent
> 1881                          */
> 1882                         start =3D block;
> 1883                         end =3D le32_to_cpu(ex->ee_block)
> 1884                                 + ext4_ext_get_actual_len(ex);
> 1885                         if (block + num < end)
> 1886                                 end =3D block + num;
>        +                        if (!ext4_ext_is_uninitialized(ex))
> 1887                         exists =3D 1;
> 1888                 } else {
> 1889                         BUG();
> 1890                 }

Hi,

To follow up on the above.  I'm under the impression
that ext4 is expected to return extents for what
is written, irrespective of whether it's reached the
disk or not. I.E. the preallocation case where this fails
was an oversite, for which the above might fix.

So is the above summary correct, and has there
been any more thoughts on a fix?

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
