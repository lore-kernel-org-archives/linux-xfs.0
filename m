Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BE8C7CAF
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 09:25:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FB338F8035
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 07:25:13 -0700 (PDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	wGaHBp2FaFoMtWb9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 07:25:12 -0700 (PDT)
Received: by mail-io0-f177.google.com with SMTP id 38so77569229iol.0
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 07:25:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160720235433.GA12670@dastard>
References: <1468500214-6237-1-git-send-email-jtulak@redhat.com>
	<1468500214-6237-7-git-send-email-jtulak@redhat.com>
	<20160716093358.GL2432@eguan.usersys.redhat.com>
	<20160717233003.GX1922@dastard>
	<CACj3i73TdnUcDT0J2QEBKQhoMsyYFVz6hBb_=bC99rL2ZbkCYQ@mail.gmail.com>
	<20160718114723.GG27776@eguan.usersys.redhat.com>
	<CACj3i71VOC8i_11hFn_fphsMfGqduHB6on5UawUHm6mtAaVRhQ@mail.gmail.com>
	<CACj3i73hdbW4iAWufvxc_aJn1dj+UGzuud7Cj-qMiwe7aLeNxQ@mail.gmail.com>
	<20160720235433.GA12670@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 21 Jul 2016 16:24:52 +0200
Message-ID: <CACj3i72UFhXeM-H8ubnso3CRH851Jp1nP-R-pP6AXZrABOeQMQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] xfstests: Add mkfs input validation tests
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

