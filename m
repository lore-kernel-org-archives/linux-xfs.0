Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5GDt0fE131620 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 08:55:00 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9523F3D06E7
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 06:57:36 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	tRLSRVHbADBj1Dud for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 06:57:36 -0700 (PDT)
Received: by iwn33 with SMTP id 33so2906144iwn.26
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 06:57:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100616133433.GA16437@infradead.org>
References: <AANLkTilrwmh6n7yYkqyvy_y5-bgS-BEDept0WlLg5GE1@mail.gmail.com>
	<AANLkTikGFq8iv4S3QWp5ZCvXJsjuiP2tKweSl6QwHc6U@mail.gmail.com>
	<20100616121142.GA22317@infradead.org>
	<AANLkTimVtpQuRZpOJ4IGlFzRqWG6XaYGzvUnDuF06MyG@mail.gmail.com>
	<20100616133433.GA16437@infradead.org>
Date: Wed, 16 Jun 2010 09:57:35 -0400
Message-ID: <AANLkTimJHo3zfi0t96vVlTYgDswh8QtsptoTNkVK7Eb9@mail.gmail.com>
Subject: Re: [Security] XFS swapext ioctl minor security issues
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
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
Cc: security@kernel.org, aelder@sgi.com, Eugene Teo <eugeneteo@kernel.sg>, xfs@oss.sgi.com

I removed the part of the patch dealing with suid/sgid bits - your
reasoning seems good, we clearly don't want to just drop the suid/sgid
bits. =A0I was just trying to point out the case where the caller is not
the owner and has write access to the file; since in the ordinary case
writing to that file would result in dropping the suid bit, I thought
this ioctl should try to replicate that behavior.


Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

diff -up fs/xfs/xfs_dfrag.c.orig fs/xfs/xfs_dfrag.c
--- fs/xfs/xfs_dfrag.c.orig =A0 =A0 2010-06-15 09:16:05.000000000 -0400
+++ fs/xfs/xfs_dfrag.c =A02010-06-16 09:47:01.000000000 -0400
@@ -69,7 +69,9 @@ xfs_swapext(
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
=A0 =A0 =A0 =A0}

- =A0 =A0 =A0 if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEN=
D)) {
+ =A0 =A0 =A0 if (!(file->f_mode & FMODE_WRITE) ||
+ =A0 =A0 =A0 =A0 =A0 !(file->f_mode & FMODE_READ) ||
+ =A0 =A0 =A0 =A0 =A0 =A0(file->f_flags & O_APPEND)) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D XFS_ERROR(EBADF);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_put_file;
=A0 =A0 =A0 =A0}
@@ -81,7 +83,8 @@ xfs_swapext(
=A0 =A0 =A0 =A0}

=A0 =A0 =A0 =A0if (!(tmp_file->f_mode & FMODE_WRITE) ||
- =A0 =A0 =A0 =A0 =A0 (tmp_file->f_flags & O_APPEND)) {
+ =A0 =A0 =A0 =A0 =A0 !(tmp_file->f_mode & FMODE_READ) ||
+ =A0 =A0 =A0 =A0 =A0 =A0(tmp_file->f_flags & O_APPEND)) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D XFS_ERROR(EBADF);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_put_tmp_file;
=A0 =A0 =A0 =A0}




On Wed, Jun 16, 2010 at 9:34 AM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Wed, Jun 16, 2010 at 09:07:10AM -0400, Dan Rosenberg wrote:
>> Sure thing. =A0This patch is against 2.6.34, but it appears that it can
>> apply to >=3D 2.6.25. =A0Let me know if you need a fix for < 2.6.25.
>>
>> For those new to the conversation, this patch prevents user "foo" from
>> using the SWAPEXT ioctl to swap a write-only file owned by user "bar"
>> into a file owned by "foo" and subsequently reading it. =A0It does so by
>> checking that the file descriptors passed to the ioctl are also opened
>> for reading.
>
> This part is okay. =A0If you provide a Signed-off-by: line it
> can be put into the tree ASAP.
>
>> In addition, after swapping any suid/sgid bits should be
>> cleared.
>
> I'm still trying to understand this one. =A0Clearly we do not want to
> simply drop the suid/sgid bits here - swapext is just supposed to
> optimize file layout, but not change i_mode. =A0So if the suid bit
> really is a risk here we need to refuse to swapext it.
>
> What's the scenario here:
>
> =A0- swapext is called by the owner and the suid bit is set, or
> =A0 the owner is member of the group and the sgid bit is set,
> =A0 this should be fine.
> =A0- the caller is not the owner, but has write access to the file.
> =A0 an actual write to change the data by the user would already drop
> =A0 the bits, so in theory swapext should be fine. =A0But we might lose
> =A0 some important metadata in extended attributes that previously
> =A0 might have made the file safe, say per-file capabilities.
> =A0 I'd love to here the exact scenario, but for let's play safe and
> =A0 refuse the swapex for that case, by doing something:
>
> /*
> =A0* SGID without any exec bits is just a mandatory locking mark.
> =A0*/
> #define is_sgid(mode) \
> =A0 =A0 =A0 =A0(((mode) & (S_ISGID|S_IXGRP)) =3D=3D (S_ISGID|S_IXGRP))
>
> ...
>
> =A0 =A0 =A0 =A0struct inode *inode, *tmp_inode;
>
> ...
>
> =A0 =A0 =A0 =A0inode =3D file->f_path.dentry->d_inode;
> =A0 =A0 =A0 =A0tmp_inode =3D tmp_file->f_path.dentry->d_inode;
>
> ...
>
> =A0 =A0 =A0 =A0error =3D XFS_ERROR(EPERM);
> =A0 =A0 =A0 =A0if ((inode->i_mode & S_ISUID) && !is_owner_or_cap(inode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0if ((tmp_inode->i_mode & S_ISUID) && !is_owner_or_cap(tmp_=
inode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0if (is_sgid(inode->i_mode) && !in_group_p(inode->i_gid))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0if (is_sgid(tmp_inode->i_mode) && !in_group_p(tmp_inode->i=
_gid))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
