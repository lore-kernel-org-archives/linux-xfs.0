Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B26DD7FA3
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 17:12:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 953508F8059
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 15:12:23 -0800 (PST)
Received: from mail-pd0-f172.google.com (mail-pd0-f172.google.com
	[209.85.192.172]) by cuda.sgi.com with ESMTP id
	ksu1ZnowGdHv50C0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Feb 2014 15:12:19 -0800 (PST)
Received: by mail-pd0-f172.google.com with SMTP id p10so15501760pdj.3
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 15:12:18 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 1/6] ext4: Update inode i_size after the preallocation
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1392649703-10772-2-git-send-email-lczerner@redhat.com>
Date: Mon, 17 Feb 2014 16:12:14 -0700
Message-Id: <9288BED9-A44E-4ACC-9A3D-BC086AB4E121@dilger.ca>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<1392649703-10772-2-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3596242918601154807=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com


--===============3596242918601154807==
Content-Type: multipart/signed; boundary="Apple-Mail=_FCB0203D-3913-401C-B3E8-80734072523A"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_FCB0203D-3913-401C-B3E8-80734072523A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 17, 2014, at 8:08 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> Currently in ext4_fallocate we would update inode size, c_time and =
sync
> the file with every partial allocation which is entirely unnecessary. =
It
> is true that if the crash happens in the middle of truncate we might =
end
> up with unchanged i size, or c_time which I do not think is really a
> problem - it does not mean file system corruption in any way. Note =
that
> xfs is doing things the same way e.g. update all of the mentioned =
after
> the allocation is done.

I'm OK with this part.

> This commit moves all the updates after the allocation is done. In
> addition we also need to change m_time as not only inode has been =
change
> bot also data regions might have changed (unwritten extents).

I don't necessarily agree about this.  Calling fallocate() will not
change the user-visible data at all, so there is no reason to e.g.
do a new backup of the file or reprocess the contents, or any other
reason that an application cares about a changed mtime.

Cheers, Andreas