T24gVGh1LCBKdWwgMjEsIDIwMTYgYXQgMTo1NCBBTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9t
b3JiaXQuY29tPiB3cm90ZToKPj4gPj4gSSB0aGluayB5b3UgbmVlZCB0byB0ZXN0IG9uIGEgNGsg
c2VjdG9yIHNpemUgZGlzay4gSSB1c2Ugc2NzaV9kZWJ1ZyB0bwo+PiA+PiBzaW11bGF0ZSBwaHlz
aWNhbCA0ayBzZWN0b3IgZGlzayB0byByZXByb2R1Y2UgdGhpczoKPj4gPj4KPj4gPj4gW3Jvb3RA
ZGhjcC02Ni04Ni0xMSB4ZnNwcm9ncy1kZXZdIyBtb2Rwcm9iZSAtciBzY3NpX2RlYnVnCj4+ID4+
IFtyb290QGRoY3AtNjYtODYtMTEgeGZzcHJvZ3MtZGV2XSMgbW9kcHJvYmUgc2NzaV9kZWJ1ZyBk
ZXZfc2l6ZV9tYj0xMjggcGh5c2Jsa19leHA9Mwo+PiA+PiBbcm9vdEBkaGNwLTY2LTg2LTExIHhm
c3Byb2dzLWRldl0jIGJsb2NrZGV2IC0tZ2V0YnN6IC0tZ2V0cGJzeiAtLWdldHNzIC9kZXYvc2Rj
Cj4+ID4+IDQwOTYKPj4gPj4gNDA5Ngo+PiA+PiA1MTIKPj4gPj4gW3Jvb3RAZGhjcC02Ni04Ni0x
MSB4ZnNwcm9ncy1kZXZdIyBta2ZzIC10IHhmcyAtbCB2ZXJzaW9uPTEgLW0gY3JjPTEgL2Rldi9z
ZGMKPgo+IFNvIHRoaXMgaXMgYW4gaW52YWxpZCBmaWxlc3lzdGVtIGNvbmZpZ3VyYXRpb24uIEl0
IHNob3VsZCBiZQo+IGRldGVjdGVkIGFzIHN1Y2ggZHVyaW5nIGNvbW1hbmQgbGluZSBwYXJzaW5n
IGFuZCByZWplY3RlZCBiZWZvcmUgd2UKPiBnZXQgYW55d2hlcmUgbmVhciBjaGVja2luZyB0b3Bv
bG9neSBjb25zdHJhaW50cy4gSW4gbWtmcwo+IHRlcm1zLCBpdCdzIGEgY29uZmxpY3Rpbmcgb3B0
aW9uIHNldC4KPgo+PiBBbmQgdGhlIGN1bHByaXQgaXMgaW4gbWtmcywgc29tZSBmb3J0eSBsaW5l
cyBiZWZvcmUgdGhlIGNyYyAmIGxvZyB2ZXJzaW9uIGNoZWNrOgo+Pgo+PiAyMDI2IOKHpSAgICAg
ICB9IGVsc2UgaWYgKGxzZWN0b3JzaXplID4gWEZTX01JTl9TRUNUT1JTSVpFICYmICFsc3UgJiYg
IWxzdW5pdCkgewo+PiAyMDI3IOKHpSAgICAgICDih6UgICAgICAgbHN1ID0gYmxvY2tzaXplOwo+
PiAyMDI4IOKHpSAgICAgICDih6UgICAgICAgc2JfZmVhdC5sb2dfdmVyc2lvbiA9IDI7Cj4+IDIw
Mjkg4oelICAgICAgIH0KPj4KPj4gVGhlIHBvc3NpYmxlIHNvbHV0aW9ucyBJIGNhbiB0aGluayBv
ZiBhcmU6Cj4KPiBOb25lIG9mIHdoaWNoIHJlYWxseSBhcHBlYWwgYmVjYXVzZSwgSU1PLCB0aGV5
IGFyZSB0cnlpbmcgdG8gc29sdmUKPiB0aGUgd3JvbmcgcHJvYmxlbS4KPgo+IFRoZSB3aG9sZSBw
b2ludCBvZiBtb3ZpbmcgdG8gdGFibGUgYmFzZWQgY29tbWFuZCBsaW5lIG9wdGlvbiBwYXJzaW5n
Cj4gaXMgdGhhdCB3ZSBjYW4gZW5jb2RlIHRoZXNlIHNvcnRzIG9mIGNvbmZsaWN0cyBpbnRvIHRo
ZSBvcHRpb24KPiB0YWJsZS4gVGhlIGNvbmZsaWN0IHJlc29sdXRpb24gaW4gdGhlIG9wdGlvbiB0
YWJsZSBpcyBjdXJyZW50bHkgbm90Cj4gY29tcGxldGUgLSBpdCBjYW4gb25seSBlbmNvZGUgYW5k
IGRldGVjdCBjb25mbGljdHMgd2l0aGluIGEKPiBzdWJvcHRpb24gdHlwZSwgYnV0IG5vdCBhY3Jv
c3Mgc3Vib3B0aW9uIHR5cGVzIChlLmcuIHdpdGhpbiAtZAo+IHN1Ym9wdGlvbnMsIGJ1dCBub3Qg
YmV0d2VlbiAtZCBhbmQgLWwgc3Vib3B0aW9ucykuCj4KPiBUaGlzIGlzIHNpbXBseSBiZWNhdXNl
IEkgbmV2ZXIgZ290IGFzIGZhciBhcyBpbXBsZW1lbnRpbmcgdGhpcyBsZXZlbAo+IG9mIGNvbmZs
aWN0IGVuY29kaW5nL3Jlc29sdXRpb24uIEluIGVzc2VuY2UsIHRoZSBjb25mbGljdCBhcnJheQo+
IG5lZWRzIHRvIGRlZmluZSB0aGUgc3ViIG9wdGlvbiB0eXBlLCB0aGUgc3Vib3B0aW9uIHRoYXQg
aXMKPiBpbiBjb25mbGljdCBhbmQgdGhlIHZhbHVlIHRoYXQgaXQgY29uZmxpY3RzIGFnYWluc3Qu
IEhlbmNlIHRoZQo+IGNvbmZsaWN0cyB0YWJsZSBjYW4gdGhlbiBlbmNvZGUgc3VjaCB0aGluZ3Mg
YXMgInZlcnNpb24gMSBsb2dzIGFyZQo+IGludmFsaWQgZm9yIENSQyBlbmFibGVkIGZpbGVzeXN0
ZW1zIiBhbmQgdmljZSB2ZXJzYS4KPgoKT2ssIGluIGxvbmcgdGVybSwgdGhlIGNvcnJlY3Qgd2F5
IGlzIHRvIGV4dGVuZCB0aGUgY29uZmxpY3RzIHRhYmxlLgpCdXQgd2hhdCBpbiB0aGUgbWVhbnRp
bWU/IEFyZSB3ZSBnb2luZyB0byBsZXQgaXQgYmUgbm93IHVudGlsIGl0IGlzCmZpeGVkIGJ5IHRo
ZSBlbmhhbmNlZCB0YWJsZT8KQW5kIHJlZ2FyZGluZyBteSBxdWVzdGlvbiBhdCB0aGUgZW5kIG9m
IHRoZSBtYWlsLCBJIGludGVycHJldCB5b3VyCmFuc3dlciBhcyAiaWYgdGhlIGFyZ3VtZW50cyBh
cmUgd3JvbmcsIGZhaWwgQVNBUCBhbmQgZG9uJ3QgdHJ5IHRvIGZpeAppdC4iCgpUaGFua3MsCkph
bgoKLS0gCkphbiBUdWxhawpqdHVsYWtAcmVkaGF0LmNvbSAvIGphbkB0dWxhay5tZQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
