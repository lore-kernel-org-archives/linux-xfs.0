Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAMK7Aeo173490 for <xfs@oss.sgi.com>; Sun, 22 Nov 2009 14:07:10 -0600
Received: from galiil.marvell.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B03818C3A19
	for <xfs@oss.sgi.com>; Sun, 22 Nov 2009 12:07:33 -0800 (PST)
Received: from galiil.marvell.com (galiil.marvell.com [199.203.130.254]) by
	cuda.sgi.com with ESMTP id bfKHuyLv8QSR6aVf for
	<xfs@oss.sgi.com>; Sun, 22 Nov 2009 12:07:33 -0800 (PST)
From: Ofer Heifetz <oferh@marvell.com>
Date: Sun, 22 Nov 2009 22:07:18 +0200
Subject: RE: XFS support for ARMv5
Message-ID: <EE71107DF0D1F24FA2D95041E64AB9E8985A59F192@IL-MB01.marvell.com>
References: <14274282.01258546868484.JavaMail.root@wombat>
	<4B041AEE.4040506@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F17F@IL-MB01.marvell.com>
	<46b8a8850911220845h197cbe28g508cd11783df065a@mail.gmail.com>
In-Reply-To: <46b8a8850911220845h197cbe28g508cd11783df065a@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Richard,

Regarding the CPU, yes it is Marvell SoC 6281(Kirkwood).
I am questioning where do you propose using flush_icache_range?
Did you use it accompanied with the patch Eric posted?

Regarding dmesg, I am using serial console (ttyS0) and am not @ work, but I=
 figure that is all dmesg will have, if there is more I will send tomorrow.

-Ofer

-----Original Message-----
From: Richard Sharpe [mailto:realrichardsharpe@gmail.com] =

Sent: Sunday, November 22, 2009 6:45 PM
To: Ofer Heifetz
Cc: Eric Sandeen; xfs@oss.sgi.com
Subject: Re: XFS support for ARMv5

On Sun, Nov 22, 2009 at 8:20 AM, Ofer Heifetz <oferh@marvell.com> wrote:
> Hi Eric,
>
> I have tried the patch you advised and still get the same error using 2.6=
.31.6, xfs version 2.10.2 on Ubuntu 9.04.
>
> Any other suggestions you think that might help me with this?

If it is a Marvell chip, we eventually found that we had to add
flush_icache_range, although we were doing that in our SCSI_LLD.

> -Ofer
>
> -----Original Message-----
> From: Eric Sandeen [mailto:sandeen@sandeen.net]
> Sent: Wednesday, November 18, 2009 6:04 PM
> To: Ofer Heifetz
> Cc: xfs@oss.sgi.com
> Subject: Re: XFS support for ARMv5
>
> oferh@marvell.com wrote:
>> Hi,
>>
>> I have noticed that XFS on ARMv5TE with latest kernel (2.6.31.6)
>> fails to mount after copying some data and reboot the system.
>>
>> I get "mount: /dev/sda1: can't read superblock", I understand that
>> there were some problems with virtual aliasing that was added to XFS
>> some time ago but ARM arch has not dealt with this properly.
>
> when you get that error from mount, look at dmesg to see what really went=
 wrong ...
>
>> Is there any patch for this bug?
>
> This is a big-hammer approach for the aliasing problem:
>
> Index: linux-2.6.25-rc1/fs/xfs/linux-2.6/xfs_buf.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.25-rc1.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6.25-rc1/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1172,6 +1172,7 @@ _xfs_buf_ioapply(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio->bi_end_io =3D xfs_buf_bio_end_io;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio->bi_private =3D bp;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flush_dcache_page(bp->b_pages[0]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio_add_page(bio, bp->b_pages[0], PAGE_CAC=
HE_SIZE, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size =3D 0;
>
> @@ -1198,6 +1199,7 @@ next_chunk:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nbytes > size)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nbytes =3D size;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flush_dcache_page(bp->b_pages[map_i]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rbytes =3D bio_add_page(bio, bp->b_pages[m=
ap_i], nbytes, offset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rbytes < nbytes)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
>
>
>> xfsprogs version used: 2.10.2
>>
>> -Ofer
>>
>> -- This message was sent on behalf of oferh@marvell.com at
>> openSubscriber.com
>> http://www.opensubscriber.com/messages/xfs@oss.sgi.com/topic.html
>>
>> _______________________________________________ xfs mailing list
>> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
