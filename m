Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6R9DpPh178319 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 04:13:51 -0500
Received: from mail-fx0-f47.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9060C1686C72
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 02:13:57 -0700 (PDT)
Received: from mail-fx0-f47.google.com (mail-fx0-f47.google.com
	[209.85.161.47]) by cuda.sgi.com with ESMTP id jZFJP72VMR8yzbo9
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 02:13:57 -0700 (PDT)
Received: by fxg11 with SMTP id 11so114626fxg.6
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 02:13:47 -0700 (PDT)
Date: Wed, 27 Jul 2011 13:13:43 +0400
From: Roman Ovchinnikov <coolthecold@gmail.com>
Message-ID: <431429966.20110727131343@gmail.com>
Subject: Re: [PATCH] adding example with xfs_info output decryption
In-Reply-To: <1311706943.2890.42.camel@doink>
References: <BANLkTikjPhKNBVUamccXbAropDw=oBSRgg@mail.gmail.com>
	<20110722155200.GA31867@infradead.org>
	<1311706943.2890.42.camel@doink>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------531D1EC1759BAED"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

------------531D1EC1759BAED
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=0D=0A
On Tue, Jul 26, 2011 at 11:02 PM, Alex Elder <aelder@sgi.com> wrote:
> On Fri, 2011-07-22 at 11:52 -0400, Christoph Hellwig wrote:
>> On Mon, May 23, 2011 at 02:34:54AM +0400, CoolCold wrote:
>> > Basing on irc discussions and questions about reading xfs_info output
>> > I've added example in xfs_growfs manpage.
>>
>> Alex, Dave, Eric, do you guys have any comments on this? =C2=A0Language
>> nitpicks from the native speakers? =C2=A0Otherwise I'd be inclined to pu=
t it
>> in.
>>
>> > Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
>
> I had to dust off my troff command knowledge to review this.
> It has been many years...
I was testing how manpage will look with "man man/man8/xfs_growfs.8", works=
 for me.

>
> Christoph prompted to review this from a native speaker's
> point of view though, so I do that here. =C2=A0I do end up
> with a question for others to try to resolve.
>
> I think what you are doing (adding the example) is a good idea
> to help clarify things in any case.
Thanks!
>
>> > ---
>> > =C2=A0man/man8/xfs_growfs.8 | =C2=A0 34 ++++++++++++++++++++++++++++++=
++++
>> > =C2=A01 files changed, 34 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
>> > index 02793ae..c782fc1 100644
>> > --- a/man/man8/xfs_growfs.8
>> > +++ b/man/man8/xfs_growfs.8
>> > @@ -1,3 +1,14 @@
>> > +.\" Verbatim blocks taken from openssl req manpage content
>> > +.de Vb \" Begin verbatim text
>> > +.ft CW
>> > +.nf
>> > +.ne \\$1
>> > +..
>> > +.de Ve \" End verbatim text
>> > +.ft R
>> > +.fi
>> > +..
>> > +
>> > =C2=A0.TH xfs_growfs 8
>> > =C2=A0.SH NAME
>> > =C2=A0xfs_growfs, xfs_info \- expand an XFS filesystem
>> > @@ -105,6 +116,7 @@ this is specified with
>> > =C2=A0Specifies that no change to the filesystem is to be made.
>> > =C2=A0The filesystem geometry is printed, and argument checking is per=
formed,
>> > =C2=A0but no growth occurs.
>> > +.B See output examples below.
>> > =C2=A0.TP
>> > =C2=A0.BI "\-r | \-R " size
>> > =C2=A0Specifies that the real-time section of the filesystem should be=
 grown. If the
>> > @@ -152,6 +164,28 @@ reside. In order to grow a filesystem, it is
>> > necessary to provide added
>> > =C2=A0space for it to occupy. Therefore there must be at least one spa=
re new
>> > =C2=A0disk partition available. Adding the space is often done through=
 the use
