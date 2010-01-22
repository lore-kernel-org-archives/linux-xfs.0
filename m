Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0M7CCcJ116216 for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 01:12:12 -0600
Received: from mail-yw0-f191.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FB9F124F523
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 23:13:13 -0800 (PST)
Received: from mail-yw0-f191.google.com (mail-yw0-f191.google.com
	[209.85.211.191]) by cuda.sgi.com with ESMTP id
	ISMQp6iZtEd2vGEn for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2010 23:13:13 -0800 (PST)
Received: by ywh29 with SMTP id 29so761921ywh.30
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 23:13:12 -0800 (PST)
MIME-Version: 1.0
From: "Guk-Bong, Kwon" <gbkwon@gmail.com>
Date: Fri, 22 Jan 2010 16:12:52 +0900
Message-ID: <77cc6e171001212312y2bdde8b3u66befae8b99e0256@mail.gmail.com>
Subject: Re: [help] project quota information incorrect over nfs ...[solved]
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

first.. thanks for your interest

your patches is correct..


2010/1/22 Alex Elder <aelder@sgi.com>:
> Christoph Hellwig wrote:
>> On Thu, Jan 21, 2010 at 01:12:06PM +0900, Guk-Bong, Kwon wrote:
>>> nfs client "nfs_server:/test/111" Size is correct..(100M)
>>>
>>> but nfs client "nfs_server:/test/111" Avail is incorrect.. (500M)
>>>
>>> "Avail" is big than "Size" ...
>>>
>>> this stat is normal??
>>
>> No, it's not. =A0The patch below should fix it, but I'm not sure how
>> easily backportable it is to 2.6.27:
>
> I'm going to take this as a [PATCH] and say it looks good to me.
> It will probably not be difficult for someone to port it back
> to 2.6.27.
>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Reviewed-by: Alex Elder <aelder@sgi.com>
>
>> Index: linux-2.6/fs/xfs/quota/xfs_qm_bhv.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.orig/fs/xfs/quota/xfs_qm_bhv.c =A02010-01-21 12:13:51.3970=
03969 +0100
>> +++ linux-2.6/fs/xfs/quota/xfs_qm_bhv.c =A0 =A0 =A0 2010-01-21 12:14:14.=
290009571 +0100
>> @@ -59,7 +59,7 @@ xfs_fill_statvfs_from_dquot(
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 be64_to_cpu(dp->d_blk_hardlimit);
>> =A0 =A0 =A0 if (limit && statp->f_blocks > limit) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 statp->f_blocks =3D limit;
>> - =A0 =A0 =A0 =A0 =A0 =A0 statp->f_bfree =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 statp->f_bfree =3D statp->f_bavail =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (statp->f_blocks > be64_to_c=
pu(dp->d_bcount)) ?
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(statp->f_blocks - be64_t=
o_cpu(dp->d_bcount)) : 0;
>> =A0 =A0 =A0 }
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>



-- =

thanks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
