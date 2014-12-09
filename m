Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D6CD7F3F
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 05:46:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AA148F8035
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 03:46:51 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id 57GDuOIhuIsOG3QV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Dec 2014 03:46:48 -0800 (PST)
Date: Tue, 9 Dec 2014 12:46:50 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Slow dir / Performance.
Message-ID: <20141209124650.3b0e3029@harpe.intellique.com>
In-Reply-To: <5486B222.4080404@sharper.nl>
References: <5486B222.4080404@sharper.nl>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Stefan Bottelier | Sharper.nl" <stefan@sharper.nl>
Cc: xfs@oss.sgi.com

TGUgVHVlLCAwOSBEZWMgMjAxNCAwOToyNjoxMCArMDEwMAoiU3RlZmFuIEJvdHRlbGllciB8IFNo
YXJwZXIubmwiIDxzdGVmYW5Ac2hhcnBlci5ubD4gw6ljcml2YWl0OgoKPiBCdXQgd2hlbiB3ZSBs
b2dnaW5nIG9uIHRoZSBzZXJ2ZXIsIHRoZSBmaXJzdCB0aW1lIHdlIGRvIGEgZGlyIGNvbW1hbmQK
PiBvbiB0aGUgaG9tZSBkaXIsIGl0cyB0YWtlIGEgbG9uZyB0aW1lIHdoZW4gd2UgZ2V0IGZlZWRi
YWNrIG9uIHRoZQo+IGRpciAsIHRoZSBuZXh0IHRpbWUgaXMgZmFzdCB3aGVuIHdlIGRvIGEgZGly
Lgo+IE5vdyB3ZSBoYXZlIHVzZXJzIG9uIHRoaXMgc3lzdGVtcyBhbmQgdGhpcyBwcm9ibGVtIGdp
dmUgbm90IGdvb2QgCj4gcGVyZm9ybWFuY2Ugb24gc3FsIGFuZCB3ZWJzaXRlcyBhbiBlLW1haWwg
d2UgYXJlIHJ1bm5pbmcgb24gdGhlCj4gc2VydmVyLgo+IAoKSSBzdXNwZWN0IHRoYXQgeW91J3Jl
IHVzaW5nIHNsb3csIDcyMDAgUlBNIGRyaXZlcyBpbiBSQUlELTUgb3IgUkFJRC02LAphbmQgeW91
J3JlIElPIGJvdW5kLiBFcXVhbGxvZ2ljIGFycmF5cyBhcmUgbm90YWJseSBzbG93LiBFYXN5IHRv
IHVzZSwKY2hlYXAsIGFuZCBzbG9vb293ICgiZmFzdCwgZ29vZCwgY2hlYXAsIGNob29zZSB0d28i
IGFzIHRoZSBzYXlpbmcgZ28pLgoKV2hhdCBpcyB5b3VyIGRyaXZlL1JBSUQgY29uZmlndXJhdGlv
bj8gSXMgdGhlIGlTQ1NJIGxpbmsgMUdpZ0Ugb3IgMTAKR2lnRT8KCi0tIAotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAg
ICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0Bp
bnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIK
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