>> > =C2=A0of a logical volume manager.
>> > +.SH "EXAMPLES"
>> > +
>> > +Examining xfs_info output.
>
> How about, "Understanding xfs_info output"
>
>> > +.PP
>> > +Let's assume one have the next xfs_info output:
>> > +.PP
>> > +.Vb 1
>
> Maybe you could add something indicating how the command was issued.
> I.e.:
>
> =C2=A0 =C2=A0\&# xfs_info /dev/sda
Okay.

>
>> > +\& meta-data=3D/dev/sda =C2=A0 =C2=A0 =C2=A0isize=3D256 =C2=A0 =C2=A0=
agcount=3D32, agsize=3D16777184 blks
>> > +\& =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0sectsz=3D512 =C2=A0 attr=3D2
>> > +\& data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0bsize=3D4096 =C2=A0 blocks=3D536869888, imaxpct=3D5
>> > +\& =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0sunit=3D32 =C2=A0 =C2=A0 swidth=3D128 blks
>> > +\& naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 bsize=3D4096
>> > +\& log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0bsize=3D40=
96 =C2=A0 blocks=3D32768, version=3D2
>> > +\& =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0sectsz=3D512 =C2=A0 sunit=3D32 blks, lazy-count=3D1
>> > +\& realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0extsz=3D524288 =
blocks=3D0, rtextents=3D0
>
> I think you should drop the space character after each '&' above.
> The way you have it puts a slight indent in the output.
Personally I like indentation here, to make the text look like "quote", and=
 may be I'd add one more space

>
>> > +.Ve
>> > +.PP
>> > +
>> > +Here, data section block size (bsize) is 4096 bytes. Therefore
>> > +"sunit=3D32 swidth=3D128 blks" means stripe unit is 32*4096 bytes =3D=
 128 kibibytes
>> > +and stripe width is 128*4096 bytes =3D 512 kibibytes. Filesystem is s=
triped
>> > +over 4 ( 128 / 32 ) stripes.
>
> I'll just write what I think it should be rather than trying
> to show lots of little changes:
>
> =C2=A0Here, the data section of the output indicates "bsize=3D4096",
> =C2=A0meaning the data block size for this filesystem is 4096 bytes.
> =C2=A0This section also shows "sunit=3D32 swidth=3D128 blks", which means
> =C2=A0the stripe unit is 32*4096 bytes =3D 128 kibibytes and the stripe
> =C2=A0width is 128*4096 bytes =3D 512 kibibytes.
>
> The last sentence I'm not sure I agree with. =C2=A0I think you're
> trying to explain the relationship between a stripe width
> and stripe unit, and the components that make up a stripe.
> Your use of the term "stripe" doesn't match what I take
> to be its meaning. =C2=A0I'm not saying my meaning is right, but
> I'd like to make sure we have agreement on these terms.
Generally I was trying to fact out units of measurement - as,say, mkfs.xfs =
manpage describes option parameters as 512 bytes blocks/just bytes to be sp=
ecified when calling mkfs.xfs, and when someone gets xfs_info output for th=
at mount point it really differs from parameters he passed to mkfs.xfs (at =
least at first sight).
>
> Given that, I would re-state your last sentence (using my
> terminology as):
>
> =C2=A0A single stripe of this filesystem therefore consists
> =C2=A0of four stripe units (128 blocks / 32 blocks per unit).
>
> I.e., my meaning says that =C2=A0a "stripe" is "stripe width"
> blocks wide, made up of four "stripe units", each of which
> is 32 blocks, where a block is 4096 bytes.
>
> I think you are using the term "stripe" to represent what
> I'm calling the "stripe unit".
>
> Perhaps someone else can help ensure we're using
> terms with meaning consistent with how XFS has used
> them historically.
I've checked manpage for mkfs.xfs and it operates with terms "stripe unit" =
& "stripe width" in your understanding, so I think this is historically pro=
per way to think about stripes.

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Alex
>
>
>> > =C2=A0.SH SEE ALSO
>> > =C2=A0.BR mkfs.xfs (8),
>> > =C2=A0.BR md (4),
>
>

So, I've updated patch (now it mostly contains your text), but left
indentation. Patch is attached and url for it is http://web.coolcold.org/da=
ta/0001-adding-example-with-xfs_info-decryption-v2.patch

