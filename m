Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6A8D7F50
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 09:26:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B52178F8052
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 07:26:17 -0700 (PDT)
Received: from mail.rvx.is (mail.rvx.is [178.19.51.189]) by cuda.sgi.com with
	ESMTP id XVKaEEDKkATOCfTp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2015 07:26:14 -0700 (PDT)
Date: Wed, 11 Mar 2015 14:26:13 +0000 (GMT)
From: Rui Gomes <rgomes@rvx.is>
Message-ID: <410959445.428221.1426083973347.JavaMail.zimbra@rvx.is>
In-Reply-To: <54FF2BBF.7060404@sandeen.net>
References: <54FDFEDC.5090106@sandeen.net>
	<1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>
	<54FF2BBF.7060404@sandeen.net>
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_428219_1941966493.1426083973345"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

------=_Part_428219_1941966493.1426083973345
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello Eric,

Thank you for the quick reply yesterday, I got to try the new patched version today,
and we have now a segmentation fault at a different stage of the repair  \o/ 
Full output plus gdb traceback in the attachment.

Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360

----- Original Message -----
From: "Eric Sandeen" <sandeen@sandeen.net>
To: "Rui Gomes" <rgomes@rvx.is>
Cc: "xfs" <xfs@oss.sgi.com>
Sent: Tuesday, 10 March, 2015 17:37:03
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts beyond dir size

On 3/10/15 1:27 PM, Rui Gomes wrote:
> Hello Eric, 
> 
> I clone the xfs git "git://oss.sgi.com/xfs/cmds/xfsprogs" and I couldn't find the code in any of the branch's
> Is the code in a public available git?

The latest userspae code is currently at git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

The patch I sent applies on top of that, it's not yet been committed to the repo.
The patch as sent should get you through your segfault, but we'll probably end
up merging something a bit different.

-Eric
------=_Part_428219_1941966493.1426083973345
Content-Type: text/plain; name=xfs_gdb.txt
Content-Disposition: attachment; filename=xfs_gdb.txt
Content-Transfer-Encoding: base64

