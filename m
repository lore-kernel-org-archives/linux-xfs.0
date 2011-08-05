Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p75ELGBO123278 for <xfs@oss.sgi.com>; Fri, 5 Aug 2011 09:21:17 -0500
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E72C15FA6AF
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2011 07:22:15 -0700 (PDT)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	iAdjE5fWtbXubjYW for <xfs@oss.sgi.com>;
	Fri, 05 Aug 2011 07:22:15 -0700 (PDT)
Received: by gxk9 with SMTP id 9so761891gxk.26
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2011 07:21:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Aug 2011 18:21:13 +0400
Message-ID: <CAGqmV7rDPjKt4yu=9DwDfwTAeVkSSdwUb6sf8Yte7wh3RTTj9w@mail.gmail.com>
Subject: [PATCH, v2] xfs: adding example with xfs_info output decryption
From: CoolCold <coolthecold@gmail.com>
Content-Type: multipart/mixed; boundary=000e0cd2e2ec48138e04a9c2cfc0
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
To: xfs@oss.sgi.com

--000e0cd2e2ec48138e04a9c2cfc0
Content-Type: text/plain; charset=ISO-8859-1

Basing on irc discussions and questions about reading xfs_info output
I've added example in xfs_growfs manpage.

This is 2nd version of manpage patch which contains fixes provided by
Alex Elder.

( just in case gmail will eat formatting, patch is attached )

Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
---
 man/man8/xfs_growfs.8 |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index 02793ae..27f5117 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -1,3 +1,14 @@
+.\" Verbatim blocks taken from openssl req manpage content
+.de Vb \" Begin verbatim text
+.ft CW
+.nf
+.ne \\$1
+..
+.de Ve \" End verbatim text
+.ft R
+.fi
+..
+
 .TH xfs_growfs 8
 .SH NAME
 xfs_growfs, xfs_info \- expand an XFS filesystem
@@ -105,6 +116,7 @@ this is specified with
 Specifies that no change to the filesystem is to be made.
 The filesystem geometry is printed, and argument checking is performed,
 but no growth occurs.
+.B See output examples below.
 .TP
 .BI "\-r | \-R " size
 Specifies that the real-time section of the filesystem should be grown. If the
@@ -152,6 +164,33 @@ reside. In order to grow a filesystem, it is
necessary to provide added
 space for it to occupy. Therefore there must be at least one spare new
 disk partition available. Adding the space is often done through the use
 of a logical volume manager.
+.SH "EXAMPLES"
+
+Understanding xfs_info output.
+.PP
+Let's assume one have the next "xfs_info /dev/sda" output:
+.PP
+.RS 2
+.Vb
+\&meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
+\&         =              sectsz=512   attr=2
+\&data     =              bsize=4096   blocks=536869888, imaxpct=5
+\&         =              sunit=32     swidth=128 blks
+\&naming   =version 2     bsize=4096
+\&log      =internal      bsize=4096   blocks=32768, version=2
+\&         =              sectsz=512   sunit=32 blks, lazy-count=1
+\&realtime =none          extsz=524288 blocks=0, rtextents=0
+.Ve
+.RE
+.PP
+
+Here, the data section of the output indicates "bsize=4096",
+meaning the data block size for this filesystem is 4096 bytes.
+This section also shows "sunit=32 swidth=128 blks", which means
+the stripe unit is 32*4096 bytes = 128 kibibytes and the stripe
+width is 128*4096 bytes = 512 kibibytes.
+A single stripe of this filesystem therefore consists
+of four stripe units (128 blocks / 32 blocks per unit).
 .SH SEE ALSO
 .BR mkfs.xfs (8),
 .BR md (4),
-- 
1.7.2.5



-- 
Best regards,
[COOLCOLD-RIPN]

--000e0cd2e2ec48138e04a9c2cfc0
Content-Type: application/octet-stream;
	name="0001-adding-example-with-xfs_info-decryption.patch"
Content-Disposition: attachment;
	filename="0001-adding-example-with-xfs_info-decryption.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqz8s9gt0

