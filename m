Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 195537F3F
	for <xfs@oss.sgi.com>; Sat, 15 Nov 2014 14:41:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05420304043
	for <xfs@oss.sgi.com>; Sat, 15 Nov 2014 12:41:42 -0800 (PST)
Received: from mail-ie0-f176.google.com (mail-ie0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	9Ek80MaPjsdQktC9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Nov 2014 12:41:41 -0800 (PST)
Received: by mail-ie0-f176.google.com with SMTP id rd18so19183311iec.7
	for <xfs@oss.sgi.com>; Sat, 15 Nov 2014 12:41:41 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 15 Nov 2014 15:41:39 -0500
Message-ID: <CAK9uKkcDnJzNyJBxb9jaONUHDwn9Z35c=ixa96pX=tc=ws93LA@mail.gmail.com>
Subject: Support overlayfs testing.
From: Li Mengyang <li.mengyang@stonybrook.edu>
Content-Type: multipart/mixed; boundary=001a113ff6aad1097f0507ebc5d2
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
To: xfs@oss.sgi.com
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>, miklos@szeredi.hu

--001a113ff6aad1097f0507ebc5d2
Content-Type: multipart/alternative; boundary=001a113ff6aad1097a0507ebc5d0

--001a113ff6aad1097a0507ebc5d0
Content-Type: text/plain; charset=UTF-8

Hi,
 Recently people are proposing overlayfs for inclusion into the mainline, I
found it could be helpful if xfstests supports overlayfs testing. Here is
the patch and example configuration file for that. Thank you.

-- 
Regards,
Li
--------------------------------------
Mengyang Li / Computer Science, SUNYSB

6315047325/ li.mengyang@stonybrook.edu

--001a113ff6aad1097a0507ebc5d0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div>=C2=A0Recently people are proposing overlayfs for =
inclusion into the mainline, I found it could be helpful if xfstests suppor=
ts overlayfs testing. Here is the patch and example configuration file for =
that. Thank you.<div><div><br></div>-- <br><div class=3D"gmail_signature"><=
div dir=3D"ltr"><div><div>Regards,</div><div>Li</div></div><div><font color=
=3D"#999999" face=3D"courier new, monospace"><span style=3D"font-size:10px;=
line-height:11px;font-weight:bold">--------------------------------------</=
span></font></div><div><font color=3D"#999999" face=3D"courier new, monospa=
ce"><span style=3D"font-size:10px;line-height:11px;font-weight:bold">Mengya=
ng Li</span><span style=3D"font-size:10px;line-height:11px">=C2=A0</span><s=
pan style=3D"font-size:10px;line-height:11px">/</span><span style=3D"font-s=
ize:10px;line-height:11px">=C2=A0</span><span style=3D"font-size:10px;line-=
height:11px">Computer Science, SUNYSB</span><br></font></div><div><p style=
=3D"margin:0px 0px 10px;font-size:10px;line-height:11px"><font face=3D"cour=
ier new, monospace"><span style=3D"color:rgb(153,153,153)">6315047325</span=
><span style=3D"color:rgb(153,153,153)">/</span><font color=3D"#999999">=C2=
=A0</font><a href=3D"mailto:li.mengyang@stonybrook.edu" style=3D"background=
-color:transparent;text-decoration:none" target=3D"_blank"><font color=3D"#=
999999">li.mengyang@stonybrook.edu</font></a></font></p></div></div></div>
</div></div></div>

--001a113ff6aad1097a0507ebc5d0--

--001a113ff6aad1097f0507ebc5d2
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-overlayfs-Add-support-for-overlayfs.patch"
Content-Disposition: attachment;
	filename="0001-overlayfs-Add-support-for-overlayfs.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2jfto5u0

RnJvbSA0ZWZhZmUwZjQzMTFiYzkxNDBhNjY3MzcwNTc2ZmRlMjRiODRmZWNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZW5neWFuZyBMaSA8bGkubWVuZ3lhbmdAc3Rvbnlicm9vay5l
ZHU+CkRhdGU6IFNhdCwgMTUgTm92IDIwMTQgMTA6NTM6NDEgLTA1MDAKU3ViamVjdDogW1BBVENI
IDEvMV0gb3ZlcmxheWZzOiBBZGQgc3VwcG9ydCBmb3Igb3ZlcmxheWZzCgoKU2lnbmVkLW9mZi1i
eTogTWVuZ3lhbmcgTGkgPGxpLm1lbmd5YW5nQHN0b255YnJvb2suZWR1PgpTaWduZWQtb2ZmLWJ5
OiBFcmV6IFphZG9rIDxlemtAY3Muc3VueXNiLmVkdT4KLS0tCiBjb21tb24vcmMgICAgICAgICAg
ICAgICAgfCAgIDIxICsrKysrKysrKysrKysrKysrKysrKwogY29uZmlncy9vdmVybGF5ZnMuY29u
ZmlnIHwgICAxNiArKysrKysrKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDM3IGluc2VydGlv
bnMoKykKIGNyZWF0ZSBtb2RlIDEwMDY0NCBjb25maWdzL292ZXJsYXlmcy5jb25maWcKCmRpZmYg
LS1naXQgYS9jb21tb24vcmMgYi9jb21tb24vcmMKaW5kZXggZDVlM2FmZi4uZWZhMGZhYyAxMDA2
NDQKLS0tIGEvY29tbW9uL3JjCisrKyBiL2NvbW1vbi9yYwpAQCAtMTEzMyw2ICsxMTMzLDI0IEBA
IF9yZXF1aXJlX3Rlc3QoKQogCQkgICAgX25vdHJ1biAidGhpcyB0ZXN0IHJlcXVpcmVzIGEgdmFs
aWQgXCRURVNUX0RJUiBhbmQgdW5pcXVlICRURVNUX0RFViIKIAkJZmkKIAkJOzsKKwlvdmVybGF5
ZnMpCisJCWlmIFsgLXogIiRPVkxGU19MT1dFUkRJUiIgLW8gISAtZCAiJE9WTEZTX0xPV0VSRElS
IiBdOworCQl0aGVuCisJCSAgICBfbm90cnVuICJ0aGlzIHRlc3QgcmVxdWlyZXMgYSB2YWxpZCBc
JE9WTEZTX0xPV0VSRElSIgorCQlmaQorCQlpZiBbIC16ICIkT1ZMRlNfVVBQRVJESVIiIC1vICEg
LWQgIiRPVkxGU19VUFBFUkRJUiIgXTsKKwkJdGhlbgorCQkgICAgX25vdHJ1biAidGhpcyB0ZXN0
IHJlcXVpcmVzIGEgdmFsaWQgXCRPVkxGU19VUFBFUkRJUiIKKwkJZmkKKwkJaWYgWyAteiAiJE9W
TEZTX1dPUktESVIiIC1vICEgLWQgIiRPVkxGU19XT1JLRElSIiBdOworCQl0aGVuCisJCSAgICBf
bm90cnVuICJ0aGlzIHRlc3QgcmVxdWlyZXMgYSB2YWxpZCBcJE9WTEZTX1dPUktESVIiCisJCWZp
CisJCWlmIFsgLXogIiRURVNUX0RJUiIgLW8gISAtZCAiJFRFU1RfRElSIiBdOworCQl0aGVuCisJ
CSAgICBfbm90cnVuICJ0aGlzIHRlc3QgcmVxdWlyZXMgYSB2YWxpZCBcJFRFU1RfRElSIgorCQlm
aQorCQk7OwogCSopCiAJCSBpZiBbIC16ICIkVEVTVF9ERVYiIC1vICJgX2lzX2Jsb2NrX2RldiAk
VEVTVF9ERVZgIiA9ICIiIF0KIAkJIHRoZW4KQEAgLTE5NDcsNiArMTk2NSw5IEBAIF9jaGVja190
ZXN0X2ZzKCkKICAgICB0bXBmcykKIAkjIG5vIHdheSB0byBjaGVjayBjb25zaXN0ZW5jeSBmb3Ig
dG1wZnMKIAk7OworICAgIG92ZXJsYXlmcykKKwkjIG5vIHdheSB0byBjaGVjayBjb25zaXN0ZW5j
eSBmb3Igb3ZlcmxheWZzCisJOzsKICAgICAqKQogCV9jaGVja19nZW5lcmljX2ZpbGVzeXN0ZW0g
JFRFU1RfREVWCiAJOzsKZGlmZiAtLWdpdCBhL2NvbmZpZ3Mvb3ZlcmxheWZzLmNvbmZpZyBiL2Nv
bmZpZ3Mvb3ZlcmxheWZzLmNvbmZpZwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAw
Li40MmVmOTc1Ci0tLSAvZGV2L251bGwKKysrIGIvY29uZmlncy9vdmVybGF5ZnMuY29uZmlnCkBA
IC0wLDAgKzEsMTYgQEAKKyMgRXhhbXBsZSBjb25maWcgZm9yIG92ZXJsYXlmcworIyBzb3VyY2Ug
bWUgYmVmb3JlIHJ1biAuL2NoZWNrCisKK2V4cG9ydCBPVkxGU19MT1dFUkRJUj0vbW50L292bGxv
d2VyCitleHBvcnQgT1ZMRlNfVVBQRVJESVI9L21udC9vdmx1cHBlcgorZXhwb3J0IE9WTEZTX1dP
UktESVI9L21udC93b3JrZGlyCisKK2V4cG9ydCBURVNUX0RJUj0vbW50L21lcmdlZAorZXhwb3J0
IFRFU1RfREVWPS9kZXYvbG9vcDAKKworZXhwb3J0IFRFU1RfRlNfTU9VTlRfT1BUUz0tb2xvd2Vy
ZGlyPSRPVkxGU19MT1dFUkRJUixcCit1cHBlcmRpcj0kT1ZMRlNfVVBQRVJESVIsd29ya2Rpcj0k
T1ZMRlNfV09SS0RJUgorCit1bnNldCBTQ1JBVENIX0RFVgordW5zZXQgU0NSQVRDSF9NTlQKK2V4
cG9ydCBGU1RZUD1vdmVybGF5ZnMKLS0gCjEuNy45LjUKCg==
--001a113ff6aad1097f0507ebc5d2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--001a113ff6aad1097f0507ebc5d2--
