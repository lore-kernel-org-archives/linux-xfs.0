Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A870E7F61
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 13:45:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9570C304039
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 11:45:51 -0700 (PDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	X9KbxQbtiVXybiBp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 11:45:49 -0700 (PDT)
Received: by ioll68 with SMTP id l68so43998814iol.3
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 11:45:49 -0700 (PDT)
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
	<CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
	<5625182C.3050007@gmail.com>
	<CAHc6FU75GXGeav1ho-QraPS_F8fpOXnoDyv17+b=koiF=9YE5A@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56253A35.4070309@gmail.com>
Date: Mon, 19 Oct 2015 14:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAHc6FU75GXGeav1ho-QraPS_F8fpOXnoDyv17+b=koiF=9YE5A@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6803654049154562304=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This is a cryptographically signed message in MIME format.

--===============6803654049154562304==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070001020509080703050503"

This is a cryptographically signed message in MIME format.

--------------ms070001020509080703050503
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-19 13:33, Andreas Gruenbacher wrote:
> On Mon, Oct 19, 2015 at 6:19 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-10-19 11:34, Andreas Gruenbacher wrote:
>>> On Mon, Oct 19, 2015 at 3:16 PM, Austin S Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
>>>>> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>> I would like to re-iterate, on both XFS and ext4, I _really_ think=
 this
>>>>>> should be a ro_compat flag, and not an incompat one.  If a person =
has
>>>>>> the
>>>>>> ability to mount the FS (even if it's a read-only mount), then the=
y by
>>>>>> definition have read access to the file or partition that the
>>>>>> filesystem
>>>>>> is contained in, which means that any ACL's stored on the filesyst=
em
>>>>>> are
>>>>>> functionally irrelevant,
>>>>> It is unfortunately not safe to make such a file system accessible =
to
>>>>> other users, so the feature is not strictly read-only compatible.
>>>> OK, seeing as I wasn't particularly clear as to why I object to this=
 in
>>>> my
>>>> other e-mail, let's try this again.
>>>> Can you please explain exactly why it isn't safe to make such a
>>>> filesystem
>>>> accessible to other users?
>>> See here: http://www.spinics.net/lists/linux-ext4/msg49541.html
>> OK, so to clarify, this isn't 'safe' because:
>> 1. The richacls that exist on the filesystem won't be enforced.
>> 2. Newly created files will have no ACL's set.
>>
>> It is worth noting that these are also issues with any kind of access
>> control mechanism.  Using your logic, all LSM's need to set separate
>> incompat feature flags in filesystems they are being used on, as shoul=
d
>> POSIX ACLs, and for that matter so should Samba in many circumstances,=
 and
>> any NFS system not using idmapping or synchronized/centralized user
>> databases.  Now, if the SELinux (or SMACK, or TOMOYO) people had taken=
 this
>> approach, then I might be inclined to not complain (at least not to yo=
u, I'd
>> be complaining to them about this rather poor design choice), but that=
 is
>> not the case, because (I assume) they realized that all this provides =
is a
>> false sense of security.
>
> LSMs reside above the filesystem level. Let's take SELinux as an
> example. It has its own consistency check mechanism (relabeling). Fsck
> could check the syntax of SELinux labels, but it couldn't do anything
> sensible about corrupted labels, and syntactically correct labels also
> don't mean much. A relabeling run to verify or restory the appropriate
> policy would still be necessary to verify that labels are semantically
> correct, and for that, the filesystem needs to be mounted in the right
> place in the filesystem hierarchy.
>
> TOMOYO and AppArmor are not based on inode labels at all.
Apologies for being unintentionally over-inclusive WRT LSM's, and also=20
for forgetting that TOMOYO doesn't use inode labels.
> LSMs usually also just provide an extra layer of security; when turned
> off, the basic security mechanisms still in effect will make sure that
> the system works just like before. (There are configurations like MLS
> where that is not the case, but those are uncommon.)
Um, actually no, even without MLS (or MCS), there is no guarantee=20
whatsoever that the system will work 'just' like before (I've actually=20
seen systems break on any (or even in one case all) of the transitions=20
between enforcing/permissive/off for SELinux, even assuming that=20
relabeling is done properly).
> ACLs are quite different from that. They can be checked statically by
> fsck. They are a basic security concept, and when turned off, there is
> no guarantee that the system will still be safe.
LSM's hook into the VFS code right alongside the regular permissions=20
checks. They are intended to supplement the regular UNIX DAC based=20
permissions. Richacls (and POSIX ACLs) also hook into the regular=20
permissions checks, and also are intended to supplement the regular UNIX =

DAC based permissions. Fsck only checks the syntax of regular UNIX DAC=20
based permissions (it doesn't verify that the listed UID/GID are=20
actually valid in userspace, nor does it check for semantically=20
nonsensical permissions modes like 007 or 000), and it really can't=20
properly check anything more than that on ACL's either.  Based on all of =

this, richacls and LSM's which mediate filesystem accesses are on=20
exactly the same level with the exception that LSM's usually have way=20
more functionality beyond just using ACL's to control file access, LSM's =

are usually MAC based while ACL's are DAC based, and the fact that ACL's =

are (usually) not dependent on where in the filesystem hierarchy they=20
are found.

On top of that, there is no guarantee that a system will still be safe=20
when you turn SELinux (or other LSM's) off either (in fact, for some=20
configurations, it can be mathematically proven that the system will not =

be safe if you turn off SELinux).
>> Issue 1, as I have said before, is functionally irrelevant for anyone =
who
>> actually knows what they are doing; all you need for ext* is one of th=
e
>> myriad of programs for un-deleting files on such a filesystem (such as=

>> ext4magic or extundelete, and good luck convincing them to not allow b=
eing
>> used when this flag is set), for BTRFS you just need the regular files=
ystem
>> administration utilities ('btrfs restore' works wonders, and that one =
will
>> _never_ honor any kind of permissions, because it's for disaster recov=
ery),
>> and while I don't know of any way to do this with XFS, that is only be=
cause
>> I don't use XFS myself and have not had the need to provide tech suppo=
rt for
>> anyone who does.  If somebody absolutely _needs_ a guarantee that the =
acls
>> will be enforced, they need to be using whole disk encryption, not jus=
t
>> acls, and even that can't provide such a guarantee.
>>
>> As for issue 2, that can be solved by making it a read-only compatible=
 flag,
>> which is what I was suggesting be done in the first place.  The only
>> situation I can think of that this would cause an issue for is if the
>> filesystem was not cleanly unmounted, and the log-replay doesn't set t=
he
>> ACL's, but mounting an uncleanly unmounted filesystem that has richacl=
s on a
>> kernel without support should fall into one of the following 2 cases m=
ore
>> than 99% of the time:
>> 1. The system crashed hard, and the regular kernel is un-bootable for =
some
>> reason, in this case you're at the point of disaster recovery, should =
not be
>> exposing _anything_ to a multi-user environment, and probably care a l=
ot
>> more about being able to get the system running again than about not
>> accidentally creating a file with a missing ACL.
>> 2. The filesystem was maliciously stolen in some way (either the hardw=
are
>> was acquired, or more likely, someone got an image of a still mounted
>> filesystem), in which case all of my statements above regarding issue =
1
>> apply.
> Please spare me with all that nonsense. Compared to mount options,
> filesystem feature flags in this case simplify things (you don't have
> to specify whether a filesystem contains POSIX ACLs or richacls), and
> they prevent administrator errors: when a filesystem mounts, it is
> safe to use; when it doesn't, it is not. That's all there is to it.
You're ignoring what I'm actually saying.  I've said absolutely nothing=20
about needing to use mount options at all, and I'm not arguing against=20
using filesystem feature flags, I'm arguing for using them sensibly in a =

way that does not present a false sense of security.

Making the comparability flag read-only will exactly solve the second=20
issue that you outlined for more than 99% of all use cases (and the=20
remaining cases are provably irrelevant), still indicate clearly to the=20
FS code which type of ACL is in use on the FS, and remove the entirely=20
false sense of security WRT the first issue you outlined.

Making it an incompatible flag will likely cause headaches for some=20
legitimate users, and at most delay competent hackers by a few seconds=20
to a few minutes, and script kiddies by a few hours, and is really no=20
better than security by obscurity (and from a purely logistical=20
standpoint, that's _all_ it is) in that it actively tries to hide the=20
fact that someone having read access to the storage the filesystem is on =

can bypass the ACL's.

To reiterate, if someone can call mount() on a filesystem, and mount()=20
does not return -EPERM, then even if mount() returns a different error,=20
they still have the ability to completely bypass all permissions and=20
ACL's in that filesystem, because they have the ability to read the=20
entire filesystem directly.

The _only_ way to properly protect against people bypassing the ACL's is =

to use full disk encryption and lock down root access on the system, and =

even that can't completely prevent it from happening.


--------------ms070001020509080703050503
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE5MTg0NTA5WjBPBgkq
hkiG9w0BCQQxQgRAcgXJbxNPX3oW/KhVp4rcPDq8X5b6IhVxBuin2hYzQNEBS83jazQZzRXk
35gU3qW3floVftalddqLYsfbfehOTTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBavTge9U9eNwEqfSp7bflcLiQW/boDXIQym7kg+5ETMp7q4Q8c
96dQMgki9Ggr5ZMAO+IG7s9FNPv5IHuJIYwf53FhGfL1qXrRuiGfy0oRO0KHeUvLXhmQBT1B
Vtfdi62uoq9lqRnGrnHDXxf1f/Dnd7unOdTfv7Ef7UITWn+zlLk2lOtgZPvmE9f1nIeu6sII
EZ+Vfelqb8XoeemwSOe4VusJwO8/MmtR+dLqc3Q3O7n/hUOgKjr/Hf51TOjKEUSRm07ahIbs
eFQEnNdZxRqJkNfjW1MItr4Cefi7Krkj4+9c8n58HQyie8+hecDYp+puuwTcvxlXxbuj3asq
yaaWRWB6kEx2jOqxxGmin3VvupC0AvyO0la17gRpEXrAWn8j6/TyoHFYTw0OUc/zo7JKq3uX
cbjLtXuaDSFSBvsZE2L0+6ELbMrhh4LkhHRvWul+HRDiGk3t2CbH2y7kcFXgvFQi4Ys1L0mk
CfVaSat0wBeodtWbaTyrvt7nIsJWtjSInsZAmCBP9ThNzNbXlJUzeJaBBq5k73Dc4SEJ2BSj
OQb5b1NSiiNnM0WIApoxirLUd7QsGDgl2sfkQiE0M8EEGht9Apu4jZGkR757cC+rWxEB7IbH
9h5pUZubv5qKzVz0L60HaUnsUOsjwyVeOkV0eLYMV4R7guvTo/U6n+PdIgAAAAAAAA==
--------------ms070001020509080703050503--


--===============6803654049154562304==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6803654049154562304==--
