Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DFp6wA068587 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 10:51:06 -0500
Received: from mail-yi0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F9361526247
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:55:44 -0700 (PDT)
Received: from mail-yi0-f53.google.com (mail-yi0-f53.google.com
	[209.85.218.53]) by cuda.sgi.com with ESMTP id FRGEkRRok1ajsM6A
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:55:44 -0700 (PDT)
Received: by yie21 with SMTP id 21so699023yie.26
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:51:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109131142010.7113@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan>
	<CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com>
	<1315886706.2556.11.camel@edumazet-laptop>
	<alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
	<CAMaF-rN-qeXBDoc9=7kwu40Wj8=G8YuPKWXPRhOuhdYX_VO34w@mail.gmail.com>
	<alpine.DEB.2.02.1109131142010.7113@p34.internal.lan>
Date: Tue, 13 Sep 2011 10:51:03 -0500
Message-ID: <CAMaF-rMxTWRAO7WRdYoEM57k66MC6Vuwk1mcfgCgMO6Z+KBvzQ@mail.gmail.com>
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
From: Jon Mason <mason@myri.com>
Content-Type: multipart/mixed; boundary=001636ef0a156a8f1104acd49c0a
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, NetDEV list <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jesse Brandeburg <jesse.brandeburg@gmail.com>, Alan Piszcz <ap@solarrain.com>

--001636ef0a156a8f1104acd49c0a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 13, 2011 at 10:42 AM, Justin Piszcz <jpiszcz@lucidpixels.com> w=
rote:
>
>
> On Tue, 13 Sep 2011, Jon Mason wrote:
>
>> On Tue, Sep 13, 2011 at 9:54 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
>> wrote:
>>>
>>>
>>> On Tue, 13 Sep 2011, Eric Dumazet wrote:
>>>
>>>> Please Justin make sure you pulled commit
>>>> commit ed2888e906b56769b4ffabb9c577190438aa68b8
>>>> Author: Jon Mason <mason@myri.com>
>>>> Date: =A0 Thu Sep 8 16:41:18 2011 -0500
>>>>
>>>> =A0 PCI: Remove MRRS modification from MPS setting code
>>>>
>>>> =A0 Modifying the Maximum Read Request Size to 0 (value of 128Bytes) h=
as
>>>> =A0 massive negative ramifications on some devices. =A0Without knowing=
 which
>>>> =A0 devices have this issue, do not modify from the default value when
>>>> =A0 walking the PCI-E bus in pcie_bus_safe mode. =A0Also, make pcie_bu=
s_safe
>>>> =A0 the default procedure.
>>>>
>>>> =A0 Tested-by: Sven Schnelle <svens@stackframe.org>
>>>> =A0 Tested-by: Simon Kirby <sim@hostway.ca>
>>>> =A0 Tested-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>> =A0 Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
>>>> =A0 Reported-and-tested-by: Niels Ole Salscheider
>>>> <niels_ole@salscheider-online.
>>>> =A0 References: https://bugzilla.kernel.org/show_bug.cgi?id=3D42162
>>>> =A0 Signed-off-by: Jon Mason <mason@myri.com>
>>>> =A0 Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>>>> =A0 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>>
>>> Hello,
>>>
>>> I found this commit here:
>>> http://permalink.gmane.org/gmane.linux.kernel.pci/11700
>>
>> This is an early version of the patch. =A0This is the patch that you wan=
t:
>>
>> https://github.com/torvalds/linux/commit/ed2888e906b56769b4ffabb9c577190=
438aa68b8
>>
>> It appears that this patch didn't make it to lkml or linux-pci list
>> due to kernel.org DNS being down when it was sent.
>>
>> Thanks,
>> Jon
>
> I need to learn how to use git at some point, can you please provide plai=
n
> text patches so I can apply them and reboot?
>
> Justin.

I've attached the 2 patches I asked Linus to include into 3.1-rc6.
Let me know if there are any issues.

Thanks,
Jon

--001636ef0a156a8f1104acd49c0a
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-Fix-pointer-dereference-before-call-to-pcie_bus_conf.patch"
Content-Disposition: attachment;
	filename="0001-Fix-pointer-dereference-before-call-to-pcie_bus_conf.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsj21mz70