W3Jvb3RAaWNlc3M4YSByZXBhaXJdIyBnZGIgLi94ZnNfcmVwYWlyIApHTlUgZ2RiIChHREIpIFJl
ZCBIYXQgRW50ZXJwcmlzZSBMaW51eCA3LjYuMS01MS5lbDcKQ29weXJpZ2h0IChDKSAyMDEzIEZy
ZWUgU29mdHdhcmUgRm91bmRhdGlvbiwgSW5jLgpMaWNlbnNlIEdQTHYzKzogR05VIEdQTCB2ZXJz
aW9uIDMgb3IgbGF0ZXIgPGh0dHA6Ly9nbnUub3JnL2xpY2Vuc2VzL2dwbC5odG1sPgpUaGlzIGlz
IGZyZWUgc29mdHdhcmU6IHlvdSBhcmUgZnJlZSB0byBjaGFuZ2UgYW5kIHJlZGlzdHJpYnV0ZSBp
dC4KVGhlcmUgaXMgTk8gV0FSUkFOVFksIHRvIHRoZSBleHRlbnQgcGVybWl0dGVkIGJ5IGxhdy4g
IFR5cGUgInNob3cgY29weWluZyIKYW5kICJzaG93IHdhcnJhbnR5IiBmb3IgZGV0YWlscy4KVGhp
cyBHREIgd2FzIGNvbmZpZ3VyZWQgYXMgIng4Nl82NC1yZWRoYXQtbGludXgtZ251Ii4KRm9yIGJ1
ZyByZXBvcnRpbmcgaW5zdHJ1Y3Rpb25zLCBwbGVhc2Ugc2VlOgo8aHR0cDovL3d3dy5nbnUub3Jn
L3NvZnR3YXJlL2dkYi9idWdzLz4uLi4KUmVhZGluZyBzeW1ib2xzIGZyb20gL3Jvb3QveGZzcHJv
Z3MtZGV2L3JlcGFpci94ZnNfcmVwYWlyLi4uZG9uZS4KKGdkYikgcnVuIC1MIC1QIC12dnYgL2Rl
di9zZGIxClN0YXJ0aW5nIHByb2dyYW06IC9yb290L3hmc3Byb2dzLWRldi9yZXBhaXIvLi94ZnNf
cmVwYWlyIC1MIC1QIC12dnYgL2Rldi9zZGIxCltUaHJlYWQgZGVidWdnaW5nIHVzaW5nIGxpYnRo
cmVhZF9kYiBlbmFibGVkXQpVc2luZyBob3N0IGxpYnRocmVhZF9kYiBsaWJyYXJ5ICIvbGliNjQv
bGlidGhyZWFkX2RiLnNvLjEiLgpQaGFzZSAxIC0gZmluZCBhbmQgdmVyaWZ5IHN1cGVyYmxvY2su
Li4KICAgICAgICAtIG1heF9tZW0gPSAyNDU2MjcwMSwgaWNvdW50ID0gMjI2MjgyMjQsIGltZW0g
PSA4ODM5MSwgZGJsb2NrID0gMzkwNDI5NDE0NCwgZG1lbSA9IDE5MDYzOTMKICAgICAgICAtIGJs
b2NrIGNhY2hlIHNpemUgc2V0IHRvIDI4MTQ3MzYgZW50cmllcwpQaGFzZSAyIC0gdXNpbmcgaW50
ZXJuYWwgbG9nCiAgICAgICAgLSB6ZXJvIGxvZy4uLgp6ZXJvX2xvZzogaGVhZCBibG9jayA4IHRh
aWwgYmxvY2sgOAogICAgICAgIC0gc2NhbiBmaWxlc3lzdGVtIGZyZWVzcGFjZSBhbmQgaW5vZGUg
bWFwcy4uLgpbTmV3IFRocmVhZCAweDdmZmZlZjk1MDcwMCAoTFdQIDc3MzIpXQpbTmV3IFRocmVh
ZCAweDdmZmZlZjE0ZjcwMCAoTFdQIDc3MzMpXQpbTmV3IFRocmVhZCAweDdmZmZlZTk0ZTcwMCAo
TFdQIDc3MzQpXQpbTmV3IFRocmVhZCAweDdmZmZlZTE0ZDcwMCAoTFdQIDc3MzUpXQpbTmV3IFRo
cmVhZCAweDdmZmZlZDk0YzcwMCAoTFdQIDc3MzYpXQpbTmV3IFRocmVhZCAweDdmZmZlZDE0Yjcw
MCAoTFdQIDc3MzcpXQpbTmV3IFRocmVhZCAweDdmZmZlYzk0YTcwMCAoTFdQIDc3MzgpXQpbTmV3
IFRocmVhZCAweDdmZmZlYzE0OTcwMCAoTFdQIDc3MzkpXQpbTmV3IFRocmVhZCAweDdmZmZlYjk0
ODcwMCAoTFdQIDc3NDApXQpbTmV3IFRocmVhZCAweDdmZmZlYjE0NzcwMCAoTFdQIDc3NDEpXQpb
TmV3IFRocmVhZCAweDdmZmZlYTk0NjcwMCAoTFdQIDc3NDIpXQpbTmV3IFRocmVhZCAweDdmZmZl
YTE0NTcwMCAoTFdQIDc3NDMpXQpbTmV3IFRocmVhZCAweDdmZmZlOTk0NDcwMCAoTFdQIDc3NDQp
XQpbTmV3IFRocmVhZCAweDdmZmZlOTE0MzcwMCAoTFdQIDc3NDUpXQpbTmV3IFRocmVhZCAweDdm
ZmZlODk0MjcwMCAoTFdQIDc3NDYpXQpbTmV3IFRocmVhZCAweDdmZmZlODE0MTcwMCAoTFdQIDc3
NDcpXQpbTmV3IFRocmVhZCAweDdmZmZlNzk0MDcwMCAoTFdQIDc3NDgpXQpbTmV3IFRocmVhZCAw
eDdmZmZlNzEzZjcwMCAoTFdQIDc3NDkpXQpbTmV3IFRocmVhZCAweDdmZmZlNjkzZTcwMCAoTFdQ
IDc3NTApXQpbTmV3IFRocmVhZCAweDdmZmZlNjEzZDcwMCAoTFdQIDc3NTEpXQpbTmV3IFRocmVh
ZCAweDdmZmZlNTkzYzcwMCAoTFdQIDc3NTIpXQpbTmV3IFRocmVhZCAweDdmZmZlNTEzYjcwMCAo
TFdQIDc3NTMpXQpbTmV3IFRocmVhZCAweDdmZmZlNDkzYTcwMCAoTFdQIDc3NTQpXQpbTmV3IFRo
cmVhZCAweDdmZmZlNDEzOTcwMCAoTFdQIDc3NTUpXQpbTmV3IFRocmVhZCAweDdmZmZlMzkzODcw
MCAoTFdQIDc3NTYpXQpbTmV3IFRocmVhZCAweDdmZmZlMzEzNzcwMCAoTFdQIDc3NTcpXQpbTmV3
IFRocmVhZCAweDdmZmZlMjkzNjcwMCAoTFdQIDc3NTgpXQpbTmV3IFRocmVhZCAweDdmZmZlMjEz
NTcwMCAoTFdQIDc3NTkpXQpbTmV3IFRocmVhZCAweDdmZmZlMTkzNDcwMCAoTFdQIDc3NjApXQpb
TmV3IFRocmVhZCAweDdmZmZlMTEzMzcwMCAoTFdQIDc3NjEpXQpbTmV3IFRocmVhZCAweDdmZmZl
MDkzMjcwMCAoTFdQIDc3NjIpXQpbTmV3IFRocmVhZCAweDdmZmZlMDEzMTcwMCAoTFdQIDc3NjMp
XQpTQiBzYW5pdHkgY2hlY2sgZmFpbGVkCk1ldGFkYXRhIGNvcnJ1cHRpb24gZGV0ZWN0ZWQgYXQg
YmxvY2sgMHg0ZmZlZDZkMDAvMHgxMDAwCk1ldGFkYXRhIGNvcnJ1cHRpb24gZGV0ZWN0ZWQgYXQg
YmxvY2sgMHg0ZmZlZDZkMDgvMHgxMDAwCmJhZCBvbi1kaXNrIHN1cGVyYmxvY2sgMjIgLSBpbmNv
bnNpc3RlbnQgZmlsZXN5c3RlbSBnZW9tZXRyeSBpbmZvcm1hdGlvbgpwcmltYXJ5L3NlY29uZGFy
eSBzdXBlcmJsb2NrIDIyIGNvbmZsaWN0IC0gQUcgc3VwZXJibG9jayBnZW9tZXRyeSBpbmZvIGNv
bmZsaWN0cyB3aXRoIGZpbGVzeXN0ZW0gZ2VvbWV0cnkKemVyb2luZyB1bnVzZWQgcG9ydGlvbiBv
ZiBzZWNvbmRhcnkgc3VwZXJibG9jayAoQUcgIzIyKQoKUHJvZ3JhbSByZWNlaXZlZCBzaWduYWwg
U0lHU0VHViwgU2VnbWVudGF0aW9uIGZhdWx0LgpbU3dpdGNoaW5nIHRvIFRocmVhZCAweDdmZmZl
YjE0NzcwMCAoTFdQIDc3NDEpXQpfX21lbXNldF9zc2UyICgpIGF0IC4uL3N5c2RlcHMveDg2XzY0
L21lbXNldC5TOjg3Mwo4NzMgICAgICAgICAgICAgbW92ZHFhICV4bW0wLCglcmRpKQooZ2RiKSBi
dAojMCAgX19tZW1zZXRfc3NlMiAoKSBhdCAuLi9zeXNkZXBzL3g4Nl82NC9tZW1zZXQuUzo4NzMK
IzEgIDB4MDAwMDAwMDAwMDQwNDA3YiBpbiBzZWNvbmRhcnlfc2Jfd2FjayAobXA9MHg3ZmZmZmZm
ZmRmYzAsIHNidWY9MHg1NTNiMDFhNywgaT0yMiwgc2I9MHg3ZmZmYTAwMDA4YzApIGF0IGFnaGVh
ZGVyLmM6MzEzCiMyICB2ZXJpZnlfc2V0X2FnaGVhZGVyIChtcD0weDdmZmZmZmZmZGZjMCwgc2J1
Zj1zYnVmQGVudHJ5PTB4N2ZmZmEwMDAwYWQwLCBzYj1zYkBlbnRyeT0weDdmZmZhMDAwMDhjMCwg
YWdmPWFnZkBlbnRyeT0weDdmZmZhMDAwMWUwMCwgYWdpPWFnaUBlbnRyeT0weDdmZmZhMDAwMzAw
MCwgaT1pQGVudHJ5PTIyKSBhdCBhZ2hlYWRlci5jOjUyMwojMyAgMHgwMDAwMDAwMDAwNDI3YmVi
IGluIHNjYW5fYWcgKHdxPTxvcHRpbWl6ZWQgb3V0PiwgYWdubz0yMiwgYXJnPTB4NjhlYjkwKSBh
dCBzY2FuLmM6MTUyMwojNCAgMHgwMDAwMDAwMDAwNDJhMzZhIGluIHdvcmtlcl90aHJlYWQgKGFy
Zz0weDdmZmZmZmZmZGNkMCkgYXQgdGhyZWFkcy5jOjQ2CiM1ICAweDAwMDA3ZmZmZjc3YmFkZjMg
aW4gc3RhcnRfdGhyZWFkIChhcmc9MHg3ZmZmZWIxNDc3MDApIGF0IHB0aHJlYWRfY3JlYXRlLmM6
MzA4CiM2ICAweDAwMDA3ZmZmZjc0ZTgxYWQgaW4gY2xvbmUgKCkgYXQgLi4vc3lzZGVwcy91bml4
L3N5c3YvbGludXgveDg2XzY0L2Nsb25lLlM6MTEzCg==
------=_Part_428219_1941966493.1426083973345
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_428219_1941966493.1426083973345--
