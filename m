Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Dec 2007 07:52:54 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBDFqXUI031052
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 07:52:35 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 943D2111EE1C
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 07:52:43 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.176]) by cuda.sgi.com with ESMTP id tk2hrlB9z1rreV3J for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 07:52:43 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so1243306waf.18
        for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 07:52:42 -0800 (PST)
Message-ID: <f0e429340712130746i9b24c15j8dd8f53a9da2c4c4@mail.gmail.com>
Date: Thu, 13 Dec 2007 16:46:18 +0100
From: "KE Liew" <ke.liew@gmail.com>
Subject: mount: Function not implemented
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_35143_13710901.1197560778960"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

------=_Part_35143_13710901.1197560778960
Content-Type: multipart/alternative;
	boundary="----=_Part_35144_16749570.1197560778960"

------=_Part_35144_16749570.1197560778960
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I was in #xfs with sandeen in discussing on the above issue. In the
nutshell, I can't mount /dev/hdb due to the above error: mount -t xfs
/dev/hdb /path/to

It all started after I did a sequence of things to the new hdd I purchased.
First, I created an msdos disklabel on a new xfs partition /dev/hdb1. It
uses the full capacity of the hdd. Then I transferred files from one hdd to
another using mv -v /stuff-to-transfer /hdb-mount-point Upon completion, I
umount both devices and rebooted. On boot, I was not able to mount neither
/dev/hdb1 nor /dev/hdb. /dev/hdb1 returns mount: special device /dev/hdb1
does not exist and /dev/hdb returns the above error message, no relevant
messages are present in dmesg | tail

The hexdump:
===================
# dd if=/dev/hdb bs=512 count=1 | hexdump -C
1+0 records in
1+0 records out
00000000  58 46 53 42 00 01 00 00  00 00 00 00 00 3a 38 b0
|XFSB.........:8.|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
00000020  82 fd 56 0c 80 92 4f 4a  87 8b 5e 5d 5e 55 89 aa
|..V...OJ..^]^U..|
00000030  00 00 00 00 00 20 00 05  00 00 00 00 00 00 09 00  |.....
..........|
00000040  00 00 00 00 00 00 09 01  00 00 00 00 00 00 09 02
|................|
00000050  00 00 00 01 00 03 a3 8b  00 00 00 10 00 00 00 00
|................|
00000060  00 00 07 47 3c 04 80 00  01 00 01 00 00 00 00 00
|...G<...........|
00000070  00 00 00 00 00 00 00 00  10 0f 08 08 12 00 00 19
|................|
00000080  00 00 00 00 00 00 01 00  00 00 00 00 00 00 00 fd
|................|
00000090  00 00 00 00 00 3a 31 18  00 00 00 00 00 00 00 00
|.....:1.........|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
*
000000c0  00 0f 80 00 00 01 00 00  00 00 00 00 00 00 00 00
|................|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
*
00000200
512 bytes (512 B) copied, 0.00695137 seconds, 73.7 kB/s
===================

The xfs_db:
===================
# xfs_db -r -c "sb 0" -c p /dev/hdb
cache_node_purge: refcount was 1, not zero (node=0x80ca410)
xfs_db: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=0x80da608)
xfs_db: cannot read realtime bitmap inode (22)
Segmentation fault
===================

Distro: Debian etch
uname -a : 2.6.18-5-686
xfsprogs version 2.9.4-2 (from Sid)

You will find the chatlog attached. I just hope that it's recoverable even
though I have backups that aren't exactly up to date.

Thanks!


Best regards,

KwangErn

