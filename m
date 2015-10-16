Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 360367F9E
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 12:31:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EED1C304053
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:31:40 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	JHvultkyyG4TflBd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:31:39 -0700 (PDT)
Received: by igbni9 with SMTP id ni9so18455134igb.1
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:31:39 -0700 (PDT)
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5621346E.5000500@gmail.com>
Date: Fri, 16 Oct 2015 13:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <1445008706-15115-22-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2470781031779763342=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This is a cryptographically signed message in MIME format.

--===============2470781031779763342==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080105070900080704090103"

This is a cryptographically signed message in MIME format.

--------------ms080105070900080704090103
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-16 11:17, Andreas Gruenbacher wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>
> This feature flag selects richacl instead of posix acl support on the
> file system. In addition, the "acl" mount option is needed for enabling=

> either of the two kinds of acls.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>   fs/ext4/ext4.h  |  6 ++++--
>   fs/ext4/super.c | 42 +++++++++++++++++++++++++++++++++---------
>   2 files changed, 37 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index fd1f28b..b97a3b1 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -991,7 +991,7 @@ struct ext4_inode_info {
>   #define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal forma=
t */
>   #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
>   #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */=

> -#define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */=

> +#define EXT4_MOUNT_ACL			0x08000	/* Access Control Lists */
>   #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mappi=
ng */
>   #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
>   #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
> @@ -1582,6 +1582,7 @@ static inline int ext4_encrypted_inode(struct ino=
de *inode)
>   #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree=
 */
>   #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
>   #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
> +#define EXT4_FEATURE_INCOMPAT_RICHACL		0x20000
I would like to re-iterate, on both XFS and ext4, I _really_ think this=20
should be a ro_compat flag, and not an incompat one.  If a person has=20
the ability to mount the FS (even if it's a read-only mount), then they=20
by definition have read access to the file or partition that the=20
filesystem is contained in, which means that any ACL's stored on the=20
filesystem are functionally irrelevant, and making this an incompat=20
feature will just complicate things further for people who have a=20
legitimate need to recover data.


--------------ms080105070900080704090103
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE2MTczMTI2WjBPBgkq
hkiG9w0BCQQxQgRAPhvf1wDQT+zY79/J/S+GlQuTEjNgTXDad8G8O18RNeFdjxHt3mpiCQ82
rufwknYUE44F4fxbLMbe6U6gPJLvtjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBhVrX0WVc4FHJb+ZrN+BO5uwBBBz933mTcl0qCV6MZD4ryS6ir
8lHOyIBz9GvZlZ4xA7IA0K3/2b2fMtEuX4DZ7xPfzvMFrSrJOZbs9Nu70eZaUqxC0sJMFDGh
nikYW+mHbq7/g16LcDv7FuM8oRHWkLwOL45pTZKwr+LunnbbwlZsugnaxRp4WAjFyWSBiqZJ
Om7BzqUq6nBRZmOno+Np4U68YbquM3kYVJROjn97QRjftmG13IGqSgiayrUEqcgg1KNq3yQL
QaOHE1S9XqfwnjIkI8vDwVv1izeJF6gv0LdrfkodV6q72CyVxeZT6bg+2eKadM/ftVl60Q9k
jTAdo3ZGoi2IkbbJxKYYweCxrCzXB5swtQvHa5bwp32udj+Ddc09dHhkdsrgT6pDdPebzpBw
CroIT9QEMIO5lyd1JJHYYhUm4j4rtRI9crViS4tyKgP59YLCUvr/tfnq1DIzNtB7VvNvo0Ni
sIROwtVD/Qua4JLpx3mKN3UMPVoP05Hf8ahazbI907qLz6tiK//eREBeA0q989QtntRrfgVg
xPs5PMSbkLWdUZNhVg81eGApuyQvEDd59Urs01EdVGC6I71kWJoa2X98dsHdj8P/5Ii9Yq5b
T8IUVQ8c5AOoob5gq3VNrq2oVvl0n1DEH9MjprNwnDxDLTQ5Y6xdE4yxZgAAAAAAAA==
--------------ms080105070900080704090103--


--===============2470781031779763342==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2470781031779763342==--
