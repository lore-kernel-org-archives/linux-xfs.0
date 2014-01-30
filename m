Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A269C7F57
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:57:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88D92304064
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 10:57:20 -0800 (PST)
Received: from mail-pb0-f50.google.com (mail-pb0-f50.google.com
	[209.85.160.50]) by cuda.sgi.com with ESMTP id TIda2vMPtGxVuzdP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jan 2014 10:57:16 -0800 (PST)
Received: by mail-pb0-f50.google.com with SMTP id rq2so3471849pbb.37
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 10:57:15 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [RFC] A draft for making ext4 support project quota
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20140129034824.GA12757@gmail.com>
Date: Thu, 30 Jan 2014 11:57:10 -0700
Message-Id: <A5AD0D66-C4F5-4177-9F87-E3BC59B348B8@dilger.ca>
References: <20140128064248.GA8653@gmail.com>
	<20140128143514.GB13676@quack.suse.cz>
	<20140129034824.GA12757@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3756582264499965772=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>


--===============3756582264499965772==
Content-Type: multipart/signed; boundary="Apple-Mail=_7F6A7B36-3439-4BCC-9079-838BC4EF6EB0"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_7F6A7B36-3439-4BCC-9079-838BC4EF6EB0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 28, 2014, at 8:48 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Tue, Jan 28, 2014 at 03:35:14PM +0100, Jan Kara wrote:
>> On Tue 28-01-14 14:42:49, Zheng Liu wrote:
>>> For project quota, the key issue is how to handle link(2)/rename(2). =
 We
>>> summarize the behaviour in xfs as following.
>>>=20
>>> *Note*
>>> + unaccounted dir
>>> x accounted dir
>>>=20
>>> link(2)
>>> -------
>>> 		+		x
>>> +		ok		error (EXDEV)
>>> x		ok		error (EXDEV)

Presumably this accounted-to-accounted link() is only an error if
it is between directories of two different projects?

>>> rename(2)
>>> ---------
>>> 		+		x
>>> +		ok		ok
>>> x		wrong		ok
>>=20
>>  So moving unaccounted file/dir into an accounted dir would be OK? =
How is
>> that?
>=20
> Actually xfs will return EXDEV error when we try to move unaccounted
> file/dir into an accounted dir.  Then userspace tools (e.g. mv(1)) =
will
> use create(2)/read(2)/write(2) syscalls to create these files/dirs =
from
> scratch, and get the same id from their parent.

Why wouldn't renaming an unaccounted file into an accounted directory
just be implemented by doing the equivalent of chown() to change the
project ID and setting the quota?  That could avoid a HUGE amount of
data copying for large files.

> So from the result we can see it is ok.  Quote from Dave Chinner's
> comment: "that quota is accounted for when moving *into* an accounted
> directory tree, not when moving out of a directory tree."

Sure, but IMHO returning -EXDEV in this case is a bit of a hack, and
increases the overhead of doing a rename within the filesystem a lot.

>>> Further, project quota *cannot* be used with group quota at the same =
time.
>>> On the other hand user quota and project quota can be used =
simultaneously.
>>  There's no fundamental reason for this and XFS folks actually =
recently
>> worked to remove this limitation. I don't think we should carry it =
over to
>> ext4.
>=20
> Thanks for pointing it out.
>=20
>>=20
>>> 2. =
http://xfs.org/index.php/XFS_FAQ#Q:_Quota:_What.27s_project_quota.3F
>>>=20
>>> Design
>>> =3D=3D=3D=3D=3D=3D
>>>=20
>>> Project id
>>> ----------
>>> We have two options to store project id in inode.  a) define a new =
member
>>> in ext4_inode structure; b) store project id in xattr.
>>>=20
>>> Option a)
>>> Pros:
>>>  * Only need 4 bytes if we use a '__le32' type to store it
>>>=20
>>> Cons:
>>>  * Needs to change disk layout of ext4 inode
>>>=20
>>> Option b)
>>> Pros:
>>>  * Don't need to change disk layout
>>>=20
>>> Cons:
>>>  * Take 24 bytes
>>  Cons of the b) is also that it's somewhat messier to get / set =
project id
>> from kernel. So I'm more in favor of a). I even think we could =
introduce
>> the additional id rather seamlessly using i_extra_i_size but I have =
to have
>> a look into details. Anyway I guess we can talk about the options at =
LSF.
>=20
> I don't have a bias against both of two options.  It seems that we can
> introduce a new id seamlessly using i_extra_isize.
>=20
> 1) old kernel + new disk layout
> We can read/write new inode because new id doesn't be changed.
>=20
> 2) new kernel + old disk layout
> We can use EXT4_FITS_IN_INODE to check whether new id can fit into an
> inode or not.  We will check and report error when we try to enable
> project quota on a file system with old disk layout in =
ext4_fill_super().

We also have a patch for e2fsck to increase i_extra_isize to ensure it
has enough space to hold a larger ext4_inode size, if this is required
for an existing filesystem that is upgraded to use this feature:

=
http://git.whamcloud.com/?p=3Dtools/e2fsprogs.git;a=3Dcommit;h=3De7653a1d3=
653d0bffc4617d8be8ce0a2c18b54c1

and tests for this feature:

=
http://git.whamcloud.com/?p=3Dtools/e2fsprogs.git;a=3Dcommit;h=3D318a2688a=
a34e7dab383137fffaa413b882d13df

Cheers, Andreas

