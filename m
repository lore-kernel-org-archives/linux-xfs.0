Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBMC6mYr130004 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 06:06:48 -0600
Received: from smtp19.orange.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A40A11DFDD
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 04:07:29 -0800 (PST)
Received: from smtp19.orange.fr (smtp19.orange.fr [80.12.242.18]) by
	cuda.sgi.com with ESMTP id YEnlW77BOkaIXc2X for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2009 04:07:29 -0800 (PST)
Message-ID: <4B30B67A.7080703@wanadoo.fr>
Date: Tue, 22 Dec 2009 13:07:22 +0100
From: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
MIME-Version: 1.0
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp>
	<4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp>
	<4B3097C4.3060803@wanadoo.fr> <874onjjnln.fsf@devron.myhome.or.jp>
In-Reply-To: <874onjjnln.fsf@devron.myhome.or.jp>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Eric Blake <ebb9@byu.net>, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>

Hi again,

OGAWA Hirofumi wrote:
> Jean-Pierre Andr=E9<jean-pierre.andre@wanadoo.fr>  writes:
>
>    =

>> Hi all,
>>      =

> Hi,
>
>    =

>> OGAWA Hirofumi wrote:
>>      =

>>> Eric Blake<ebb9@byu.net>   writes:
>>>
>>>
>>> It is likely the issue of libfuse or ntfs-3g. I don't know about ntfs-3g
>>> people at all. So, for now, just Cc: to fuse people.
>>>
>>>        =

>> Which ntfs-3g version are you using ?
>>      =

> I don't know which version is used by actual user. But, well, I've got
> source by "apt-get source", and the version was 1:2009.4.4-1.
>    =

> Now, I've got ntfs-3g-2009.11.14AC.2.tgz from specified url.
>
>    =

>>>> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) =3D 0
>>>>          =

>> Currently ntfs-3g does not set sub-second precision.
>>
>> There is also a slight problem in the fuse interface :
>> the time buffer is never passed as NULL, consequently
>> in some circumstances ntfs-3g cannot decide correctly
>> over permissions. A permissive action is taken in this
>> situation.
>>
>>      =

>>>>  From this, "ia_valid" will have "ATTR_CTIME | ATTR_MTIME". And the
>>>>          =

>>> request would pass to userland via fuse of kernel part, then it will be
>>> handled by libfuse.
>>>
>>>        =

>>>>  From quick grep of libfuse and ntfs-3g (would not be latest), ntfs-3g=
 is
>>>>          =

>>> using "struct fuse_operations", not "struct fuse_lowlevel_ops".
>>>
>>>        =

>> With the latest ntfs-3g, currently as a release candidate,
>> you can (optionally) use the low level fuse interface
>> http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html
>> use the "lowntfs-3g" driver instead of "ntfs-3g"
>>      =

> Well, the problem seems in fuse_lib_setattr() and ntfs_fuse_setattr()
> (lowlevel op too).
>
> The both functions is requiring "ATIME | MTIME". Doesn't it mean the
> ntfs-3g can't set only MTIME like above utimensat()?
>    =


With ntfs-3g this is not directly possible, because
the interface does not provide flags telling which
timestamps should be updated. The only way would
be fuse feeding both values (even though unchanged)
before calling ntfs-3g. This is true for all versions of
ntfs-3g.

With lowntfs-3g (release candidate only), this could
be possible.... but this is not implemented, as the
case was never found up to now. I can provide you
with a patch,... if fuse can feed in the flags selectively.

> In fuse_lib_setattr(),
>
>          if (!err&&  (valid&  (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)=
) =3D=3D
>              (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) {
>
> In ntfs_fuse_setattr(),
> 	case FUSE_SET_ATTR_ATIME + FUSE_SET_ATTR_MTIME :
> 		res =3D ntfs_fuse_utime(&security, ino, attr,&stbuf);
>
> Or I'm missing something?
>
> Thanks.
>    =


Regards

Jean-Pierre



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
