Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 17:13:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8P0DSQ3001412
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 17:13:31 -0700
Date: Tue, 25 Sep 2007 10:17:25 +1000
Subject: Re: something very strange w/ filestreams...
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------RRBUyM2iZOu877jLrikszB
MIME-Version: 1.0
References: <46F49C80.60007@sandeen.net> <20070923092444.GQ995458@sgi.com> <op.ty4867zj3jf8g2@pc-bnaujok.melbourne.sgi.com> <46F7B04D.70809@sandeen.net>
Message-ID: <op.ty6ofbsm3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46F7B04D.70809@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

------------RRBUyM2iZOu877jLrikszB
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
Content-Transfer-Encoding: Quoted-Printable

On Mon, 24 Sep 2007 22:40:45 +1000, Eric Sandeen <sandeen@sandeen.net>=20=
=20
wrote:

> Barry Naujok wrote:
>> On Sun, 23 Sep 2007 19:24:44 +1000, David Chinner <dgc@sgi.com> wrote:
>>
>>> Barry - I think xfs_repair might be finding the incorrect superblock
>>> for the repair. Tests 172, 173 and 174 use less than the whole disk,
>>> so there are going to be stale superblocks all over the place....
>>>
>>>> hm, no zone name, length of 0x22222274?
>>>>
>>>> I already provided a metadump image to Barry, but I wonder why the
>>>> timing(?) seems to make a difference here... first sign of things=20=
=20
>>>> going
>>>> awry in repair is:
>>>>
>>>> Phase 2 - using internal log
>>>>         - zero log...
>>>>         - scan filesystem freespace and inode maps...
>>>> bad length 131072 for agf 0, should be 4096
>>>> bad length # 131072 for agi 0, should be 4096
>>> Yes - test 173 uses 1GB filesystem with 64x16MB AGs - 4096 * 4k block
>>> size =3D 16MB AG. definitely looks like a stale superblock being
>>> found.
>>>
>>> Barry, I think that the secondary superblock needs better verification
>>> (e.g. that there really are AG headers where the sb says there
>>> are supposed to be and all the lengths match up).
>>>
>>> Eric - you can relax. Filestreams is not hosing your filesystem;
>>> xfs_reapir
>>> is....
>>
>> Test 178 is designed to test mkfs.xfs in
>> http://oss.sgi.com/archives/xfs/2007-07/msg00139.html and
>> will still make xfs_repair go bananas if there is other
>> old AG headers.
>>
>> So, before running this test, you should make sure your test
>> partitions are completely zeroed from mkfs's that occurred
>> before that recent version of mkfs.xfs was installed.
>
> I dd'd over the whole test partition, ran the sequence, and hit the=20=20
> problem.

Yeah, worked it out yesterday but never got around to doing another
email. It's a combination of the two filestreams tests which do
small filesystems and mkfs.xfs doesn't wipe beyond the new
filesystem size. Zero the disk, try the attached patch and see
if that fixes the problem.

Barry.=

------------RRBUyM2iZOu877jLrikszB
Content-Disposition: attachment; filename=better_ag_zeroing_in_mkfs.patch
Content-Type: application/octet-stream; name=better_ag_zeroing_in_mkfs.patch
Content-Transfer-Encoding: Base64

LS0tIGEveGZzcHJvZ3MvbWtmcy94ZnNfbWtmcy5jCTIwMDctMDktMjUgMTA6
MTI6NDIuMDAwMDAwMDAwICsxMDAwCisrKyBiL3hmc3Byb2dzL21rZnMveGZz
X21rZnMuYwkyMDA3LTA5LTI1IDEwOjExOjM2Ljk1NTUxNjcyOSArMTAwMApA
QCAtNTU4LDE1ICs1NTgsMTIgQEAgemVyb19vbGRfeGZzX3N0cnVjdHVyZXMo
CiAJCWdvdG8gZG9uZTsKIAogCS8qCi0JICogYmxvY2sgc2l6ZSBhbmQgYmFz
aWMgZ2VvbWV0cnkgc2VlbXMgYWxyaWdodCwgemVybyB0aGUgc2Vjb25kYXJp
ZXMsCi0JICogYnV0IGRvbid0IGdvIGJleW9uZCB0aGUgZW5kIG9mIHRoZSBu
ZXcgZmlsZXN5c3RlbS4KKwkgKiBibG9jayBzaXplIGFuZCBiYXNpYyBnZW9t
ZXRyeSBzZWVtcyBhbHJpZ2h0LCB6ZXJvIHRoZSBzZWNvbmRhcmllcy4KIAkg
Ki8KIAliemVybyhidWYsIG5ld19zYi0+c2Jfc2VjdHNpemUpOwogCW9mZiA9
IDA7CiAJZm9yIChpID0gMTsgaSA8IHNiLnNiX2FnY291bnQ7IGkrKykgIHsK
IAkJb2ZmICs9IHNiLnNiX2FnYmxvY2tzOwotCQlpZiAob2ZmID49IG5ld19z
Yi0+c2JfZGJsb2NrcykKLQkJCWJyZWFrOwogCQlpZiAocHdyaXRlNjQoeGkt
PmRmZCwgYnVmLCBuZXdfc2ItPnNiX3NlY3RzaXplLAogCQkJCQlvZmYgPDwg
c2Iuc2JfYmxvY2tsb2cpID09IC0xKQogCQkJYnJlYWs7CkBAIC0yMTE1LDYg
KzIxMTIsNyBAQCBhbiBBRyBzaXplIHRoYXQgaXMgb25lIHN0cmlwZSB1bml0
IHNtYWxsCiAJCQkJICAgIEJUT0JCKFdIQUNLX1NJWkUpKTsKIAkJYnplcm8o
WEZTX0JVRl9QVFIoYnVmKSwgV0hBQ0tfU0laRSk7CiAJCWxpYnhmc193cml0
ZWJ1ZihidWYsIExJQlhGU19FWElUX09OX0ZBSUxVUkUpOworCQlsaWJ4ZnNf
cHVyZ2VidWYoYnVmKTsKIAl9CiAKIAkvKgo=

------------RRBUyM2iZOu877jLrikszB--