>>> Here I propose to use option *b)* because it is easy for us to =
support
>>> project id and we don't need to worry about changing disk layout.  =
But
>>> I raise another issue here.  Now inline_data feature has been =
applied.
>>> After waiting inline_data feature stable, we'd better enable =
inline_data
>>> feature by default when we create a new ext4 file system.  Now the =
inode
>>> size is 256 bytes by default, we have 72 bytes extra size to store
>>> inline data:
>>>  256 (default inode size) -
>>> 	156 (ext4_inode) + 4 (ext4_xattr_ibody_header) +
>>> 	20 (ext4_xattr_entry) + 4 (value) =3D 72
>>>=20
>>> If we store project id in xattr, we just leave 48 bytes for inline =
data.
>>> I am not sure whether or not it is too small for some users.
>>>=20
>>> When we store project id in xattr, we will use {get,set}fattr to =
get/set
>>> project id.  Thus we don't need to change userspace tool to =
manipulate
>>> project id.  Meanwhile a _INHERENT flag for inode needs to be =
defined to
>>> indicate that new directory creating in a directory with this flag =
will
>>> get the same project id and get marked with this flag. =20
>>>=20
>>> Project quota API
>>> -----------------
>>> For keeping consistency with xfs, here I propose to use Q_X* flag to
>>> communicate with kernel via quotactl(2) as we discussed.  Due to =
this we
>>> need to define some callback functions to support Q_X* flag.  That =
means
>>> that ext4 will support two quota flag sets for being compatible with
>>> legacy userspace tools and use the same quotactl API to communicate =
with
>>> kernel for project id like xfs.
>>  We can as well extend current VFS API to cover also project quotas. =
That
>> would make things somewhat more logical from userspace POV.=20
>=20
> Your meaning is that we support Q_* flag and Q_X* flag simultaneously?
>=20
> Thanks,
>                                                - Zheng
>=20
>>=20
>>> Currently quota subsystem in vfs doesn't handle project quota.  Thus =
we
>>> need to make quota subsystem handle project id properly (e.g.
>>> dquot_transfer, dquot_initialize).  We need to define a new callback
>>> function in order to get project id.  Now in vfs we can access =
uid/gid
>>> directly from inode, but we have no way to get project id.  A =
generic
>>> callback function is defined to handle uid/gid.  The file system =
itself
>>> can handle project id.  Until now only ext4 needs to implement this
>>> callback function by itself because xfs doesn't use vfs quota =
subsystem.
>>  So we need to get ids from external structures only in two places. =
One is
>> dquot_initialize() and the other is dquot_transfer(). Instead of =
providing
>> callback to get project id, we could just create a variant of these =
functions
>> which will get required ids from a passed array instead of directly =
from
>> the inode.
>>=20
>>> For handling link(2)/rename(2) like xfs, we only allow hard link or
>>> rename operation when the project ids are the same.  Otherwise we =
will
>>> return EXDEV error to notify the user.
>>>=20
>>> Quota-tools
>>> -----------
>>> Now quota-tools (e.g. quotaon, edquota, etc...) don't support =
project
>>> quota.  Thus we need to make it support project id.  I believe that =
Li
>>> Xi did some works on quota-tools.
>>>=20
>>> E2fsprogs
>>> ---------
>>> After supporting project quota, we need to change e2fsck(1) to make =
sure
>>> that all sub-directories with _INHERENT flag have the same project =
id.
>>> Meanwhile we need to make chattr(1) set/clear _INHERENT flag.
>>=20
>> 								Honza
>> --=20
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR


Cheers, Andreas






--Apple-Mail=_7F6A7B36-3439-4BCC-9079-838BC4EF6EB0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUuqghnKl2rkXzB/gAQLpgxAAipYrhFoOdVzfh97k1OTiRAO8gvKPJe5F
y3Ai+JJuBio2bShgs8nZ8bDzpskdH9xBTfmqgWZ9meXteMpeoHDbOMYmKSxgHS8v
/NtWP3Ma8Nk3sa4LuJ9lLj4keX78QrKB1Xln/KmxK4wpfOP6UoYPwv+ULU9T4Ch5
mDalZ7t27YlpyGKSwn2YTBMbve1jab06Jt/107eyD1G4hMarw6aKxjc20oTg+tv4
6ALoSWhaG8N/xaOnaw4bVeijrJC+DbIctlv2L9ygXydMrgpdFFXP5Zja/4gdDsUU
e+d0d/ur6FX6cxmwbCYo44r0tPG1mrPh9qAA4DeYpYz6WA+wPn+LZ3zmPEGYd872
tNXGGq4WS72OVplnkdqtvL9vdTT5lNUhNy+gAl1NyTBrmqSUw0u2xU+EkRAvAJdh
pszXsDkoJ/+9MKxtOW6A/Av3owTdtPbyQpS1Cv4J3SJOG2z6iSsg963+CwL0x4Lf
hZi9jOZ8M7EIPoC4c5f0LsU8eqzqC3oP/TxFe+KATxNlK6J6xQ/LXxoS7sJ/3EaV
MV1WjYCAUP16Bnw1nWLzsRBamHo5dROPa3hI2j6U97UOEpnE8QDfaVecUFSh7YFs
p7rymZ/qcKlnCazmxIgSQQTVgytDa+n9OT9BB6Z8KpNQZLSovYUsvhY2ewvc6dEY
LthhXeKaYjQ=
=9jnf
-----END PGP SIGNATURE-----

--Apple-Mail=_7F6A7B36-3439-4BCC-9079-838BC4EF6EB0--


--===============3756582264499965772==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3756582264499965772==--
