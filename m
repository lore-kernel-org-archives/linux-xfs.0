Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:37736 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdIRVzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 17:55:47 -0400
Received: by mail-io0-f193.google.com with SMTP id 93so2604200iol.4
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 14:55:47 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C60D45FE-F68C-4B85-AB90-DCE219428DA8";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Date: Mon, 18 Sep 2017 15:55:40 -0600
In-Reply-To: <20170918204838.GW6540@magnolia>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org


--Apple-Mail=_C60D45FE-F68C-4B85-AB90-DCE219428DA8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Sep 18, 2017, at 2:48 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> On Mon, Sep 18, 2017 at 05:52:24PM +0200, Lukas Czerner wrote:
>> Return all fallcoate modes supported by xfs file system.
>> 
>> Cc: linux-xfs@vger.kernel.org
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>> fs/xfs/xfs_file.c | 6 +++++-
>> 1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index ebdd0bd..85e06c6 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -746,7 +746,8 @@ xfs_file_write_iter(
>> #define	XFS_FALLOC_FL_SUPPORTED						\
>> 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
>> 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
>> -		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
>> +		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE |	\
>> +		 FALLOC_FL_QUERY_SUPPORT | FALLOC_FL_PREALLOC_RANGE)
>> 
>> STATIC long
>> xfs_file_fallocate(
>> @@ -768,6 +769,9 @@ xfs_file_fallocate(
>> 	if (mode & ~XFS_FALLOC_FL_SUPPORTED)
>> 		return -EOPNOTSUPP;
>> 
>> +	if (mode & FALLOC_FL_QUERY_SUPPORT)
>> +		return XFS_FALLOC_FL_SUPPORTED;
> 
> Urk, manpage update describing the goals of the query interface and how
> this is supposed to work is needed.
> 
> Are we required to return only the mode flags that would reasonably be
> expected to work on this file, or the fs in general?  Do we return zero
> if the file is immutable (I guess the fd has to be O_RDONLY?) or if the
> fs is readonly?
> 
> And like hch said, why not {f,}pathconf?

The problem with pathconf() is that this is just made up by GlibC, and
doesn't actually communicate with the kernel or the filesystem at all.
For example, _PC_LINK_MAX does not return different values for ext2/ext4
filesystems based on feature flags, only what is hard-coded into GlibC
based on the filesystem magic.  This is not going to work as a per-file
source of information.

For example, even though EXT4_LINK_MAX has been 65000 for many years,
GlibC reports 32000 for an ext4 filesystem since it only uses the magic:

$ df -T /
Filesystem     Type 1024-blocks     Used Available Capacity Mounted on
/dev/mapper/vg_twoshoes-lvroot
               ext4    25991484 22475376   2205504      92% /
$ strace getconf LINK_MAX /
:
:
statfs("/", {f_type="EXT2_SUPER_MAGIC", f_bsize=4096, f_blocks=6497871,
	     f_bfree=879030, f_bavail=551379, f_files=819200, f_ffree=405130,
	     f_fsid={1950084367, 1019861045}, f_namelen=255}) = 0
write(1, "32000\n",) = 6


Cheers, Andreas






--Apple-Mail=_C60D45FE-F68C-4B85-AB90-DCE219428DA8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZwEDepIg59Q01vtYRAh5+AJ9DzQ6CbuuIxSZV/JfMXdP8URMD1gCgz0A4
jLmP51FjW1d4R4jQAlYS+fs=
=TDXL
-----END PGP SIGNATURE-----

--Apple-Mail=_C60D45FE-F68C-4B85-AB90-DCE219428DA8--
