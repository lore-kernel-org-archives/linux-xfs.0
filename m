Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AD007F5D
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 11:20:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1849AC001
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 09:20:05 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	ufvmdwyJNrivD09O (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 09:20:03 -0700 (PDT)
Received: by iow1 with SMTP id 1so198427515iow.1
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 09:20:03 -0700 (PDT)
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
	<CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5625182C.3050007@gmail.com>
Date: Mon, 19 Oct 2015 12:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7326337504584687645=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This is a cryptographically signed message in MIME format.

--===============7326337504584687645==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070003050802000306030105"

This is a cryptographically signed message in MIME format.

--------------ms070003050802000306030105
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-19 11:34, Andreas Gruenbacher wrote:
> On Mon, Oct 19, 2015 at 3:16 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
>>>
>>> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>> I would like to re-iterate, on both XFS and ext4, I _really_ think t=
his
>>>> should be a ro_compat flag, and not an incompat one.  If a person ha=
s the
>>>> ability to mount the FS (even if it's a read-only mount), then they =
by
>>>> definition have read access to the file or partition that the filesy=
stem
>>>> is contained in, which means that any ACL's stored on the filesystem=
 are
>>>> functionally irrelevant,
>>>
>>> It is unfortunately not safe to make such a file system accessible to=

>>> other users, so the feature is not strictly read-only compatible.
>>>
>> OK, seeing as I wasn't particularly clear as to why I object to this i=
n my
>> other e-mail, let's try this again.
>>
>> Can you please explain exactly why it isn't safe to make such a filesy=
stem
>> accessible to other users?
>
> See here: http://www.spinics.net/lists/linux-ext4/msg49541.html
OK, so to clarify, this isn't 'safe' because:
1. The richacls that exist on the filesystem won't be enforced.
2. Newly created files will have no ACL's set.

It is worth noting that these are also issues with any kind of access=20
control mechanism.  Using your logic, all LSM's need to set separate=20
incompat feature flags in filesystems they are being used on, as should=20
POSIX ACLs, and for that matter so should Samba in many circumstances,=20
and any NFS system not using idmapping or synchronized/centralized user=20
databases.  Now, if the SELinux (or SMACK, or TOMOYO) people had taken=20
this approach, then I might be inclined to not complain (at least not to =

you, I'd be complaining to them about this rather poor design choice),=20
but that is not the case, because (I assume) they realized that all this =

provides is a false sense of security.

Issue 1, as I have said before, is functionally irrelevant for anyone=20
who actually knows what they are doing; all you need for ext* is one of=20
the myriad of programs for un-deleting files on such a filesystem (such=20
as ext4magic or extundelete, and good luck convincing them to not allow=20
being used when this flag is set), for BTRFS you just need the regular=20
filesystem administration utilities ('btrfs restore' works wonders, and=20
that one will _never_ honor any kind of permissions, because it's for=20
disaster recovery), and while I don't know of any way to do this with=20
XFS, that is only because I don't use XFS myself and have not had the=20
need to provide tech support for anyone who does.  If somebody=20
absolutely _needs_ a guarantee that the acls will be enforced, they need =

to be using whole disk encryption, not just acls, and even that can't=20
provide such a guarantee.

As for issue 2, that can be solved by making it a read-only compatible=20
flag, which is what I was suggesting be done in the first place.  The=20
only situation I can think of that this would cause an issue for is if=20
the filesystem was not cleanly unmounted, and the log-replay doesn't set =

the ACL's, but mounting an uncleanly unmounted filesystem that has=20
richacls on a kernel without support should fall into one of the=20
following 2 cases more than 99% of the time:
1. The system crashed hard, and the regular kernel is un-bootable for=20
some reason, in this case you're at the point of disaster recovery,=20
should not be exposing _anything_ to a multi-user environment, and=20
probably care a lot more about being able to get the system running=20
again than about not accidentally creating a file with a missing ACL.
2. The filesystem was maliciously stolen in some way (either the=20
hardware was acquired, or more likely, someone got an image of a still=20
mounted filesystem), in which case all of my statements above regarding=20
issue 1 apply.


--------------ms070003050802000306030105
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE5MTYxOTU2WjBPBgkq
hkiG9w0BCQQxQgRAfC+gD4JHtSqkBVo4Uo2fM9IhhiB/VP79yU7hftrGucAlQ8sWak5Fc75t
foKee/4RQUokGo2Rhum3jYMn9QUxuDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBR0bu7sMjL43EBbSzC72JYWjlFdYJJ61yr/YlC9Ot5dASTKiPd
YSFBqhutOQHvWZ17Q84t9cig/XxSX4KX9VSckl6MRU9Fo/y7A0q7xbfSl90N3jcUhhE/flRX
29BIoQbRuDigPgTJaQoIhW3hfoA5ZscfUCDHlBGXmnAZ+kWwqGWzMZL3IOPl1ZUKqfY6NfYQ
YSjJ65aizDJjIqpgnRQIUNXVJ14hg/GBEM/6n2H3sFEDGtVM+fw2ehICKT99LyYueB/fB+iG
vYWeSOzc18HwIAUu2c3SVi9mPRWNHtXES8ajqkS4eQsNGPpQfMq8ZbOMPizz2r0chYe74tXc
VxguvDf2kFUFTFzCDV7PNMS+TlVL8By22g3R7ifrNcBW7SP77FI2UMsm53/BfaMOSDp3VDrG
12LAuyk4rACHrCp4YUxwfwzfhX8HmfZbbJS4vRXeBIuXT+S8BDAe34rmIEvUb566Ixaxzrh7
ttWEtfn6a2xPQvkBNNcANgNVRWsTC4Qj/e5UFuhTsVAq+0yfcSglZOuo6g6jyp2iU+PRQNt9
qO5pxFUDgJvGgSTIGJzQ97DNPo3GlDKZBvzyooDAZAcutyxKpvBeYsjw+63bpGU0Xk70MZrG
b8qPTEhBxhWlklqYcd+kiuX8SulzlvyDKmSGJSGHJVH0KFTqWV3gcuYx3wAAAAAAAA==
--------------ms070003050802000306030105--


--===============7326337504584687645==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7326337504584687645==--