------=_Part_35144_16749570.1197560778960
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,<br><br>I was in #xfs with sandeen in discussing on the above issue. In the nutshell, I can&#39;t mount /dev/hdb due to the above error: mount -t xfs /dev/hdb /path/to<br><br>It all started after I did a sequence of things to the new hdd I purchased. First, I created an msdos disklabel on a new xfs partition /dev/hdb1. It uses the full capacity of the hdd. Then I transferred files from one hdd to another using mv -v /stuff-to-transfer /hdb-mount-point Upon completion, I umount both devices and rebooted. On boot, I was not able to mount neither /dev/hdb1 nor /dev/hdb. /dev/hdb1 returns mount: special device /dev/hdb1 does not exist and /dev/hdb returns the above error message, no relevant messages are present in dmesg | tail
<br><br>The hexdump:<br>===================<br># dd if=/dev/hdb bs=512 count=1 | hexdump -C<br>1+0 records in<br>1+0 records out<br>00000000&nbsp; 58 46 53 42 00 01 00 00&nbsp; 00 00 00 00 00 3a 38 b0&nbsp; |XFSB.........:8.|<br>00000010&nbsp; 00 00 00 00 00 00 00 00&nbsp; 00 00 00 00 00 00 00 00&nbsp; |................|
<br>00000020&nbsp; 82 fd 56 0c 80 92 4f 4a&nbsp; 87 8b 5e 5d 5e 55 89 aa&nbsp; |..V...OJ..^]^U..|<br>00000030&nbsp; 00 00 00 00 00 20 00 05&nbsp; 00 00 00 00 00 00 09 00&nbsp; |..... ..........|<br>00000040&nbsp; 00 00 00 00 00 00 09 01&nbsp; 00 00 00 00 00 00 09 02&nbsp; |................|
<br>00000050&nbsp; 00 00 00 01 00 03 a3 8b&nbsp; 00 00 00 10 00 00 00 00&nbsp; |................|<br>00000060&nbsp; 00 00 07 47 3c 04 80 00&nbsp; 01 00 01 00 00 00 00 00&nbsp; |...G&lt;...........|<br>00000070&nbsp; 00 00 00 00 00 00 00 00&nbsp; 10 0f 08 08 12 00 00 19&nbsp; |................|
<br>00000080&nbsp; 00 00 00 00 00 00 01 00&nbsp; 00 00 00 00 00 00 00 fd&nbsp; |................|<br>00000090&nbsp; 00 00 00 00 00 3a 31 18&nbsp; 00 00 00 00 00 00 00 00&nbsp; |.....:1.........|<br>000000a0&nbsp; 00 00 00 00 00 00 00 00&nbsp; 00 00 00 00 00 00 00 00&nbsp; |................|
<br>*<br>000000c0&nbsp; 00 0f 80 00 00 01 00 00&nbsp; 00 00 00 00 00 00 00 00&nbsp; |................|<br>000000d0&nbsp; 00 00 00 00 00 00 00 00&nbsp; 00 00 00 00 00 00 00 00&nbsp; |................|<br>*<br>00000200<br>512 bytes (512 B) copied, 0.00695137
 seconds, 73.7 kB/s<br>===================<br><br>The xfs_db:<br>===================<br># xfs_db -r -c &quot;sb 0&quot; -c p /dev/hdb<br>cache_node_purge: refcount was 1, not zero (node=0x80ca410)<br>xfs_db: cannot read root inode (22)
<br>cache_node_purge: refcount was 1, not zero (node=0x80da608)<br>xfs_db: cannot read realtime bitmap inode (22)<br>Segmentation fault<br>===================<br><br>Distro: Debian etch<br>uname -a : 2.6.18-5-686<br>xfsprogs version 
2.9.4-2 (from Sid)<br><br>You will find the chatlog attached. I just hope that it&#39;s recoverable even though I have backups that aren&#39;t exactly up to date.<br><br>Thanks!<br><br><br>Best regards,<br><br>KwangErn<br>

------=_Part_35144_16749570.1197560778960--

------=_Part_35143_13710901.1197560778960
Content-Type: text/plain; name=XFS-SGI.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fa5gpacd0
Content-Disposition: attachment; filename=XFS-SGI.txt

