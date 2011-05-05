Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p45Bhpg0129984 for <xfs@oss.sgi.com>; Thu, 5 May 2011 06:43:52 -0500
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FCDF11CD5CE
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 04:47:29 -0700 (PDT)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	NqUG9UjaAW1FVb0S for <xfs@oss.sgi.com>;
	Thu, 05 May 2011 04:47:29 -0700 (PDT)
Received: by vxb39 with SMTP id 39so2420284vxb.26
	for <xfs@oss.sgi.com>; Thu, 05 May 2011 04:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC28A00.7010309@draigBrady.com>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net>
	<BANLkTikW72q_2pEoVTmag8+gMsCcZ-fR8w@mail.gmail.com>
	<BANLkTimoLeWMJgNFGW+zdeUeJyZ-_+8fMQ@mail.gmail.com>
	<4DC28A00.7010309@draigBrady.com>
Date: Thu, 5 May 2011 19:47:29 +0800
Message-ID: <BANLkTikM4kekeaa2EQTtP02ondKL1X3+3g@mail.gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
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
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

2011/5/5 P=E1draig Brady <P@draigbrady.com>:
> On 14/04/11 17:10, Yongqiang Yang wrote:
>> Hi,
>>
>> I am off my working computer. =A0Maybe below fix could fix the problem.
>>
>> fs/ext4/extent.c
>> static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>> 1877 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (block >=3D le32_to_cpu(e=
x->ee_block)) {
>> 1878 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> 1879 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* some part of r=
equested space is covered
>> 1880 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* by found extent
>> 1881 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> 1882 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D block;
>> 1883 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D le32_to_cpu=
(ex->ee_block)
>> 1884 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + e=
xt4_ext_get_actual_len(ex);
>> 1885 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block + num < e=
nd)
>> 1886 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end=
 =3D block + num;
>> =A0 =A0 =A0 =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ext=
4_ext_is_uninitialized(ex))
>> 1887 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exists =3D 1;
>> 1888 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> 1889 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
>> 1890 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> Hi,
>
> To follow up on the above. =A0I'm under the impression
> that ext4 is expected to return extents for what
> is written, irrespective of whether it's reached the
> disk or not. I.E. the preallocation case where this fails
No.  It just returns extent info now - allocated extents and delayed
extents.  In the preallocation case, it returns unwritten extents.
And the code above does not work.

> was an oversite, for which the above might fix.
>
> So is the above summary correct, and has there
> been any more thoughts on a fix?
>
> cheers,
> P=E1draig.
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
