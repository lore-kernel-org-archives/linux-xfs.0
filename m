Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IMxljF136683 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 17:59:47 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 129E51C9464E
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 15:59:40 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id d0E9ZbJrR3QSVpjW for
	<xfs@oss.sgi.com>; Tue, 18 Oct 2011 15:59:40 -0700 (PDT)
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 18 Oct 2011 18:52:17 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9IMnWg9165678 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 18:51:21 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p9IEFMqN008211
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 08:15:22 -0600
Subject: Re: [RFC PATCH 1/3] Remove in core use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <201110180716.14756.arekm@maven.pl>
References: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111018000938.14942.44199.sendpatchset@chandra-lucid.austin.ibm.com>
	<201110180716.14756.arekm@maven.pl>
Date: Tue, 18 Oct 2011 09:15:11 -0500
Message-ID: <1318947311.9298.141.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

R29vZCBjYXRjaC4gV2lsbCBmaXggdGhlbSBpbiB0aGUgbmV4dCBpdGVyYXRpb24uCgpUaGFua3Mu
CgpDaGFuZHJhCk9uIFR1ZSwgMjAxMS0xMC0xOCBhdCAwNzoxNiArMDIwMCwgQXJrYWRpdXN6IE1p
xZtraWV3aWN6IHdyb3RlOgo+IE9uIFR1ZXNkYXkgMTggb2YgT2N0b2JlciAyMDExLCBDaGFuZHJh
IFNlZXRoYXJhbWFuIHdyb3RlOgo+IAo+IFF1aWNrIGxvb2sgZm9yIGRpZmYgYmV0d2VlbiB5b3Vy
IGFuZCBtaW5lIHBhdGNoIHdoZW4gSSB3YXMgcGxheWluZyB3aXRoIAo+IHNlcGFyYXRlIHByb2pl
Y3QgcXVvdGEgc29tZSB0aW1lIGFnbyBhbmQ6Cj4gCj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hm
c19xbV9zeXNjYWxscy5jIGIvZnMveGZzL3hmc19xbV9zeXNjYWxscy5jCj4gPiBpbmRleCA1Y2Mz
ZGRlLi4zYTY3ODA1IDEwMDY0NAo+ID4gLS0tIGEvZnMveGZzL3hmc19xbV9zeXNjYWxscy5jCj4g
PiArKysgYi9mcy94ZnMveGZzX3FtX3N5c2NhbGxzLmMKPiA+IEBAIC0xMjAsMTEgKzEyMCwxMSBA
QCB4ZnNfcW1fc2NhbGxfcXVvdGFvZmYoCj4gPiAgCX0KPiA+ICAJaWYgKGZsYWdzICYgWEZTX0dR
VU9UQV9BQ0NUKSB7Cj4gPiAgCQlkcXR5cGUgfD0gWEZTX1FNT1BUX0dRVU9UQTsKPiA+IC0JCWZs
YWdzIHw9IChYRlNfT1FVT1RBX0NIS0QgfCBYRlNfT1FVT1RBX0VORkQpOwo+ID4gKwkJZmxhZ3Mg
fD0gKFhGU19HUVVPVEFfQ0hLRCB8IFhGU19HUVVPVEFfRU5GRCk7Cj4gPiAgCQlpbmFjdGl2YXRl
X2ZsYWdzIHw9IFhGU19HUVVPVEFfQUNUSVZFOwo+ID4gIAl9IGVsc2UgaWYgKGZsYWdzICYgWEZT
X1BRVU9UQV9BQ0NUKSB7Cj4gCj4gVGhlc2UgY2FuIGJlIHNlcGFyYXRlIHNvLCBubyBlbHNlIGlm
IGJ1dCBqdXN0IHNlcGFyYXRlIGlmLgo+IAo+IAo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNf
c3VwZXIuYyBiL2ZzL3hmcy94ZnNfc3VwZXIuYwo+ID4gaW5kZXggYmExNjI0OC4uYjFjOGQ1YiAx
MDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy94ZnNfc3VwZXIuYwo+ID4gKysrIGIvZnMveGZzL3hmc19z
dXBlci5jCj4gCj4gPiBAQCAtNTUyLDEyICs1NTMsMTIgQEAgeGZzX3Nob3dhcmdzKAo+ID4gIAkv
KiBFaXRoZXIgcHJvamVjdCBvciBncm91cCBxdW90YXMgY2FuIGJlIGFjdGl2ZSwgbm90IGJvdGgg
Ki8KPiAKPiBObyBsb25nZXIgdHJ1ZS4KPiAKPiA+IAo+ID4gIAlpZiAobXAtPm1fcWZsYWdzICYg
WEZTX1BRVU9UQV9BQ0NUKSB7Cj4gPiAtCQlpZiAobXAtPm1fcWZsYWdzICYgWEZTX09RVU9UQV9F
TkZEKQo+ID4gKwkJaWYgKG1wLT5tX3FmbGFncyAmIFhGU19QUVVPVEFfRU5GRCkKPiA+ICAJCQlz
ZXFfcHV0cyhtLCAiLCIgTU5UT1BUX1BSSlFVT1RBKTsKPiA+ICAJCWVsc2UKPiA+ICAJCQlzZXFf
cHV0cyhtLCAiLCIgTU5UT1BUX1BRVU9UQU5PRU5GKTsKPiA+ICAJfSBlbHNlIGlmIChtcC0+bV9x
ZmxhZ3MgJiBYRlNfR1FVT1RBX0FDQ1QpIHsKPiAKPiBBbHNvIG5vdCBlbHNlIGlmIC0ganVzdCBp
Zi4KPiAKPiA+IC0JCWlmIChtcC0+bV9xZmxhZ3MgJiBYRlNfT1FVT1RBX0VORkQpCj4gPiArCQlp
ZiAobXAtPm1fcWZsYWdzICYgWEZTX0dRVU9UQV9FTkZEKQo+IAoKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5z
Z2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