RnJvbSA0YmRmZjVkMGZlZWFlODNkODU2NzhlZjViM2E3MjUxMzcxNmZmNDE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb21hbiBPdmNoaW5uaWtvdiA8Y29vbHRoZWNvbGRAZ21haWwu
Y29tPgpEYXRlOiBTYXQsIDIxIE1heSAyMDExIDA0OjA1OjMzICswNDAwClN1YmplY3Q6IFtQQVRD
SF0gYWRkaW5nIGV4YW1wbGUgd2l0aCB4ZnNfaW5mbyBkZWNyeXB0aW9uCgoKU2lnbmVkLW9mZi1i
eTogUm9tYW4gT3ZjaGlubmlrb3YgPGNvb2x0aGVjb2xkQGdtYWlsLmNvbT4KLS0tCiBtYW4vbWFu
OC94ZnNfZ3Jvd2ZzLjggfCAgIDM5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKwogMSBmaWxlcyBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL21hbi9tYW44L3hmc19ncm93ZnMuOCBiL21hbi9tYW44L3hmc19ncm93ZnMu
OAppbmRleCAwMjc5M2FlLi4yN2Y1MTE3IDEwMDY0NAotLS0gYS9tYW4vbWFuOC94ZnNfZ3Jvd2Zz
LjgKKysrIGIvbWFuL21hbjgveGZzX2dyb3dmcy44CkBAIC0xLDMgKzEsMTQgQEAKKy5cIiBWZXJi
YXRpbSBibG9ja3MgdGFrZW4gZnJvbSBvcGVuc3NsIHJlcSBtYW5wYWdlIGNvbnRlbnQKKy5kZSBW
YiBcIiBCZWdpbiB2ZXJiYXRpbSB0ZXh0CisuZnQgQ1cKKy5uZgorLm5lIFxcJDEKKy4uCisuZGUg
VmUgXCIgRW5kIHZlcmJhdGltIHRleHQKKy5mdCBSCisuZmkKKy4uCisKIC5USCB4ZnNfZ3Jvd2Zz
IDgKIC5TSCBOQU1FCiB4ZnNfZ3Jvd2ZzLCB4ZnNfaW5mbyBcLSBleHBhbmQgYW4gWEZTIGZpbGVz
eXN0ZW0KQEAgLTEwNSw2ICsxMTYsNyBAQCB0aGlzIGlzIHNwZWNpZmllZCB3aXRoCiBTcGVjaWZp
ZXMgdGhhdCBubyBjaGFuZ2UgdG8gdGhlIGZpbGVzeXN0ZW0gaXMgdG8gYmUgbWFkZS4KIFRoZSBm
aWxlc3lzdGVtIGdlb21ldHJ5IGlzIHByaW50ZWQsIGFuZCBhcmd1bWVudCBjaGVja2luZyBpcyBw
ZXJmb3JtZWQsCiBidXQgbm8gZ3Jvd3RoIG9jY3Vycy4KKy5CIFNlZSBvdXRwdXQgZXhhbXBsZXMg
YmVsb3cuCiAuVFAKIC5CSSAiXC1yIHwgXC1SICIgc2l6ZQogU3BlY2lmaWVzIHRoYXQgdGhlIHJl
YWwtdGltZSBzZWN0aW9uIG9mIHRoZSBmaWxlc3lzdGVtIHNob3VsZCBiZSBncm93bi4gSWYgdGhl
CkBAIC0xNTIsNiArMTY0LDMzIEBAIHJlc2lkZS4gSW4gb3JkZXIgdG8gZ3JvdyBhIGZpbGVzeXN0
ZW0sIGl0IGlzIG5lY2Vzc2FyeSB0byBwcm92aWRlIGFkZGVkCiBzcGFjZSBmb3IgaXQgdG8gb2Nj
dXB5LiBUaGVyZWZvcmUgdGhlcmUgbXVzdCBiZSBhdCBsZWFzdCBvbmUgc3BhcmUgbmV3CiBkaXNr
IHBhcnRpdGlvbiBhdmFpbGFibGUuIEFkZGluZyB0aGUgc3BhY2UgaXMgb2Z0ZW4gZG9uZSB0aHJv
dWdoIHRoZSB1c2UKIG9mIGEgbG9naWNhbCB2b2x1bWUgbWFuYWdlci4KKy5TSCAiRVhBTVBMRVMi
CisKK1VuZGVyc3RhbmRpbmcgeGZzX2luZm8gb3V0cHV0LgorLlBQCitMZXQncyBhc3N1bWUgb25l
IGhhdmUgdGhlIG5leHQgInhmc19pbmZvIC9kZXYvc2RhIiBvdXRwdXQ6CisuUFAKKy5SUyAyCisu
VmIKK1wmbWV0YS1kYXRhPS9kZXYvc2RhICAgICAgaXNpemU9MjU2ICAgIGFnY291bnQ9MzIsIGFn
c2l6ZT0xNjc3NzE4NCBibGtzCitcJiAgICAgICAgID0gICAgICAgICAgICAgIHNlY3Rzej01MTIg
ICBhdHRyPTIKK1wmZGF0YSAgICAgPSAgICAgICAgICAgICAgYnNpemU9NDA5NiAgIGJsb2Nrcz01
MzY4Njk4ODgsIGltYXhwY3Q9NQorXCYgICAgICAgICA9ICAgICAgICAgICAgICBzdW5pdD0zMiAg
ICAgc3dpZHRoPTEyOCBibGtzCitcJm5hbWluZyAgID12ZXJzaW9uIDIgICAgIGJzaXplPTQwOTYK
K1wmbG9nICAgICAgPWludGVybmFsICAgICAgYnNpemU9NDA5NiAgIGJsb2Nrcz0zMjc2OCwgdmVy
c2lvbj0yCitcJiAgICAgICAgID0gICAgICAgICAgICAgIHNlY3Rzej01MTIgICBzdW5pdD0zMiBi
bGtzLCBsYXp5LWNvdW50PTEKK1wmcmVhbHRpbWUgPW5vbmUgICAgICAgICAgZXh0c3o9NTI0Mjg4
IGJsb2Nrcz0wLCBydGV4dGVudHM9MAorLlZlCisuUkUKKy5QUAorCitIZXJlLCB0aGUgZGF0YSBz
ZWN0aW9uIG9mIHRoZSBvdXRwdXQgaW5kaWNhdGVzICJic2l6ZT00MDk2IiwKK21lYW5pbmcgdGhl
IGRhdGEgYmxvY2sgc2l6ZSBmb3IgdGhpcyBmaWxlc3lzdGVtIGlzIDQwOTYgYnl0ZXMuCitUaGlz
IHNlY3Rpb24gYWxzbyBzaG93cyAic3VuaXQ9MzIgc3dpZHRoPTEyOCBibGtzIiwgd2hpY2ggbWVh
bnMKK3RoZSBzdHJpcGUgdW5pdCBpcyAzMio0MDk2IGJ5dGVzID0gMTI4IGtpYmlieXRlcyBhbmQg
dGhlIHN0cmlwZQord2lkdGggaXMgMTI4KjQwOTYgYnl0ZXMgPSA1MTIga2liaWJ5dGVzLgorQSBz
aW5nbGUgc3RyaXBlIG9mIHRoaXMgZmlsZXN5c3RlbSB0aGVyZWZvcmUgY29uc2lzdHMKK29mIGZv
dXIgc3RyaXBlIHVuaXRzICgxMjggYmxvY2tzIC8gMzIgYmxvY2tzIHBlciB1bml0KS4KIC5TSCBT
RUUgQUxTTwogLkJSIG1rZnMueGZzICg4KSwKIC5CUiBtZCAoNCksCi0tIAoxLjcuMi41Cgo=
--000e0cd2e2ec48138e04a9c2cfc0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--000e0cd2e2ec48138e04a9c2cfc0--
