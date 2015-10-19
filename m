Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0B5C7F60
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 12:42:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE4E5304059
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 10:42:06 -0700 (PDT)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id ngOgkDpDuajmHy1S
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Oct 2015 10:42:05 -0700 (PDT)
Received: by padhk11 with SMTP id hk11so35809802pad.1
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 10:42:04 -0700 (PDT)
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <5625182C.3050007@gmail.com>
Date: Mon, 19 Oct 2015 10:39:15 -0600
Message-Id: <5DE0621B-7308-41C9-A147-32E0270B28A8@dilger.ca>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
	<CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
	<5625182C.3050007@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6338982929873492575=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>


--===============6338982929873492575==
Content-Type: multipart/signed; boundary="Apple-Mail=_3404C98A-6D6D-47D4-B89F-1E37AFFC17BB"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_3404C98A-6D6D-47D4-B89F-1E37AFFC17BB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 19, 2015, at 10:19 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> =
wrote:
>=20
> On 2015-10-19 11:34, Andreas Gruenbacher wrote:
>> On Mon, Oct 19, 2015 at 3:16 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
>>>>=20
>>>> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>>=20
>>>>> I would like to re-iterate, on both XFS and ext4, I _really_ think =
this
>>>>> should be a ro_compat flag, and not an incompat one.  If a person =
has the
>>>>> ability to mount the FS (even if it's a read-only mount), then =
they by
>>>>> definition have read access to the file or partition that the =
filesystem
>>>>> is contained in, which means that any ACL's stored on the =
filesystem are
>>>>> functionally irrelevant,
>>>>=20
>>>> It is unfortunately not safe to make such a file system accessible =
to
>>>> other users, so the feature is not strictly read-only compatible.
>>>>=20
>>> OK, seeing as I wasn't particularly clear as to why I object to this =
in my
>>> other e-mail, let's try this again.
>>>=20
>>> Can you please explain exactly why it isn't safe to make such a =
filesystem
>>> accessible to other users?
>>=20
>> See here: http://www.spinics.net/lists/linux-ext4/msg49541.html
> OK, so to clarify, this isn't 'safe' because:
> 1. The richacls that exist on the filesystem won't be enforced.
> 2. Newly created files will have no ACL's set.
>=20
> It is worth noting that these are also issues with any kind of access =
control mechanism.  Using your logic, all LSM's need to set separate =
incompat feature flags in filesystems they are being used on, as should =
POSIX ACLs, and for that matter so should Samba in many circumstances, =
and any NFS system not using idmapping or synchronized/centralized user =
databases.  Now, if the SELinux (or SMACK, or TOMOYO) people had taken =
this approach, then I might be inclined to not complain (at least not to =
you, I'd be complaining to them about this rather poor design choice), =
but that is not the case, because (I assume) they realized that all this =
provides is a false sense of security.

I would tend to agree here.  Anyone who can mount the filesystem on a =
kernel
without RichACL support can do whatever they want, so at most having a
RO_COMPAT flag would serve as a reminder for accidental problems by a
sysadmin not in the know.  Using an INCOMPAT flag is just asking for =
major
headaches when someone needs to recover their filesystem on an old =
kernel
but doesn't provide any added safety.

Cheers, Andreas

> Issue 1, as I have said before, is functionally irrelevant for anyone =
who actually knows what they are doing; all you need for ext* is one of =
the myriad of programs for un-deleting files on such a filesystem (such =
as ext4magic or extundelete, and good luck convincing them to not allow =
being used when this flag is set), for BTRFS you just need the regular =
filesystem administration utilities ('btrfs restore' works wonders, and =
that one will _never_ honor any kind of permissions, because it's for =
disaster recovery), and while I don't know of any way to do this with =
XFS, that is only because I don't use XFS myself and have not had the =
need to provide tech support for anyone who does.  If somebody =
absolutely _needs_ a guarantee that the acls will be enforced, they need =
to be using whole disk encryption, not just acls, and even that can't =
provide such a guarantee.
>=20
> As for issue 2, that can be solved by making it a read-only compatible =
flag, which is what I was suggesting be done in the first place.  The =
only situation I can think of that this would cause an issue for is if =
the filesystem was not cleanly unmounted, and the log-replay doesn't set =
the ACL's, but mounting an uncleanly unmounted filesystem that has =
richacls on a kernel without support should fall into one of the =
following 2 cases more than 99% of the time:
> 1. The system crashed hard, and the regular kernel is un-bootable for =
some reason, in this case you're at the point of disaster recovery, =
should not be exposing _anything_ to a multi-user environment, and =
probably care a lot more about being able to get the system running =
again than about not accidentally creating a file with a missing ACL.
> 2. The filesystem was maliciously stolen in some way (either the =
hardware was acquired, or more likely, someone got an image of a still =
mounted filesystem), in which case all of my statements above regarding =
issue 1 apply.
>=20


Cheers, Andreas






--Apple-Mail=_3404C98A-6D6D-47D4-B89F-1E37AFFC17BB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBViUctXKl2rkXzB/gAQiVFg//WlCjN9eSwE5gEBtGcuYLlNHlyjvM5EoU
UAheHBujW+3QS6JFGykQuZdY1qNTgl5TeSFUXCnNprMd6Jp0XvKDtY600iXwwAmC
l8PQoYP7v3qwgtbfNUj7la9kcAYZY9u+GDmh1e32aLI0bP+KrBwXj9o4POWtdL6F
Z6TL7P/wBJCJj9UWVbintU8sIiMyPmnHsz52izdNoO1LOSIhfAy5XAjn9d8TED9Z
ZCwCbAP4c6GU/DhMceQMGuTR0BPUJyqzhoSAwEd+QxBm3D2N1BUhHbehiHq9r+uG
MSa49iOdJ6dj6KzkzFlroIX2xuPtofcxC8qYKC905rO5eQiYaU+P4raLfZpZa2pc
2pQi09rPOM0+8LnjyFIdKyYslhf8AwcEwLQimGoBJoWPwgnjTIUCU4xmADU0WeOG
IHV+dX3UNcI5wdXpI+vZlFHNyub4wBvty1JIuK1QkK94V2iuV0eb7PZIZwpxf5/9
LJQexMPTikhOvXqYd4u+8ZmGNrcq7iuOrt2+LOtxaRszRV9qRIZWctZ6n7lUSYAP
v9lNZ11QKldKQhpTaYR7ESQSlMf4+ecBPc0TumBfKW9QE0vWSTJ9vmnNLAsM1KVd
PDV8lw/OC6hg7DlQ0fWcv8pO17t0brZ+XpW9T3ZQ4KjktW5taYDzXcjDN430+FnC
bNhL6QX+4mQ=
=GnvZ
-----END PGP SIGNATURE-----

--Apple-Mail=_3404C98A-6D6D-47D4-B89F-1E37AFFC17BB--


--===============6338982929873492575==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6338982929873492575==--
