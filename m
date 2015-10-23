Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 148CA7F92
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 14:35:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8322AAC005
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:35:16 -0700 (PDT)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	jN0VXRMjmgkWcXwL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:35:10 -0700 (PDT)
Received: by igdg1 with SMTP id g1so23454287igd.1
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:35:09 -0700 (PDT)
Subject: Re: [PATCH v12 21/49] ext4: Add richacl feature flag
References: <1445625722-13791-1-git-send-email-agruenba@redhat.com>
	<1445625722-13791-22-git-send-email-agruenba@redhat.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <562A8BC4.9050107@gmail.com>
Date: Fri, 23 Oct 2015 15:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <1445625722-13791-22-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6233223978056006379=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This is a cryptographically signed message in MIME format.

--===============6233223978056006379==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080705010605070208000902"

This is a cryptographically signed message in MIME format.

--------------ms080705010605070208000902
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-23 14:41, Andreas Gruenbacher wrote:
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
>   fs/ext4/super.c | 49 ++++++++++++++++++++++++++++++++++++++++--------=
-
>   2 files changed, 44 insertions(+), 11 deletions(-)
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
>
>   #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
>   #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \=

> @@ -1607,7 +1608,8 @@ static inline int ext4_encrypted_inode(struct ino=
de *inode)
>   					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
>   					 EXT4_FEATURE_INCOMPAT_MMP | \
>   					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> -					 EXT4_FEATURE_INCOMPAT_ENCRYPT)
> +					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
> +					 EXT4_FEATURE_INCOMPAT_RICHACL)
If this is going to be an incompat feature, the reasoning for that being =

the case should be clearly documented in either the changelog or the=20
code itself.  While the people involved in the discussion of this may=20
understand the reasoning, that doesn't mean any arbitrary individual=20
will at some point in the future, and documenting it properly will save=20
time for people trying to figure out why this non-obvious choice was made=
=2E


--------------ms080705010605070208000902
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIzMTkzNDI4WjBPBgkq
hkiG9w0BCQQxQgRAKzJE6TrqS+nVHg0z3llM2+AWDDsIDdjNXYLE0ittjvZPB3n9yOMIQs33
+PZ6gsTcpZNBJADuLk0W5O50aI5plTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCW2z2/q7q6JmwdOMf5vKRxmt5yOmpJnPH2yv11ZlHsZe578l3b
txmroSRzIgKUjbLWpHa3aA0EXHdcEFNimHJP0uUGj58tuCUz3GJ1PjdX2MZxbCwv7lZHsjyG
VHVdeXkyNzYytGo0riZDjmG4JEOl16d7GrOJ+Y1DTM6n8uiOr0E1hDNaxtEpVlo+nmzlxQs8
aFKhd7YiA2i7pvArfimcI4E3d2YSX8xaK1rWSo5LSkbe7HcDfW6bGLcf7jft0u93sdo9y877
j62VP2MQlKXsDzCwWBivpZzDd4ecnYc3qZ8bGEVEZDLpm0kV8xrLhZ5TePMpRb4FMOAz4yBm
LHVuaIhdGxCGVACV2JUFnKbCNEiBDcEjBQNOB4pOcPalUULrceohgxdZJ32mnSPpFVR5lxDz
3LWPJwCfbvnyU6QEPyjdj9CLnZbP4+Nxuuy8/Z/F6ocC/DSeTKWB/IodZduUpSr8rGCYzyCI
EpJ0OQro+E8WvvyDbvHcikw4eYrR2aMHXIjiPxCNnpcDWD7fy9WUoyz8ohUR8Spg1x4gWqmv
NzHF4Du8QCv71DcNNM4oWTfzTOogG7N4EhZeFTNYQD2y0zXK0W2P2HazjrWzrt9TEmq0/171
ueqJOo4esoJg/NR/iLLnCFSftXn8Od1/gn5t//RMvUsmyWS+IltG5x4tIAAAAAAAAA==
--------------ms080705010605070208000902--


--===============6233223978056006379==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6233223978056006379==--