RnJvbSBjZjgyMmFlZDk5ZmQ4ODUxZDgyYWU1ZjJkZjExYzI5Yjc5ZTMxNmM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBJeWVyIDxzaHlhbS5peWVyLnRAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDMxIEF1ZyAyMDExIDEyOjIxOjQyIC0wNDAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IEZpeCBwb2ludGVyIGRlcmVmZXJlbmNlIGJlZm9yZSBjYWxsIHRvCiBwY2llX2J1c19jb25maWd1
cmVfc2V0dGluZ3MKClRoZXJlIGlzIGEgcG90ZW50aWFsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5j
ZSBpbiBjYWxscyB0bwpwY2llX2J1c19jb25maWd1cmVfc2V0dGluZ3MgZHVlIHRvIGF0dGVtcHRz
IHRvIGFjY2VzcyBwY2lfYnVzIHNlbGYKdmFyaWFibGVzIHdoZW4gdGhlIHNlbGYgcG9pbnRlciBp
cyBOVUxMLiAgVG8gY29ycmVjdCB0aGlzLCB2ZXJpZnkgdGhhdAp0aGUgc2VsZiBwb2ludGVyIGlu
IHBjaV9idXMgaXMgbm9uLU5VTEwgYmVmb3JlIGRlcmVmZXJlbmNpbmcgaXQuCgpSZXBvcnRlZC1i
eTogU3RhbmlzbGF3IEdydXN6a2EgPHNncnVzemthQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6
IFNoeWFtIEl5ZXIgPHNoeWFtX2l5ZXJAZGVsbC5jb20+ClNpZ25lZC1vZmYtYnk6IEpvbiBNYXNv
biA8bWFzb25AbXlyaS5jb20+Ci0tLQogYXJjaC94ODYvcGNpL2FjcGkuYyAgICAgICAgICAgICAg
fCAgICA5ICsrKysrKystLQogZHJpdmVycy9wY2kvaG90cGx1Zy9wY2locF9zbG90LmMgfCAgICA0
ICsrKy0KIGRyaXZlcnMvcGNpL3Byb2JlLmMgICAgICAgICAgICAgIHwgICAgMyAtLS0KIDMgZmls
ZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9wY2kvYWNwaS5jIGIvYXJjaC94ODYvcGNpL2FjcGkuYwppbmRleCBjOTUzMzAy
Li4wMzlkOTEzIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9wY2kvYWNwaS5jCisrKyBiL2FyY2gveDg2
L3BjaS9hY3BpLmMKQEAgLTM2NSw4ICszNjUsMTMgQEAgc3RydWN0IHBjaV9idXMgKiBfX2Rldmlu
aXQgcGNpX2FjcGlfc2Nhbl9yb290KHN0cnVjdCBhY3BpX3BjaV9yb290ICpyb290KQogCSAqLwog
CWlmIChidXMpIHsKIAkJc3RydWN0IHBjaV9idXMgKmNoaWxkOwotCQlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KGNoaWxkLCAmYnVzLT5jaGlsZHJlbiwgbm9kZSkKLQkJCXBjaWVfYnVzX2NvbmZpZ3VyZV9z
ZXR0aW5ncyhjaGlsZCwgY2hpbGQtPnNlbGYtPnBjaWVfbXBzcyk7CisJCWxpc3RfZm9yX2VhY2hf
ZW50cnkoY2hpbGQsICZidXMtPmNoaWxkcmVuLCBub2RlKSB7CisJCQlzdHJ1Y3QgcGNpX2RldiAq
c2VsZiA9IGNoaWxkLT5zZWxmOworCQkJaWYgKCFzZWxmKQorCQkJCWNvbnRpbnVlOworCisJCQlw
Y2llX2J1c19jb25maWd1cmVfc2V0dGluZ3MoY2hpbGQsIHNlbGYtPnBjaWVfbXBzcyk7CisJCX0K
IAl9CiAKIAlpZiAoIWJ1cykKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2hvdHBsdWcvcGNpaHBf
c2xvdC5jIGIvZHJpdmVycy9wY2kvaG90cGx1Zy9wY2locF9zbG90LmMKaW5kZXggNzUzYjIxYS4u
M2ZmZDljMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvaG90cGx1Zy9wY2locF9zbG90LmMKKysr
IGIvZHJpdmVycy9wY2kvaG90cGx1Zy9wY2locF9zbG90LmMKQEAgLTE2OSw3ICsxNjksOSBAQCB2
b2lkIHBjaV9jb25maWd1cmVfc2xvdChzdHJ1Y3QgcGNpX2RldiAqZGV2KQogCQkJKGRldi0+Y2xh
c3MgPj4gOCkgPT0gUENJX0NMQVNTX0JSSURHRV9QQ0kpKSkKIAkJcmV0dXJuOwogCi0JcGNpZV9i
dXNfY29uZmlndXJlX3NldHRpbmdzKGRldi0+YnVzLCBkZXYtPmJ1cy0+c2VsZi0+cGNpZV9tcHNz
KTsKKwlpZiAoZGV2LT5idXMgJiYgZGV2LT5idXMtPnNlbGYpCisJCXBjaWVfYnVzX2NvbmZpZ3Vy
ZV9zZXR0aW5ncyhkZXYtPmJ1cywKKwkJCQkJICAgIGRldi0+YnVzLT5zZWxmLT5wY2llX21wc3Mp
OwogCiAJbWVtc2V0KCZocHAsIDAsIHNpemVvZihocHApKTsKIAlyZXQgPSBwY2lfZ2V0X2hwX3Bh
cmFtcyhkZXYsICZocHApOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcHJvYmUuYyBiL2RyaXZl
cnMvcGNpL3Byb2JlLmMKaW5kZXggODQ3MzcyNy4uMDgyMGZjMSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9wY2kvcHJvYmUuYworKysgYi9kcml2ZXJzL3BjaS9wcm9iZS5jCkBAIC0xNDU2LDkgKzE0NTYs
NiBAQCB2b2lkIHBjaWVfYnVzX2NvbmZpZ3VyZV9zZXR0aW5ncyhzdHJ1Y3QgcGNpX2J1cyAqYnVz
LCB1OCBtcHNzKQogewogCXU4IHNtcHNzID0gbXBzczsKIAotCWlmICghYnVzLT5zZWxmKQotCQly
ZXR1cm47Ci0KIAlpZiAoIXBjaV9pc19wY2llKGJ1cy0+c2VsZikpCiAJCXJldHVybjsKIAotLSAK
MS43LjYKCg==
--001636ef0a156a8f1104acd49c0a
Content-Type: text/x-patch; charset=US-ASCII;
	name="0002-PCI-Remove-MRRS-modification-from-MPS-setting-code.patch"
