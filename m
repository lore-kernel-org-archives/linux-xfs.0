Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O1GQsX036853 for <xfs@oss.sgi.com>; Mon, 23 May 2011 20:16:26 -0500
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 084EC10E185D
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 18:16:25 -0700 (PDT)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	YtNymoEm0XlqgBHb for <xfs@oss.sgi.com>;
	Mon, 23 May 2011 18:16:25 -0700 (PDT)
Received: by vxb39 with SMTP id 39so5038966vxb.26
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 18:16:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDAC4EF.1050702@linux.vnet.ibm.com>
References: <4DDAC4EF.1050702@linux.vnet.ibm.com>
Date: Tue, 24 May 2011 09:16:24 +0800
Message-ID: <BANLkTiks0NSDTSPN8n446JHWhKtM61_=Mw@mail.gmail.com>
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 24, 2011 at 4:34 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Hi all,
>
> While trying to add more punch hole tests to xfstest, I found that test 2=
52 hangs on ext4 due to a loop in xfsprogs that does not exit. =A0XFS gets =
out of this loop because there is logic in the loop that looks for the last=
 extent flag and breaks out. =A0But it looks like ext4 does not return a la=
st extent when the file has a hole at the end. =A0I am not sure if this is =
the correct behavior or not, so I will copy the ext4 folks on this too. =A0=
Below is a copy of the fix for xfsprogs:

Hi there,

What's blocksize of the tested ext4?    For now, ext4 returns
LAST_EXTENT if the logical offset covered by the extent is greater
than file size, so if there is a hole at the end, no last extent is
returned. Thx!

Yongqiang.

>
> diff --git a/io/fiemap.c b/io/fiemap.c
> index fa990cc..81fc92c 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -246,7 +246,7 @@ fiemap_f(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flg_w, _("FLAGS"));
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 while (!last && ((cur_extent + 1) !=3D max_extents)) {
> + =A0 =A0 =A0 while (!last && (cur_extent <=3D max_extents)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (max_extents)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_extents =3D min(num_ex=
tents,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0max_extents - (cur_extent + 1));
>
>
> It looks like the loop enters with last=3D0, cur_extents=3D0, and max_ext=
ents =3D 0, and on the first iteration cur_extents get set to 2, so we dont=
 see ((cur_extent + 1) =3D=3D max_extents for a very long time. =A0I doubt =
the logic was meant to work that way, so this patch should fix it, but I wa=
nted to make sure that the fiemap for ext4 is working as intended too. =A0F=
eed back appreciated! =A0Thx all!
>
> Allison Henderson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
