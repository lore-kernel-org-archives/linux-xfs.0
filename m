Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n12KHCQf008581 for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 14:17:12 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE00418A2EDF
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2009 12:16:31 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id SvrK66rLANDyNYRv for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2009 12:16:31 -0800 (PST)
Message-ID: <4987548A.1070809@sandeen.net>
Date: Mon, 02 Feb 2009 14:16:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Fix *FLAGS passing and dependencies.
References: <1233565776-563-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1233565776-563-1-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

QXJrYWRpdXN6IE1pxZtraWV3aWN6IHdyb3RlOgo+IFBhc3MgKkZMQUdTIGluIHNvbWUgdGFyZ2V0
cy4KPiAKPiBEcm9wIExJQkhBTkRMRSwgTElCQVRUUiBhbmQgTElCQUNMIGZyb20gZGVwcyBzaW5j
ZSB0aGVyZSBhcmUgaW4gZm9ybQo+ICItbGxpYnJhcnkiLgoKdWdoLCB3ZWlyZC4KCj4gCj4gU2ln
bmVkLW9mZi1ieTogQXJrYWRpdXN6IE1pw4XigLpraWV3aWN6IDxhcmVrbUBtYXZlbi5wbD4KCkxv
b2tzIGZpbmUgdG8gbWUuICBJJ2xsIG1lcmdlIGl0IHRvIHRoZSBrZXJuZWwub3JnIHJlcG8uCgot
RXJpYwoKPiAtLS0KPiAgc3JjL01ha2VmaWxlIHwgICAxMiArKysrKystLS0tLS0KPiAgMSBmaWxl
cyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdp
dCBhL3NyYy9NYWtlZmlsZSBiL3NyYy9NYWtlZmlsZQo+IGluZGV4IGFkNGMyMDQuLjYzNGUxYjMg
MTAwNjQ0Cj4gLS0tIGEvc3JjL01ha2VmaWxlCj4gKysrIGIvc3JjL01ha2VmaWxlCj4gQEAgLTU4
LDEwICs1OCwxMCBAQCBnZW5oYXNobmFtZXM6IGdlbmhhc2huYW1lcy5vCj4gIG5hbWV0ZXN0OiBu
YW1ldGVzdC5vICQoTElCVEVTVCkKPiAgCSQoTElOS1RFU1QpICQoTElCVEVTVCkgJChMRExJQlMp
Cj4gIAo+IC1ic3RhdDogYnN0YXQubyAkKExJQkhBTkRMRSkKPiArYnN0YXQ6IGJzdGF0Lm8KPiAg
CSQoTElOS1RFU1QpICQoTElCSEFORExFKSAkKExETElCUykKPiAgCj4gLXRfaW1tdXRhYmxlOiB0
X2ltbXV0YWJsZS5vICQoTElCSEFORExFKSAkKExJQkFDTCkKPiArdF9pbW11dGFibGU6IHRfaW1t
dXRhYmxlLm8KPiAgCSQoTElOS1RFU1QpICQoTElCQUNMKSAkKExJQkhBTkRMRSkgJChMRExJQlMp
Cj4gIAo+ICBsb2dnZW46CWxvZ2dlbi5vCj4gQEAgLTgyLDE3ICs4MiwxNyBAQCBtdWx0aV9vcGVu
X3VubGluazogbXVsdGlfb3Blbl91bmxpbmsubwo+ICAjc2NhbGVyZWFkOiBzY2FsZXJlYWQubyAk
KExETElCUykKPiAgIwkkKExJTktURVNUKQo+ICAKPiAtYWNsX2dldDogYWNsX2dldC5vICQoTElC
QUNMKSAkKExJQkFUVFIpCj4gK2FjbF9nZXQ6IGFjbF9nZXQubwo+ICAJJChMSU5LVEVTVCkgJChM
SUJBQ0wpICQoTElCQVRUUikgJChMRExJQlMpCj4gIAo+IC1kbWlwZXJmOiBkbWlwZXJmLm8gJChM
SUJBVFRSKQo+ICtkbWlwZXJmOiBkbWlwZXJmLm8KPiAgCSQoTElOS1RFU1QpICQoTElCQVRUUikg
JChMRExJQlMpCj4gIAo+ICBwcmVhbGxvX3J3X3BhdHRlcm5fcmVhZGVyOgo+IC0JJChDQykgLURS
RUFEIGlvcGF0LmMgLW8gcHJlYWxsb19yd19wYXR0ZXJuX3JlYWRlcgo+ICsJJChDQykgJChHQ0ZM
QUdTKSAkKExERkxBR1MpIC1EUkVBRCBpb3BhdC5jIC1vIHByZWFsbG9fcndfcGF0dGVybl9yZWFk
ZXIKPiAgCj4gIHByZWFsbG9fcndfcGF0dGVybl93cml0ZXI6Cj4gLQkkKENDKSAtRFdSSVRFIGlv
cGF0LmMgLW8gcHJlYWxsb19yd19wYXR0ZXJuX3dyaXRlcgo+ICsJJChDQykgJChHQ0ZMQUdTKSAk
KExERkxBR1MpIC1EV1JJVEUgaW9wYXQuYyAtbyBwcmVhbGxvX3J3X3BhdHRlcm5fd3JpdGVyCj4g
IAo+ICBmdHJ1bmM6IGZ0cnVuYy5vCj4gIAkkKExJTktURVNUKQo+IAo+IAo+IC0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQo+IAo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cj4geGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