PGt0d2lsaWdodD4gaSd2ZSBnb3QgYW4gWEZTIHBhcnRpdGlvbiwgaXQgZG9l
c24ndCBtb3VudCAnY3V6IHRoZSBzdXBlcmJsb2NrIGNhbid0IGJlIGZvdW5k
LCB3aGljaCB3YXMgd2VpcmQuIGkgdHJpZWQgeGZzX3JlcGFpciBidXQgaXQg
ZGlkbid0IGdpdmUgbWUgYW55IGdvb2QgcmVzdWx0cy4gaSB0cmllZCB3aXRo
IHhmc19yZXBhaXIgLW8gYXNzdW1lX3hmcyAvZGV2L3NkYSBhbmQgaXQgc3Rp
bGwgZG9lc24ndCBzZWVtIHRvIHdvcmsuIHNvIGhvdyBjYW4gaSBtb3VudCB0
aGlzIHBhcnRpdGlvbiB3aGVuIGl0IGNhbid0IGZpbmQgdGhlIHN1cGVyYmxv
Y2s/IGkga25vdyB0aGVyZSBhcmUgY29udGVudHMgJ2N1eiBpIHRyYW5zZmVy
ZWQgZmlsZXMgdG8gaXQgYW5kIHVtb3VudCBpdCBiZWZvcmUgcmVib290aW5n
Lgo8c2FuZGVlbj4gd2hhdCBoYXBwZW5lZCBiZXR3ZWVuIHdvcmtpbmcgYW5k
IG5vdCB3b3JraW5nPwo8a3R3aWxpZ2h0PiBzYW5kZWVuLCBpIHRyYW5zZmVy
ZWQgZmlsZXMgdG8gaXQsIHVtb3VudCBpdCwgdGhlbiByZWJvb3QKPHNhbmRl
ZW4+IGt0d2lsaWdodCwgaG93IGJpZyBpcyB0aGUgcGFydGl0aW9uCjxzYW5k
ZWVuPiBrdHdpbGlnaHQsIHdoYXQga2VybmVsLCB3aGljaCBwYXJ0aXRpb24s
IHdoYXQgdHlwZSBvZiBibG9jayBkZXZpY2UsIGV0Ywo8a3R3aWxpZ2h0PiAy
LjYuMTgtNSwgaXQncyB0aGUgZW50aXJlIGhkZCwgL2Rldi9oZGIKPGt0d2ls
aWdodD4gd2hhdCBkbyB5b3UgbWVhbiBieSBibG9jayBkZXZpY2U/CjxzYW5k
ZWVuPiB0aGF0J3MgZW5vdWdoCjxzYW5kZWVuPiB3aGF0IGRvZXMgZmlsZSAt
cyAvZGV2L3NkYiBzYXkKPHNhbmRlZW4+IGVyCjxzYW5kZWVuPiBoZGIgOikK
PGt0d2lsaWdodD4gL2Rldi9oZGI6IFNHSSBYRlMgZmlsZXN5c3RlbSBkYXRh
IChibGtzeiA2NTUzNiwgaW5vc3ogMjU2LCB2MiBkaXJzKQo8a3R3aWxpZ2h0
PiBpdCBzaG91bGQgaGF2ZSBhIC9kZXYvaGRiMQo8c2FuZGVlbj4gaHVoLCBv
aywgSSB0aG91Z2h0IG1heWJlIHNvbWV0aGluZyBvdmVyd3JvdGUgaXQKPGt0
d2lsaWdodD4gaXQncyB1bW91bnQsIGFuZCBpIHRyeSBteSBiZXN0IG5vdCB0
byBkbyBhbnl0aGluZyB0byBkbyA6KQo8c2FuZGVlbj4gbm90aGluZyB3cm9u
ZyB3aXRoIHVzaW5nIHRoZSB3aG9sZSBiZGV2CjxrdHdpbGlnaHQ+IGhtLCBi
dXQgaSBjYW4ndCBtb3VudCBlaXRoZXIgaGRiIG9yIGhkYjEKPHNhbmRlZW4+
IHdoaWNoIG9uZSAqc2hvdWxkKiBpdCBiZQo8c2FuZGVlbj4gd2hhdCB1c2Vk
IHRvIG1vdW50IDopCjxzYW5kZWVuPiBpLmUgLndoYXQncyBpbiBmc3RhYgo8
a3R3aWxpZ2h0PiBub3RoaW5nIGluIGZzdGFiCjxrdHdpbGlnaHQ+IGJ1dCBp
IHVzZWQgaGRiMSB0byBtb3VudCBwcmV2aW91c2x5CjxzYW5kZWVuPiB3aGF0
IGRvZXMgZmlsZSAtcyAvZGV2L2hkYjEgc2F5IHRoZW4/CjxzYW5kZWVuPiBv
ciBmZGlzayAtbCAvZGV2L3NkYj8KPGt0d2lsaWdodD4gL2Rldi9oZGIxOiBF
UlJPUjogY2Fubm90IG9wZW4gYC9kZXYvaGRiMScgKE5vIHN1Y2ggZmlsZSBv
ciBkaXJlY3RvcnkpCjxrdHdpbGlnaHQ+IERpc2sgL2Rldi9oZGI6IDI1MC4w
IEdCLCAyNTAwNTkzNTAwMTYgYnl0ZXMKPGt0d2lsaWdodD4gMjU1IGhlYWRz
LCA2MyBzZWN0b3JzL3RyYWNrLCAzMDQwMSBjeWxpbmRlcnMKPGt0d2lsaWdo
dD4gVW5pdHMgPSBjeWxpbmRlcnMgb2YgMTYwNjUgKiA1MTIgPSA4MjI1Mjgw
IGJ5dGVzCjxrdHdpbGlnaHQ+IERpc2sgL2Rldi9oZGIgZG9lc24ndCBjb250
YWluIGEgdmFsaWQgcGFydGl0aW9uIHRhYmxlCjxrdHdpbGlnaHQ+IHRoZSBs
YXN0IHNlbnRlbmNlIGlzIHF1aXRlLi4uIDovCjxzYW5kZWVuPiBlciwgc28s
IHlvdSBubyBsb25nZXIgaGF2ZSBhIHBhcnRpdGlvbiB0YWJsZSwgYnV0IHJh
dGhlciBpdCBpcyBhbiB4ZnMgZmlsZXN5c3RlbSBvbiB0aGUgd2hvbGUgL2Rl
di9oZGIuLi4gd2hpY2ggaXMgZmluZSwgYnV0IG9uIHRoZSBsYXN0IGJvb3Qg
eW91IG1vdW50ZWQgaGRiMT8KPHNhbmRlZW4+IEknbSBoYXZpbmcgYSBoYXJk
IHRpbWUgYmVsaWV2aW5nIHRoYXQgbm90aGluZyBoYXBwZW5lZCBleGNlcHQg
ZmlsZSBjb3BpZXMgYW5kIGEgcmVib290IDopCjxzYW5kZWVuPiBsb29rcyB0
byBtZSBsaWtlIHlvdSBta2ZzJ2QgL2Rldi9oZGIKPHNhbmRlZW4+IGNhbiB5
b3UgbW91bnQgL2Rldi9oZGI/CjxrdHdpbGlnaHQ+IGNhbid0IGJlLi4uCjxr
dHdpbGlnaHQ+IG5vcGUsIGkgY2FuJ3QgbW91bnQgaXQKPHNhbmRlZW4+IHdo
YXQgZG9lcyBkbWVzZyBzYXkgd2hlbiB5b3UgdHJ5Pwo8eG9yQXhBeD4ga3R3
aWxpZ2h0OiBoZXhkdW1wIC1DIHRoZSBmaXJzdCA1MTIgYnl0ZXMgZm9yIHVz
Cjx4b3JBeEF4PiBhbmQgdXNlIHBhc3RlLnBvY29vLm9yZwo8c2FuZGVlbj4g
YSkgeW91IGhhdmUgbm8gcGFydGl0aW9uIHRhYmxlLCB0aHVzIG5vIC9kZXYv
aGRiMSwgYW5kIGIpICJmaWxlIiBmaW5kcyBhbiBYRlMgc3VwZXJibG9jayBk
aXJlY3RseSBvbiBoZGIsIHNvLi4uCjxrdHdpbGlnaHQ+IGRtZXNnIGRvZXNu
J3Qgc2F5IGFueXRoaW5nLCBidXQgbW91bnRpbmcgZ2l2ZXMgbWUgIm1vdW50
OiBGdW5jdGlvbiBub3QgaW1wbGVtZW50ZWQiCiogc2FuZGVlbiB0aGlua3Mg
eGZzIHNob3VsZCBzdG9yZSBta2ZzIHRpbWUgZm9yIGNhc2VzIGxpa2UgdGhp
cyA6KQo8eG9yQXhBeD4gc2FuZGVlbjogaGVoZQo8c2FuZGVlbj4gbHNtb2Qg
fCBncmVwIHhmcyA/IDopCjxrdHdpbGlnaHQ+IHVtLCBzbyBoZXhkdW1wIC1D
IC9kZXYvaGRiPwo8eG9yQXhBeD4ga3R3aWxpZ2h0OiBkZCAuLi4gY291bnQ9
MQo8c2FuZGVlbj4gZGQgaWY9L2Rldi9oZGIgYnM9NTEyIGNvdW50PTEgfCBo
ZXhkdW1wIC1DCjxrdHdpbGlnaHQ+IHhmcyBpcyBsb2FkZWQsIGkgYXZlIG90
aGVyIHhmcyBwYXJ0aXRpb25zIG1vdW50ZWQKPGt0d2lsaWdodD4gaHR0cDov
L3JhZmIubmV0L3AvV0x4SnpkOTAuaHRtbAo8c2FuZGVlbj4gSSBoYXZlIGEg
aGFyZCB0aW1lIGJlbGlldmluZyB0aGF0IG1vdW50IC9kZXYvaGRiIC9zb21l
L3doZXJlIGZhaWxzIGJ1dCBnZW5lcmF0ZXMgbm8ga2VybmVsIG1lc3NhZ2Vz
CjxzYW5kZWVuPiB0cnkgbW91bnQgLXQgeGZzPwo8a3R3aWxpZ2h0PiBodHRw
Oi8vcmFmYi5uZXQvcC9naEtDZ0kzNi5odG1sCjxzYW5kZWVuPiB4ZnNfZGIg
LXIgLWMgInNiIDAiIC1jIHAgL2Rldi9zZGIgCjxzYW5kZWVuPiBhbmQgbW91
bnQgLXQgeGZzIC9kZXYvaGRiIC9zb21lL3doZXJlOyBkbWVzZyB8IHRhaWwg
LW4gMTAKPGt0d2lsaWdodD4gaHR0cDovL3JhZmIubmV0L3AvR0w5NWJlNDgu
aHRtbAo8c2FuZGVlbj4gc29ycnkgcy9zZGIvaGRiLyA6KQo8a3R3aWxpZ2h0
PiBucCA7KQo8c2FuZGVlbj4gZXcKPGt0d2lsaWdodD4gaHR0cDovL3JhZmIu
bmV0L3AvQWNpbEx6MzAuaHRtbAo8a3R3aWxpZ2h0PiBub3QgYSBnb29kIGV3
IGkgZ3Vlc3MKPGt0d2lsaWdodD4gdGhhdCBzZWdmYXVsdCBpc24ndCBuaWNl
CjxzYW5kZWVuPiBlcnJyCjxzYW5kZWVuPiBYRlMgbW91bnRpbmcgZmlsZXN5
c3RlbSBzZGIxCjxzYW5kZWVuPiBFbmRpbmcgY2xlYW4gWEZTIG1vdW50IGZv
ciBmaWxlc3lzdGVtOiBzZGIxCjxzYW5kZWVuPiBvaCBzZGIKPHNhbmRlZW4+
IGdlZXNoCjxrdHdpbGlnaHQ+IGRpZmZlcmVudCA7KQo8c2FuZGVlbj4geW91
J2QgdGhpbmsgSSdkIGhhdmUgdGhpcyBzdHJhaWdodCBieSBub3cgOikKPHNh
bmRlZW4+ICpzaWdoKgo8a3R3aWxpZ2h0PiBpdCdzIGhkYiwgTk9UIHNkYgo8
a3R3aWxpZ2h0PiB0aG91Z2ggaSBoYXZlIGFuIHNkYiBhbmQgaXQncyB3b3Jr
aW5nIHBlcmZlY3RseS4KPGt0d2lsaWdodD4gbGV0J3Mgbm90IHRvdWNoIGl0
IDopCjxrdHdpbGlnaHQ+IHNvIGRtZXNnIGRvZXNuJ3Qgc2F5IGFueXRoaW5n
IHdoZW4gdHJ5aW5nIHRvIG1vdW50IGhkYgo8c2FuZGVlbj4gd2VpcmQgdGhh
dCB4ZnNfZGIgc2VnZmF1bHRzCjxzYW5kZWVuPiBpcyB0aGlzIGxhdGVzdCB4
ZnNwcm9ncz8KPGt0d2lsaWdodD4gMi44LjExLTEgCjxrdHdpbGlnaHQ+IGRl
YmlhbiBldGNoLgo8a3R3aWxpZ2h0PiBpdCdzICJzdGFibGUiIDopCjxzYW5k
ZWVuPiBtaWdodCB0cnkgdmVyeSBsYXRlc3QgeGZzcHJvZ3MgZm9yIGZ1bgo8
a3R3aWxpZ2h0PiAuLi4KPHNhbmRlZW4+IGp1c3QgdG8gc2VlIGlmIHdlIGNh
biBleGFtaW5lIGl0IG1vcmUKPGt0d2lsaWdodD4gc28gaSBzaG91bGQgZ3Jh
YiBpdCBvZmYgc2lkPwo8a3R3aWxpZ2h0PiB0ZWxsIG1lIHdoYXQgeW91IGtu
b3cgc28gZmFyIG9yIGl0cyBhc3N1bXB0aW9ucwo8c2FuZGVlbj4gb3IgdXNl
IHhmc19tZXRhZHVtcCB0byBnZXQgYW4gZnMgaW1hZ2UsIGFuZCBwcm92aWRl
IGl0IHRvIHRoZSBzZ2kgZ3V5cwo8c2FuZGVlbj4gYXQgYSBtaW5pbXVtIHhm
c19kYiBzaG91bGQgbm90IHNlZ2ZhdWx0CjxrdHdpbGlnaHQ+IGhtCjxzYW5k
ZWVuPiB3ZWxsLCBzbyBmYXIsIGJhcmUgaGRiIGhhcyBhdCBsZWFzdCB0aGUg
YmVnaW5uaW5nIG9mIGFuIHhmcyBmaWxlc3lzdGVtIHNpZ25hdHVyZSwgWEZT
QiBpcyBzdXBlIGJsb2NrIG1hZ2ljCjxzYW5kZWVuPiBhbmQsIHlvdSBoYXZl
IG5vIHBhcnRpdGlvbiB0YWJsZSBvbiBoZGIKPGt0d2lsaWdodD4gc28gYmFz
aWNhbGx5IGkgaGF2ZSBubyBmaWxlcyBvbiBoZGI/CjxrdHdpbGlnaHQ+IG5v
IHdheSBvZiByZWNvdmVyaW5nPwo8c2FuZGVlbj4gbm90IHN1cmUgeWV0Cjxr
dHdpbGlnaHQ+IGdyZWF0IDopCjxzYW5kZWVuPiBidXQsIEkgZG9uJ3QgcXVp
dGUgYmVsaWV2ZSB0aGF0IHlvdSBoYWQgL2Rldi9oZGIxIG1vdW50ZWQsIGNv
cGllZCBmaWxlcywgdW1vdW50ZWQsIGFuZCBzdWRkZW5seSB5b3UgaGFkIG5v
IG1vcmUgcGFydGl0aW9uIHRhYmxlCjxzYW5kZWVuPiBzb21ldGhpbmcgZWxz
ZSBoYXBwZW5lZCBpbiBiZXR3ZWVuIHdoZXRoZXIgeW91IGRpZCBpdCB5b3Vy
c2VsZiBvciBzb21ldGhpbmcgZGlkIGl0IHRvIHlvdSBJIHRoaW5rIDopCjxr
dHdpbGlnaHQ+IGkgZG9uJ3QgYmVsaWV2ZSBpdCBlaXRoZXIsIGJ1dCB0aGF0
J3MgdGhlIHRydXRoLgo8a3R3aWxpZ2h0PiB3ZWxsLCByYXRoZXIgdGhhbiBj
b3B5LCBpdCB3YXMgYSBtb3ZlLiBkb2VzIHRoYXQgbWFrZSBhbnkgZGlmZmVy
ZW5jZT8gOlAKPHNhbmRlZW4+IHdoYXQga2luZCBvZiBwYXJ0aXRpb24gdGFi
bGUgZGlkIHlvdSBoYXZlPwo8c2FuZGVlbj4gZG9zIG9yIGdwdD8KPGt0d2ls
aWdodD4gZG9zCjxzYW5kZWVuPiB5b3VyIHJvb3QgaW5vZGUgbnIgZnJvbSB0
aGUgaGV4ZHVtcCBpcyBhIGxpdHRsZSBmdW5reQo8a3R3aWxpZ2h0PiBiYWQg
ZnVua3k/CjxrdHdpbGlnaHQ+IGssIGZpbmFsbHkgZ2V0dGluJyBzaWQncyB4
ZnNwcm9ncwo8a3R3aWxpZ2h0PiBncmVhdCwgeGZzX2RiIHNlZ2ZhdWx0cyB0
b28gOikKPGt0d2lsaWdodD4geGZzcHJvZ3MgMi45LjQtMgo8c2FuZGVlbj4g
aG1tCjxzYW5kZWVuPiBvdGhlciBzYW1lIG1lc3NhZ2VzPwo8c2FuZGVlbj4g
Y2FjaGVfbm9kZSBzdHVmZiBvciBubwo8a3R3aWxpZ2h0PiBub3QgcmVhbGx5
CjxrdHdpbGlnaHQ+IGh0dHA6Ly9yYWZiLm5ldC9wL2U0dVlOQzU4Lmh0bWwK
PHNhbmRlZW4+IHNhbWUgc3R1ZmYKPGt0d2lsaWdodD4gbyBvayA6fAo8a3R3
aWxpZ2h0PiBub2RlIGlzIGRpZmZlcmVudC4gdGhhdCBoZWxwcz8KPGt0d2ls
aWdodD4gaGFoYQo8a3R3aWxpZ2h0PiBzYW5kZWVuLCB3b3VsZCB4ZnNfZnNy
IGhlbHA/CjxzYW5kZWVuPiBubwo8c2FuZGVlbj4geW91IGhhdmUgdG8gbW91
bnQgaXQgZmlyc3QgOikKPGt0d2lsaWdodD4gOigKPGt0d2lsaWdodD4gaG93
ICdib3V0IHhmc19jaGVjayBvciB4ZnNfYWRtaW4/CjxzYW5kZWVuPiBub3Qg
dGhhdCBpdCdkIGhlbHAgYW55d2F5CjxrdHdpbGlnaHQ+IGhtCjxrdHdpbGln
aHQ+IHNvIHdoYXQgYXJlIG15IG9wdGlvbnM/CjxzYW5kZWVuPiBpZiB4ZnNf
ZGIgY2FuJ3QgZXZlbiByZWNvZ25pemUgdGhlIGZpbGVzeXN0ZW0gdGhpbmdz
IGFyZW4ndCBzbyBnb29kCjxrdHdpbGlnaHQ+IHdvdWxkIGRkIGhlbHA/IGxl
dCdzIHNheSBpIHNraXAgdGhlIGZpcnN0IGZldyBieXRlcwo8a3R3aWxpZ2h0
PiB0aGVuIG1vdW50IGl0IGFzIGFuIGlzby4KPGhhbm5lc2Q+IG5vIGJhY2t1
cD8KPGt0d2lsaWdodD4gaGFubmVzZCwgeWVzLCBidXQgbm90IHRoYXQgdXAg
dG8gZGF0ZSA6Lwo8a3R3aWxpZ2h0PiBpZiBpIGNhbiByZWNvdmVyLCBpdCdk
IGJlIGJldHRlci4KPHNhbmRlZW4+IGp1c3QgZm9yIGZ1biwgZG9lcyBkZCBp
Zj0vZGV2L2hkYiBicz01MTIgY291bnQ9MzIgfCBoZXhkdW1wIC1DIHwgZ3Jl
cCBYRlNCIHR1cm4gdXAgbW9yZSB0aGFuIDEgWEZTQj8KKiBzYW5kZWVuIGd1
ZXNzZXMgYXQgdGhlIGNvdW50PTMyLCBidXQgaGRiMSBwcm9iYWJseSBzdGFy
dGVkIGJlZm9yZSAxNmsKPGt0d2lsaWdodD4gaHR0cDovL3JhZmIubmV0L3Av
dEhxV3liODguaHRtbAo8a3R3aWxpZ2h0PiBpIG9ubHkgc2VlIG9uZS4KPHNh
bmRlZW4+IG5vcGUKPGt0d2lsaWdodD4gaG0sIHNvIGl0J3Mgbm90IGdvb2Qu
CjxrdHdpbGlnaHQ+IHNvIHNob3VsZCBpIGp1c3QgZm9yZ2V0IGFib3V0IGl0
PyBvciBpcyB0aGVyZSBhIGdsaW1wc2Ugb2YgaG9wZSBzb21ld2hlcmU/IDop
CjxzYW5kZWVuPiB3YXMgZ29ubmEgbG9vayBvdmVyIHRoZSBmaXJzdCBoZXhk
dW1wIGEgYml0CjxrdHdpbGlnaHQ+IG9rCjxzYW5kZWVuPiAwMCAwMCAwMCAw
MCAwMCAwMCAwOSAwMCBzaG91bGQgYmUgeW91ciByb290IGlub2RlLCB3aGlj
aCBpcyBub3QgMjIsIHNvIGEgbGl0dGxlIGNvbmZ1c2VkIGFib3V0IHdoeSBp
dCBpcyBzc2F5aW5nIHJvb3Rpbm8gMjIgd2hlbiB5b3UgdHJ5IHhmc19kYgo8
c2FuZGVlbj4gdW5sZXNzIHRoYXQncyBFSU5WQUwgdGhhdCBnb3QgbG9zdAo8
c2FuZGVlbj4gY2FuIHlvdSB1c2UgeGZzX21ldGFkdW1wIHRvIG1ha2UgYW4g
ZnMgaW1hZ2U/ICAgbWF5YmUgdGhlIHNnaSBndXlzIGNhbiBoZWxwIGZ1cnRo
ZXIKPGt0d2lsaWdodD4gc29tZSBtb25zdGVyIGF0ZSBpdCBpIHNlZS4KPGt0
d2lsaWdodD4gaG93IGJpZyB3b3VsZCB0aGUgZnMgaW1hZ2UgYmU/IGFzIGJp
ZyBhcyB0aGUgcGFydGl0aW9uPwo8c2FuZGVlbj4gYXQgbGVhc3QgYm5hdWpv
ayB3b3VsZCBwcm9iYWJseSBsaWtlIHRvIHNlZSB3aGF0J3MgZ29pbmcgb24g
d2l0aCB4ZnNfZGIKPHNhbmRlZW4+IG5vIGl0IG9ubHkgZHVtcHMgbWV0YWRh
dGEgbm8gZGF0YQo8c2FuZGVlbj4gc28gaXQgc2hvdWxkIGJlIHNpZ25pZmlj
YW50bHkgc21hbGxlcgo8a3R3aWxpZ2h0PiBobQo8c2FuZGVlbj4gYnV0IGlm
IGRiIGNhbid0IHJlYWQgaXQsIG1ldGFkdW1wIG1pZ2h0IG5vdCBlaXRoZXIK
PGt0d2lsaWdodD4geWEgZ290dGEgc2VlIHRoaXMKPGt0d2lsaWdodD4gaHR0
cDovL3JhZmIubmV0L3Avb2pWQU55NzMuaHRtbAo8c2FuZGVlbj4geWVhaCwg
bGlieGZzIHByb2JsZW0sIEkgd2FzIHNvcnRhIGFmcmFpZCBvZiB0aGF0Cjxz
YW5kZWVuPiB3ZWxsLiAgdW5kZXJseWluZyBwcm9ibGVtIGlzIHdoYXQncyBv
biB5b3VyIGRpc2ssIGJ1dCB0aGVuIGxpYnhmcyBpc24ndCBjb3Bpbmcgd2Vs
bCBlaXRoZXIKPHNhbmRlZW4+IG1heWJlIHRoZSBmaXJzdCBmZXcgSyBvZiB0
aGUgZnMgd291bGQgYmUgZW5vdWdoIGZvciB0aGVtIHRvIGRpZyBpbiBmdXJ0
aGVyCjxrdHdpbGlnaHQ+IGhtCjxzYW5kZWVuPiBJIHNob3VsZCBiZSB3b3Jr
aW5nIG9uIGFub3RoZXIgZnMgcmlnaHQgbm93IDstKQo8a3R3aWxpZ2h0PiA6
KQo8a3R3aWxpZ2h0PiBrLCBzbyBpIHdpbGwgc2VuZCB4ZnNfbWV0YWR1bXAs
IGFuZCB4ZnNfZGIgdG8gc2dpPwo8a3R3aWxpZ2h0PiB3aGF0IGVsc2Ugc2hv
dWxkIGkgaW5jbHVkZSBpbiB0aGUgZW1haWw/CjxoYW5uZXNkPiB0aGUgY2hh
dCBsb2cgbWF5YmUgOikKPGt0d2lsaWdodD4gOikKPGt0d2lsaWdodD4gYSBo
ZWNrIGxvYWQgb2Ygc3R1ZmYgdGhlbgo8a3R3aWxpZ2h0PiBlbWFpbD8gc3Vw
cG9ydEBzZ2kuY29tPwo8c2FuZGVlbj4geGZzQHNnaS5jb20KPHNhbmRlZW4+
IG9wZW4gc291cmNlIHhmcyBsaXN0CjxzYW5kZWVuPiBoZXhkdW1wIG9mIGhk
YiB3b3VsZCBiZSBhIHBsYWNlIHRvIHN0YXJ0LCBhbG9uZyB3LyB4ZnNfZGIg
cmVzdWx0cwo8a3R3aWxpZ2h0PiBubSwgZm91bmQuIHhmc0Bvc3Muc2dpLmNv
bQo8c2FuZGVlbj4gYW5kIGEgc3dvcm4gc3RhdGVtZW50IHRoYXQgb2ggcmVh
bGx5IHRoaXMgdXNlZCB0byBiZSBoZGIxIGJ1dCBpdCBtYWdpY2FsbHkgbW92
ZWQgOikK

------=_Part_35143_13710901.1197560778960--