Content-Disposition: attachment;
	filename="0002-PCI-Remove-MRRS-modification-from-MPS-setting-code.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsj21oi01

RnJvbSA3NGQ4MTIzNWY4ZTRiZDYwODU5ZDUzOWEyN2U1MWQzYTA5ZDE4M2NmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb24gTWFzb24gPG1hc29uQG15cmkuY29tPgpEYXRlOiBUaHUs
IDggU2VwIDIwMTEgMTI6NTk6MDAgLTA1MDAKU3ViamVjdDogW1BBVENIIDIvMl0gUENJOiBSZW1v
dmUgTVJSUyBtb2RpZmljYXRpb24gZnJvbSBNUFMgc2V0dGluZyBjb2RlCgpNb2RpZnlpbmcgdGhl
IE1heGltdW0gUmVhZCBSZXF1ZXN0IFNpemUgdG8gMCAodmFsdWUgb2YgMTI4Qnl0ZXMpIGhhcwpt
YXNzaXZlIG5lZ2F0aXZlIHJhbWlmaWNhdGlvbnMgb24gc29tZSBkZXZpY2VzLiAgV2l0aG91dCBr
bm93aW5nIHdoaWNoCmRldmljZXMgaGF2ZSB0aGlzIGlzc3VlLCBkbyBub3QgbW9kaWZ5IGZyb20g
dGhlIGRlZmF1bHQgdmFsdWUgd2hlbgp3YWxraW5nIHRoZSBQQ0ktRSBidXMgaW4gcGNpZV9idXNf
c2FmZSBtb2RlLiAgQWxzbywgbWFrZSBwY2llX2J1c19zYWZlCnRoZSBkZWZhdWx0IHByb2NlZHVy
ZS4KClRlc3RlZC1ieTogU3ZlbiBTY2huZWxsZSA8c3ZlbnNAc3RhY2tmcmFtZS5vcmc+ClRlc3Rl
ZC1ieTogU2ltb24gS2lyYnkgPHNpbUBob3N0d2F5LmNhPgpUZXN0ZWQtYnk6IFN0ZXBoZW4gTS4g
Q2FtZXJvbiA8c2NhbWVyb25AYmVhcmRvZy5jY2UuaHAuY29tPgpSZXBvcnRlZC1hbmQtdGVzdGVk
LWJ5OiBFcmljIER1bWF6ZXQgPGVyaWMuZHVtYXpldEBnbWFpbC5jb20+ClJlcG9ydGVkLWFuZC10
ZXN0ZWQtYnk6IE5pZWxzIE9sZSBTYWxzY2hlaWRlciA8bmllbHNfb2xlQHNhbHNjaGVpZGVyLW9u
bGluZS5kZT4KUmVmZXJlbmNlczogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVn
LmNnaT9pZD00MjE2MgpTaWduZWQtb2ZmLWJ5OiBKb24gTWFzb24gPG1hc29uQG15cmkuY29tPgot
LS0KIGRyaXZlcnMvcGNpL3BjaS5jICAgfCAgICAyICstCiBkcml2ZXJzL3BjaS9wcm9iZS5jIHwg
ICA0MSArKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBj
aGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3BjaS9wY2kuYyBiL2RyaXZlcnMvcGNpL3BjaS5jCmluZGV4IDBjZTY3NDIuLjRlODRm
ZDQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL3BjaS5jCisrKyBiL2RyaXZlcnMvcGNpL3BjaS5j
CkBAIC03Nyw3ICs3Nyw3IEBAIHVuc2lnbmVkIGxvbmcgcGNpX2NhcmRidXNfbWVtX3NpemUgPSBE
RUZBVUxUX0NBUkRCVVNfTUVNX1NJWkU7CiB1bnNpZ25lZCBsb25nIHBjaV9ob3RwbHVnX2lvX3Np
emUgID0gREVGQVVMVF9IT1RQTFVHX0lPX1NJWkU7CiB1bnNpZ25lZCBsb25nIHBjaV9ob3RwbHVn
X21lbV9zaXplID0gREVGQVVMVF9IT1RQTFVHX01FTV9TSVpFOwogCi1lbnVtIHBjaWVfYnVzX2Nv
bmZpZ190eXBlcyBwY2llX2J1c19jb25maWcgPSBQQ0lFX0JVU19QRVJGT1JNQU5DRTsKK2VudW0g
cGNpZV9idXNfY29uZmlnX3R5cGVzIHBjaWVfYnVzX2NvbmZpZyA9IFBDSUVfQlVTX1NBRkU7CiAK
IC8qCiAgKiBUaGUgZGVmYXVsdCBDTFMgaXMgdXNlZCBpZiBhcmNoIGRpZG4ndCBzZXQgQ0xTIGV4
cGxpY2l0bHkgYW5kIG5vdApkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcHJvYmUuYyBiL2RyaXZl
cnMvcGNpL3Byb2JlLmMKaW5kZXggMDgyMGZjMS4uYjExODdmZiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9wY2kvcHJvYmUuYworKysgYi9kcml2ZXJzL3BjaS9wcm9iZS5jCkBAIC0xMzk2LDM0ICsxMzk2
LDM3IEBAIHN0YXRpYyB2b2lkIHBjaWVfd3JpdGVfbXBzKHN0cnVjdCBwY2lfZGV2ICpkZXYsIGlu
dCBtcHMpCiAKIHN0YXRpYyB2b2lkIHBjaWVfd3JpdGVfbXJycyhzdHJ1Y3QgcGNpX2RldiAqZGV2
LCBpbnQgbXBzKQogewotCWludCByYywgbXJyczsKKwlpbnQgcmMsIG1ycnMsIGRldl9tcHNzOwog
Ci0JaWYgKHBjaWVfYnVzX2NvbmZpZyA9PSBQQ0lFX0JVU19QRVJGT1JNQU5DRSkgewotCQlpbnQg
ZGV2X21wc3MgPSAxMjggPDwgZGV2LT5wY2llX21wc3M7CisJLyogSW4gdGhlICJzYWZlIiBjYXNl
LCBkbyBub3QgY29uZmlndXJlIHRoZSBNUlJTLiAgVGhlcmUgYXBwZWFyIHRvIGJlCisJICogaXNz
dWVzIHdpdGggc2V0dGluZyBNUlJTIHRvIDAgb24gYSBudW1iZXIgb2YgZGV2aWNlcy4KKwkgKi8K
IAotCQkvKiBGb3IgTWF4IHBlcmZvcm1hbmNlLCB0aGUgTVJSUyBtdXN0IGJlIHNldCB0byB0aGUg
bGFyZ2VzdAotCQkgKiBzdXBwb3J0ZWQgdmFsdWUuICBIb3dldmVyLCBpdCBjYW5ub3QgYmUgY29u
ZmlndXJlZCBsYXJnZXIKLQkJICogdGhhbiB0aGUgTVBTIHRoZSBkZXZpY2Ugb3IgdGhlIGJ1cyBj
YW4gc3VwcG9ydC4gIFRoaXMgYXNzdW1lcwotCQkgKiB0aGF0IHRoZSBsYXJnZXN0IE1SUlMgYXZh
aWxhYmxlIG9uIHRoZSBkZXZpY2UgY2Fubm90IGJlCi0JCSAqIHNtYWxsZXIgdGhhbiB0aGUgZGV2
aWNlIE1QU1MuCi0JCSAqLwotCQltcnJzID0gbXBzIDwgZGV2X21wc3MgPyBtcHMgOiBkZXZfbXBz
czsKLQl9IGVsc2UKLQkJLyogSW4gdGhlICJzYWZlIiBjYXNlLCBjb25maWd1cmUgdGhlIE1SUlMg
Zm9yIGZhaXJuZXNzIG9uIHRoZQotCQkgKiBidXMgYnkgbWFraW5nIGFsbCBkZXZpY2VzIGhhdmUg
dGhlIHNhbWUgc2l6ZQotCQkgKi8KLQkJbXJycyA9IG1wczsKKwlpZiAocGNpZV9idXNfY29uZmln
ICE9IFBDSUVfQlVTX1BFUkZPUk1BTkNFKQorCQlyZXR1cm47CisKKwlkZXZfbXBzcyA9IDEyOCA8
PCBkZXYtPnBjaWVfbXBzczsKIAorCS8qIEZvciBNYXggcGVyZm9ybWFuY2UsIHRoZSBNUlJTIG11
c3QgYmUgc2V0IHRvIHRoZSBsYXJnZXN0IHN1cHBvcnRlZAorCSAqIHZhbHVlLiAgSG93ZXZlciwg
aXQgY2Fubm90IGJlIGNvbmZpZ3VyZWQgbGFyZ2VyIHRoYW4gdGhlIE1QUyB0aGUKKwkgKiBkZXZp
Y2Ugb3IgdGhlIGJ1cyBjYW4gc3VwcG9ydC4gIFRoaXMgYXNzdW1lcyB0aGF0IHRoZSBsYXJnZXN0
IE1SUlMKKwkgKiBhdmFpbGFibGUgb24gdGhlIGRldmljZSBjYW5ub3QgYmUgc21hbGxlciB0aGFu
IHRoZSBkZXZpY2UgTVBTUy4KKwkgKi8KKwltcnJzID0gbWluKG1wcywgZGV2X21wc3MpOwogCiAJ
LyogTVJSUyBpcyBhIFIvVyByZWdpc3Rlci4gIEludmFsaWQgdmFsdWVzIGNhbiBiZSB3cml0dGVu
LCBidXQgYQotCSAqIHN1YnNpcXVlbnQgcmVhZCB3aWxsIHZlcmlmeSBpZiB0aGUgdmFsdWUgaXMg
YWNjZXB0YWJsZSBvciBub3QuCisJICogc3Vic2VxdWVudCByZWFkIHdpbGwgdmVyaWZ5IGlmIHRo
ZSB2YWx1ZSBpcyBhY2NlcHRhYmxlIG9yIG5vdC4KIAkgKiBJZiB0aGUgTVJSUyB2YWx1ZSBwcm92
aWRlZCBpcyBub3QgYWNjZXB0YWJsZSAoZS5nLiwgdG9vIGxhcmdlKSwKIAkgKiBzaHJpbmsgdGhl
IHZhbHVlIHVudGlsIGl0IGlzIGFjY2VwdGFibGUgdG8gdGhlIEhXLgogIAkgKi8KIAl3aGlsZSAo
bXJycyAhPSBwY2llX2dldF9yZWFkcnEoZGV2KSAmJiBtcnJzID49IDEyOCkgeworCQlkZXZfd2Fy
bigmZGV2LT5kZXYsICJBdHRlbXB0aW5nIHRvIG1vZGlmeSB0aGUgUENJLUUgTVJSUyB2YWx1ZSIK
KwkJCSAiIHRvICVkLiAgSWYgYW55IGlzc3VlcyBhcmUgZW5jb3VudGVyZWQsIHBsZWFzZSB0cnkg
IgorCQkJICJydW5uaW5nIHdpdGggcGNpPXBjaWVfYnVzX3NhZmVcbiIsIG1ycnMpOwogCQlyYyA9
IHBjaWVfc2V0X3JlYWRycShkZXYsIG1ycnMpOwogCQlpZiAocmMpCi0JCQlkZXZfZXJyKCZkZXYt
PmRldiwgIkZhaWxlZCBhdHRlbXB0aW5nIHRvIHNldCB0aGUgTVJSU1xuIik7CisJCQlkZXZfZXJy
KCZkZXYtPmRldiwKKwkJCQkiRmFpbGVkIGF0dGVtcHRpbmcgdG8gc2V0IHRoZSBNUlJTXG4iKTsK
IAogCQltcnJzIC89IDI7CiAJfQpAQCAtMTQzNiwxMyArMTQzOSwxMyBAQCBzdGF0aWMgaW50IHBj
aWVfYnVzX2NvbmZpZ3VyZV9zZXQoc3RydWN0IHBjaV9kZXYgKmRldiwgdm9pZCAqZGF0YSkKIAlp
ZiAoIXBjaV9pc19wY2llKGRldikpCiAJCXJldHVybiAwOwogCi0JZGV2X2luZm8oJmRldi0+ZGV2
LCAiRGV2IE1QUyAlZCBNUFNTICVkIE1SUlMgJWRcbiIsCisJZGV2X2RiZygmZGV2LT5kZXYsICJE
ZXYgTVBTICVkIE1QU1MgJWQgTVJSUyAlZFxuIiwKIAkJIHBjaWVfZ2V0X21wcyhkZXYpLCAxMjg8
PGRldi0+cGNpZV9tcHNzLCBwY2llX2dldF9yZWFkcnEoZGV2KSk7CiAKIAlwY2llX3dyaXRlX21w
cyhkZXYsIG1wcyk7CiAJcGNpZV93cml0ZV9tcnJzKGRldiwgbXBzKTsKIAotCWRldl9pbmZvKCZk
ZXYtPmRldiwgIkRldiBNUFMgJWQgTVBTUyAlZCBNUlJTICVkXG4iLAorCWRldl9kYmcoJmRldi0+
ZGV2LCAiRGV2IE1QUyAlZCBNUFNTICVkIE1SUlMgJWRcbiIsCiAJCSBwY2llX2dldF9tcHMoZGV2
KSwgMTI4PDxkZXYtPnBjaWVfbXBzcywgcGNpZV9nZXRfcmVhZHJxKGRldikpOwogCiAJcmV0dXJu
IDA7Ci0tIAoxLjcuNgoK
--001636ef0a156a8f1104acd49c0a
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--001636ef0a156a8f1104acd49c0a--
