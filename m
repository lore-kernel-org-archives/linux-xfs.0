Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBMGFTGE142658 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 10:15:30 -0600
Received: from smtp2b.orange.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B6EF1C0D197
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 08:16:11 -0800 (PST)
Received: from smtp2b.orange.fr (smtp2b.orange.fr [80.12.242.146]) by
	cuda.sgi.com with ESMTP id ngRgDE73hw3gR0eZ for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2009 08:16:11 -0800 (PST)
Message-ID: <4B30F0C9.2020702@wanadoo.fr>
Date: Tue, 22 Dec 2009 17:16:09 +0100
From: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
MIME-Version: 1.0
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp>
	<4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp>
	<4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp>
	<4B30B67A.7080703@wanadoo.fr> <87ljgvi1an.fsf@devron.myhome.or.jp>
In-Reply-To: <87ljgvi1an.fsf@devron.myhome.or.jp>
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

>> Hi again,
>>      =

> Hi,
>
>    =

>>> Well, the problem seems in fuse_lib_setattr() and ntfs_fuse_setattr()
>>> (lowlevel op too).
>>>
>>> The both functions is requiring "ATIME | MTIME". Doesn't it mean the
>>> ntfs-3g can't set only MTIME like above utimensat()?
>>>
>>>        =

>> With ntfs-3g this is not directly possible, because
>> the interface does not provide flags telling which
>> timestamps should be updated. The only way would
>> be fuse feeding both values (even though unchanged)
>> before calling ntfs-3g. This is true for all versions of
>> ntfs-3g.
>>      =

> Yes, with fuse_operations. It is why I'm saying the issue is libfuse or
> ntfs-3g.
>
> But I noticed ntfs-3g is including libfuse-lite sources and use it with
> static link (I might be wrong here, because I just looked ntfs-3g source
> slightly). AFAIK, the fuse of kernel part is passing the flags of some
> sort of detail always.
>    =


Use of fuse-lite is optional, and static linking also
(both depend on your configure options),

> [BTW, the code of that part in kernel may be the following,
>
> fs/fuse/dir.c:iattr_to_fattr(),
>
>    =

[...]
> So, if libfuse-lite was fixed to supported that update request, it would
> be able to do even if fuse_operations.  I.e. in libfuse-lite, emulate
> "ATIME | MTIME" request if "MTIME" only (pass unchanged original atime),
> then call ->utime() callback. (or adds new utime2 callback with flags, or
> something other solutions)
>    =


I will port to fuse-lite the patch which Miklos has
just sent.

> Or, if that request is known limitation of fuse_operations, I think it
> would be clear state and ok. The fs needs to use lowlevel op to support
> that.
>
>    =

>> With lowntfs-3g (release candidate only), this could
>> be possible.... but this is not implemented, as the
>> case was never found up to now. I can provide you
>> with a patch,... if fuse can feed in the flags selectively.
>>      =

> Yes.  AFAIK, fuse of kernel part is passing FATTR_MTIME without
> FATTR_ATIME to userland (i.e. FUSE_SET_ATTR_ATIME and
> FUSE_SET_ATTR_MTIME in libfuse).
>
> I think it's good to implement if it's not design decision of ntfs-3g.
>
> [BTW, just my guess though, it would be good to use "if (vaild&
> ATTR_XXX)" style, not "switch()" to support various combinations of
> flags]
>    =


Might be better, ... or not. Setting both mtime
and atime is much simpler than setting each one
individually. So both methods will end up having
to process three different situations.

I suggest I port Miklos patch to fuse-lite soon,
and delay the low-level case (and microsecond
precision) until January. Does that suit your needs ?

Also : there is a common case of mis-configuration
in which gid is set in the mount options and uid
is not. As a consequence files appear as owned
by root and utime() is forbidden to plain users.

So you should first check your mount options.
And since ntfs-2009.11.14 standard ownership
and permissions are fully supported provided a
proper configuration file has been set.

Regards

Jean-Pierre



> Thanks.
>    =


-- =

JP Andr=E9
email jean-pierre.andre@wanadoo.fr




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