I'm new to all this public patch-through-email process, should I start
new mail thread with new patch text inside message?




--=20
Best regards,
[COOLCOLD-RIPN]
------------531D1EC1759BAED
Content-Type: application/octet-stream;
 name="0001-adding-example-with-xfs_info-decryption-v2.patch"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename="0001-adding-example-with-xfs_info-decryption-v2.patch"

RnJvbSAxYmQ0OTA2YzdkODkyOGNiMTU3MTY2N2E4YTMzMWU2YWQyYzY5ZGFhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBSb21hbiBPdmNoaW5uaWtvdiA8Y29vbHRoZWNvbGRA
Z21haWwuY29tPgpEYXRlOiBTYXQsIDIxIE1heSAyMDExIDA0OjA1OjMzICswNDAwClN1Ympl
Y3Q6IFtQQVRDSF0gYWRkaW5nIGV4YW1wbGUgd2l0aCB4ZnNfaW5mbyBkZWNyeXB0aW9uLCB2
MgoKClNpZ25lZC1vZmYtYnk6IFJvbWFuIE92Y2hpbm5pa292IDxjb29sdGhlY29sZEBnbWFp
bC5jb20+Ci0tLQogbWFuL21hbjgveGZzX2dyb3dmcy44IHwgICAzNyArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDM3IGluc2VydGlv
bnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbWFuL21hbjgveGZzX2dyb3dm
cy44IGIvbWFuL21hbjgveGZzX2dyb3dmcy44CmluZGV4IDAyNzkzYWUuLmU1ZjgyNWEgMTAw
NjQ0Ci0tLSBhL21hbi9tYW44L3hmc19ncm93ZnMuOAorKysgYi9tYW4vbWFuOC94ZnNfZ3Jv
d2ZzLjgKQEAgLTEsMyArMSwxNCBAQAorLlwiIFZlcmJhdGltIGJsb2NrcyB0YWtlbiBmcm9t
IG9wZW5zc2wgcmVxIG1hbnBhZ2UgY29udGVudAorLmRlIFZiIFwiIEJlZ2luIHZlcmJhdGlt
IHRleHQKKy5mdCBDVworLm5mCisubmUgXFwkMQorLi4KKy5kZSBWZSBcIiBFbmQgdmVyYmF0
aW0gdGV4dAorLmZ0IFIKKy5maQorLi4KKwogLlRIIHhmc19ncm93ZnMgOAogLlNIIE5BTUUK
IHhmc19ncm93ZnMsIHhmc19pbmZvIFwtIGV4cGFuZCBhbiBYRlMgZmlsZXN5c3RlbQpAQCAt
MTA1LDYgKzExNiw3IEBAIHRoaXMgaXMgc3BlY2lmaWVkIHdpdGgKIFNwZWNpZmllcyB0aGF0
IG5vIGNoYW5nZSB0byB0aGUgZmlsZXN5c3RlbSBpcyB0byBiZSBtYWRlLgogVGhlIGZpbGVz
eXN0ZW0gZ2VvbWV0cnkgaXMgcHJpbnRlZCwgYW5kIGFyZ3VtZW50IGNoZWNraW5nIGlzIHBl
cmZvcm1lZCwKIGJ1dCBubyBncm93dGggb2NjdXJzLgorLkIgU2VlIG91dHB1dCBleGFtcGxl
cyBiZWxvdy4KIC5UUAogLkJJICJcLXIgfCBcLVIgIiBzaXplCiBTcGVjaWZpZXMgdGhhdCB0
aGUgcmVhbC10aW1lIHNlY3Rpb24gb2YgdGhlIGZpbGVzeXN0ZW0gc2hvdWxkIGJlIGdyb3du
LiBJZiB0aGUKQEAgLTE1Miw2ICsxNjQsMzEgQEAgcmVzaWRlLiBJbiBvcmRlciB0byBncm93
IGEgZmlsZXN5c3RlbSwgaXQgaXMgbmVjZXNzYXJ5IHRvIHByb3ZpZGUgYWRkZWQKIHNwYWNl
IGZvciBpdCB0byBvY2N1cHkuIFRoZXJlZm9yZSB0aGVyZSBtdXN0IGJlIGF0IGxlYXN0IG9u
ZSBzcGFyZSBuZXcKIGRpc2sgcGFydGl0aW9uIGF2YWlsYWJsZS4gQWRkaW5nIHRoZSBzcGFj
ZSBpcyBvZnRlbiBkb25lIHRocm91Z2ggdGhlIHVzZQogb2YgYSBsb2dpY2FsIHZvbHVtZSBt
YW5hZ2VyLgorLlNIICJFWEFNUExFUyIKKworVW5kZXJzdGFuZGluZyB4ZnNfaW5mbyBvdXRw
dXQuCisuUFAKK0xldCdzIGFzc3VtZSBvbmUgaGF2ZSB0aGUgbmV4dCB4ZnNfaW5mbyAvZGV2
L3NkYSBvdXRwdXQ6CisuUFAKKy5WYiAxCitcJiBtZXRhLWRhdGE9L2Rldi9zZGEgICAgICBp
c2l6ZT0yNTYgICAgYWdjb3VudD0zMiwgYWdzaXplPTE2Nzc3MTg0IGJsa3MKK1wmICAgICAg
ICAgID0gICAgICAgICAgICAgIHNlY3Rzej01MTIgICBhdHRyPTIKK1wmIGRhdGEgICAgID0g
ICAgICAgICAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9NTM2ODY5ODg4LCBpbWF4cGN0PTUK
K1wmICAgICAgICAgID0gICAgICAgICAgICAgIHN1bml0PTMyICAgICBzd2lkdGg9MTI4IGJs
a3MKK1wmIG5hbWluZyAgID12ZXJzaW9uIDIgICAgIGJzaXplPTQwOTYKK1wmIGxvZyAgICAg
ID1pbnRlcm5hbCAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9MzI3NjgsIHZlcnNpb249Mgor
XCYgICAgICAgICAgPSAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIHN1bml0PTMyIGJsa3Ms
IGxhenktY291bnQ9MQorXCYgcmVhbHRpbWUgPW5vbmUgICAgICAgICAgZXh0c3o9NTI0Mjg4
IGJsb2Nrcz0wLCBydGV4dGVudHM9MAorLlZlCisuUFAKKworSGVyZSwgdGhlIGRhdGEgc2Vj
dGlvbiBvZiB0aGUgb3V0cHV0IGluZGljYXRlcyAiYnNpemU9NDA5NiIsCittZWFuaW5nIHRo
ZSBkYXRhIGJsb2NrIHNpemUgZm9yIHRoaXMgZmlsZXN5c3RlbSBpcyA0MDk2IGJ5dGVzLgor
VGhpcyBzZWN0aW9uIGFsc28gc2hvd3MgInN1bml0PTMyIHN3aWR0aD0xMjggYmxrcyIsIHdo
aWNoIG1lYW5zCit0aGUgc3RyaXBlIHVuaXQgaXMgMzIqNDA5NiBieXRlcyA9IDEyOCBraWJp
Ynl0ZXMgYW5kIHRoZSBzdHJpcGUKK3dpZHRoIGlzIDEyOCo0MDk2IGJ5dGVzID0gNTEyIGtp
YmlieXRlcy4KK0Egc2luZ2xlIHN0cmlwZSBvZiB0aGlzIGZpbGVzeXN0ZW0gdGhlcmVmb3Jl
IGNvbnNpc3RzCitvZiBmb3VyIHN0cmlwZSB1bml0cyAoMTI4IGJsb2NrcyAvIDMyIGJsb2Nr
cyBwZXIgdW5pdCkuCiAuU0ggU0VFIEFMU08KIC5CUiBta2ZzLnhmcyAoOCksCiAuQlIgbWQg
KDQpLAotLSAKMS43LjIuNQoK
------------531D1EC1759BAED
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------------531D1EC1759BAED--
