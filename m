Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBMDTmU8134695 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 07:29:48 -0600
Received: from mail.parknet.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F198012E9970
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 05:30:30 -0800 (PST)
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6]) by
	cuda.sgi.com with ESMTP id wCnQxcoYibCxwEDq for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2009 05:30:30 -0800 (PST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>
	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
Date: Tue, 22 Dec 2009 22:30:24 +0900
In-Reply-To: <4B30B67A.7080703@wanadoo.fr> ("Jean-Pierre =?iso-8859-1?Q?An?=
	=?iso-8859-1?Q?dr=E9=22's?= message of
	"Tue, 22 Dec 2009 13:07:22 +0100")
Message-ID: <87ljgvi1an.fsf@devron.myhome.or.jp>
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
To: Jean-Pierre =?iso-8859-1?Q?Andr=E9?= <jean-pierre.andre@wanadoo.fr>
Cc: Eric Blake <ebb9@byu.net>, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>

Jean-Pierre Andr=E9 <jean-pierre.andre@wanadoo.fr> writes:

> Hi again,

Hi,

>> Well, the problem seems in fuse_lib_setattr() and ntfs_fuse_setattr()
>> (lowlevel op too).
>>
>> The both functions is requiring "ATIME | MTIME". Doesn't it mean the
>> ntfs-3g can't set only MTIME like above utimensat()?
>>    =

>
> With ntfs-3g this is not directly possible, because
> the interface does not provide flags telling which
> timestamps should be updated. The only way would
> be fuse feeding both values (even though unchanged)
> before calling ntfs-3g. This is true for all versions of
> ntfs-3g.

Yes, with fuse_operations. It is why I'm saying the issue is libfuse or
ntfs-3g.

But I noticed ntfs-3g is including libfuse-lite sources and use it with
static link (I might be wrong here, because I just looked ntfs-3g source
slightly). AFAIK, the fuse of kernel part is passing the flags of some
sort of detail always.

[BTW, the code of that part in kernel may be the following,

fs/fuse/dir.c:iattr_to_fattr(),

	if (ivalid & ATTR_ATIME) {
		arg->valid |=3D FATTR_ATIME;
		arg->atime =3D iattr->ia_atime.tv_sec;
		arg->atimensec =3D iattr->ia_atime.tv_nsec;
		if (!(ivalid & ATTR_ATIME_SET))
			arg->valid |=3D FATTR_ATIME_NOW;
	}
	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
		arg->valid |=3D FATTR_MTIME;
		arg->mtime =3D iattr->ia_mtime.tv_sec;
		arg->mtimensec =3D iattr->ia_mtime.tv_nsec;
		if (!(ivalid & ATTR_MTIME_SET))
			arg->valid |=3D FATTR_MTIME_NOW;
	}
]

So, if libfuse-lite was fixed to supported that update request, it would
be able to do even if fuse_operations.  I.e. in libfuse-lite, emulate
"ATIME | MTIME" request if "MTIME" only (pass unchanged original atime),
then call ->utime() callback. (or adds new utime2 callback with flags, or
something other solutions)

Or, if that request is known limitation of fuse_operations, I think it
would be clear state and ok. The fs needs to use lowlevel op to support
that.

> With lowntfs-3g (release candidate only), this could
> be possible.... but this is not implemented, as the
> case was never found up to now. I can provide you
> with a patch,... if fuse can feed in the flags selectively.

Yes.  AFAIK, fuse of kernel part is passing FATTR_MTIME without
FATTR_ATIME to userland (i.e. FUSE_SET_ATTR_ATIME and
FUSE_SET_ATTR_MTIME in libfuse).

I think it's good to implement if it's not design decision of ntfs-3g.

[BTW, just my guess though, it would be good to use "if (vaild &
ATTR_XXX)" style, not "switch()" to support various combinations of
flags]

Thanks.
-- =

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