> Also we do
> not need to be paranoid about changing the c_time and m_time only if =
the
> actual allocation have happened, we can change it even if we try to
> allocate only to find out that there are already block allocated. It's
> not really a big deal and it will save us some additional complexity.
>=20
> Also use ext4_debug, instead of ext4_warning in #ifdef EXT4FS_DEBUG
> section.
>=20
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> fs/ext4/extents.c | 86 =
+++++++++++++++++++++----------------------------------
> 1 file changed, 32 insertions(+), 54 deletions(-)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 10cff47..6a52851 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4513,36 +4513,6 @@ retry:
> 	ext4_std_error(inode->i_sb, err);
> }
>=20
> -static void ext4_falloc_update_inode(struct inode *inode,
> -				int mode, loff_t new_size, int =
update_ctime)
> -{
> -	struct timespec now;
> -
> -	if (update_ctime) {
> -		now =3D current_fs_time(inode->i_sb);
> -		if (!timespec_equal(&inode->i_ctime, &now))
> -			inode->i_ctime =3D now;
> -	}
> -	/*
> -	 * Update only when preallocation was requested beyond
> -	 * the file size.
> -	 */
> -	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> -		if (new_size > i_size_read(inode))
> -			i_size_write(inode, new_size);
> -		if (new_size > EXT4_I(inode)->i_disksize)
> -			ext4_update_i_disksize(inode, new_size);
> -	} else {
> -		/*
> -		 * Mark that we allocate beyond EOF so the subsequent =
truncate
> -		 * can proceed even if the new size is the same as =
i_size.
> -		 */
> -		if (new_size > i_size_read(inode))
> -			ext4_set_inode_flag(inode, =
EXT4_INODE_EOFBLOCKS);
> -	}
> -
> -}
> -
> /*
>  * preallocate space for a file. This implements ext4's fallocate file
>  * operation, which gets called from sys_fallocate system call.
> @@ -4554,7 +4524,7 @@ long ext4_fallocate(struct file *file, int mode, =
loff_t offset, loff_t len)
> {
> 	struct inode *inode =3D file_inode(file);
> 	handle_t *handle;
> -	loff_t new_size;
> +	loff_t new_size =3D 0;
> 	unsigned int max_blocks;
> 	int ret =3D 0;
> 	int ret2 =3D 0;
> @@ -4594,12 +4564,15 @@ long ext4_fallocate(struct file *file, int =
mode, loff_t offset, loff_t len)
> 	 */
> 	credits =3D ext4_chunk_trans_blocks(inode, max_blocks);
> 	mutex_lock(&inode->i_mutex);
> -	ret =3D inode_newsize_ok(inode, (len + offset));
> -	if (ret) {
> -		mutex_unlock(&inode->i_mutex);
> -		trace_ext4_fallocate_exit(inode, offset, max_blocks, =
ret);
> -		return ret;
> +
> +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> +	     offset + len > i_size_read(inode)) {
> +		new_size =3D offset + len;
> +		ret =3D inode_newsize_ok(inode, new_size);
> +		if (ret)
> +			goto out;
> 	}
> +
> 	flags =3D EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
> 	if (mode & FALLOC_FL_KEEP_SIZE)
> 		flags |=3D EXT4_GET_BLOCKS_KEEP_SIZE;
> @@ -4623,28 +4596,14 @@ retry:
> 		}
> 		ret =3D ext4_map_blocks(handle, inode, &map, flags);
> 		if (ret <=3D 0) {
> -#ifdef EXT4FS_DEBUG
> -			ext4_warning(inode->i_sb,
> -				     "inode #%lu: block %u: len %u: "
> -				     "ext4_ext_map_blocks returned %d",
> -				     inode->i_ino, map.m_lblk,
> -				     map.m_len, ret);
> -#endif
> +			ext4_debug("inode #%lu: block %u: len %u: "
> +				   "ext4_ext_map_blocks returned %d",
> +				   inode->i_ino, map.m_lblk,
> +				   map.m_len, ret);
> 			ext4_mark_inode_dirty(handle, inode);
> 			ret2 =3D ext4_journal_stop(handle);
> 			break;
> 		}
> -		if ((map.m_lblk + ret) >=3D (EXT4_BLOCK_ALIGN(offset + =
len,
> -						blkbits) >> blkbits))
> -			new_size =3D offset + len;
> -		else
> -			new_size =3D ((loff_t) map.m_lblk + ret) << =
blkbits;
> -
> -		ext4_falloc_update_inode(inode, mode, new_size,
> -					 (map.m_flags & EXT4_MAP_NEW));
> -		ext4_mark_inode_dirty(handle, inode);
> -		if ((file->f_flags & O_SYNC) && ret >=3D max_blocks)
> -			ext4_handle_sync(handle);
> 		ret2 =3D ext4_journal_stop(handle);
> 		if (ret2)
> 			break;
> @@ -4654,6 +4613,25 @@ retry:
> 		ret =3D 0;
> 		goto retry;
> 	}
> +
> +	handle =3D ext4_journal_start(inode, EXT4_HT_INODE, 2);
> +	if (IS_ERR(handle))
> +		goto out;
> +
> +	inode->i_mtime =3D inode->i_ctime =3D ext4_current_time(inode);
> +
> +	if (ret > 0 && new_size) {
> +		if (new_size > i_size_read(inode))
> +			i_size_write(inode, new_size);
> +		if (new_size > EXT4_I(inode)->i_disksize)
> +			ext4_update_i_disksize(inode, new_size);
> +	}
> +	ext4_mark_inode_dirty(handle, inode);
> +	if (file->f_flags & O_SYNC)
> +		ext4_handle_sync(handle);
> +
> +	ext4_journal_stop(handle);
> +out:
> 	mutex_unlock(&inode->i_mutex);
> 	trace_ext4_fallocate_exit(inode, offset, max_blocks,
> 				ret > 0 ? ret2 : ret);
> --=20
> 1.8.3.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_FCB0203D-3913-401C-B3E8-80734072523A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUwKXTnKl2rkXzB/gAQID4BAAuZpAwsZ645L8aWEPVTXgvfgQbml/dqvf
BKOBiVTXIhmcxBWPrFjkwy/wDQlg7Q3HAZOOxizEDN6pjfYUlOucIUGF5GOKnYv/
X2gUe4AtZOuU1jDV0bW5AwXv9cqWIYK7KdM1zqFhBBT3T2Bs/hHrh+AbLBksyOhZ
oBeVRMElbWpHpHEIma0+FGKuCeDlA/jfa8wIDkKyAnAR+4nmbOclWC48UuVcBqr2
JRE+aX5kicm0sTFlEB23wZQ2cHN2YC4v8e5SK+NAxJ0xcpTXVj71D4ouKLPjxmiF
5txEznarmqpP0abr02g85nnZIzu8ujSAkBD6q6RQxvs22O+3vvlgo6u4+2B81809
Nkf1nJ+P5yqSpUVB/gzj/GggMqAOQWjUCpPvqobSnraDoO8whB0Tfnk0E/Jpq/GX
iFB75W94jcK/RvDDoIifKtiah9OMDMGZO5em9EVxRCFLgJhosbvUiDvns3nSe/yB
ucGFe0fntU4H8T7GxwFac0y9UUmt+6M5rUIt+MS/Isrb7doD2LodDAV8MHHSxCZz
YQ2Xdk9w/ICcs+9G3Y8fizEO+CYRtTnf6ZIWSutyZEfCZmciu60iZ7gHHeb0DJKh
DxQpozmYiRlr8mQL+Qurn/u6bH1zW0x8QJk42FzG1wn/WBmr/BoTQLFKeyMtowAJ
d2UgGDlQT0w=
=c8xK
-----END PGP SIGNATURE-----

--Apple-Mail=_FCB0203D-3913-401C-B3E8-80734072523A--


--===============3596242918601154807==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3596242918601154807==--
