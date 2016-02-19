Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E3E07CA0
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 09:44:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 843FDAC002
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 07:44:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id otxQuTUPV7shi2YH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Feb 2016 07:43:51 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id AB3E78EFE6
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 15:43:50 +0000 (UTC)
Date: Fri, 19 Feb 2016 10:43:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: What is the meaning of XLOG_MIN_RECORD_BSIZE? (Missing a check?)
Message-ID: <20160219154347.GA27263@bfoster.bfoster>
References: <CACj3i70osVyt=QTTqoqKGttwNC8w7Gtq479-Nk-icQrDn83hCA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i70osVyt=QTTqoqKGttwNC8w7Gtq479-Nk-icQrDn83hCA@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

T24gRnJpLCBGZWIgMTksIDIwMTYgYXQgMDI6MzQ6NTJQTSArMDEwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IEhpIGd1eXMsCj4gCj4gd2hhdCBpcyB0aGUgbWVhbmluZyBvZiBYTE9HX01JTl9SRUNPUkRf
QlNJWkUgaW4gbGlieGZzL3hmc19sb2dfZm9ybWF0Lmg/Cj4gSXQgaXMgbm90IHVzZWQgYW55d2hl
cmUuIEkgdGhvdWdodCBpdCBtaWdodCBiZSByZWxhdGVkIHRvIC1sIHN1L3N1bml0Cj4gb3B0aW9u
LCBidXQgc2VlaW5nIHRlc3RzIHdpdGggLWwgc3U9NDA5NiAodGhlIG1hY3JvIGlzIHNldCB0byAx
NmspLCBpdAo+IGxvb2tzIG1vcmUgbGlrZSBhIGZvcmdvdHRlbiB2YWx1ZS4KPiAKCkl0J3MgdGhl
IG1pbmltdW0gbG9nIGJ1ZmZlciBzaXplIGFsbG93ZWQgaW4gdGhlIGtlcm5lbC4gSXQncyB1c2Vk
IGluCnhmc19zdXBlci5jIGF0IG1vdW50IHRpbWUgdG8gdmFsaWRhdGUgdGhlIGxvZ2JzaXplIG9w
dGlvbjoKCiAgICAgICAgaWYgKG1wLT5tX2xvZ2JzaXplICE9IC0xICYmCiAgICAgICAgICAgIG1w
LT5tX2xvZ2JzaXplICE9ICAwICYmCiAgICAgICAgICAgIChtcC0+bV9sb2dic2l6ZSA8IFhMT0df
TUlOX1JFQ09SRF9CU0laRSB8fAogICAgICAgICAgICAgbXAtPm1fbG9nYnNpemUgPiBYTE9HX01B
WF9SRUNPUkRfQlNJWkUgfHwKICAgICAgICAgICAgICFpc19wb3dlcl9vZl8yKG1wLT5tX2xvZ2Jz
aXplKSkpIHsKICAgICAgICAgICAgICAgIHhmc193YXJuKG1wLAogICAgICAgICAgICAgICAgICAg
ICAgICAiaW52YWxpZCBsb2didWZzaXplOiAlZCBbbm90IDE2aywzMmssNjRrLDEyOGsgb3IgMjU2
a10iLAogICAgICAgICAgICAgICAgICAgICAgICBtcC0+bV9sb2dic2l6ZSk7CiAgICAgICAgICAg
ICAgICByZXR1cm4gLUVJTlZBTDsKICAgICAgICB9CgpJIHN1c3BlY3QgaXQncyBub3QgcmVsZXZh
bnQgaW4gdXNlcnNwYWNlLgoKPiBUaGVyZSBpcyBubyBjaGVjayBmb3IgYSBtaW5pbWFsIHZhbHVl
LCBzbyBJIGNhbiBkbyAtbCBzdT0xIChvciBzdT0wKS4gQXJlCj4gdGhlcmUgc29tZSBjYXZlYXTi
gItzIChvdGhlciB0aGFuIHBlcmZvcm1hbmNlKSB3aXRoIHN1Y2ggYSBzbWFsbCB2YWx1ZT8gQ2Fu
Cj4gaXQgYmUgdGhhdCB3ZSBhcmUgbWlzc2luZyBhIGNoZWNrPyBCZWNhdXNlCj4gWExPR19CSUdf
UkVDT1JEX0JTSVpFCj4g4oCLIGFuZCBYTE9HX01BWF9SRUNPUkRfQlNJWkUgYXJlIHVzZWQgYW5k
IHRoZSB1cHBlciBib3VuZCBpcyBsaW1pdGVkLuKAiy4uCj4gCgpPbiBhIHF1aWNrIHRlc3QsIGl0
IGxvb2tzIGxpa2UgbWtmcyBqdXN0IGlnbm9yZXMgY2VydGFpbiBsb2cgc3RyaXBlIHVuaXQKdmFs
dWVzIHRoYXQgYXJlbid0IGJsb2NrIGFsaWduZWQuIEknZCBwcm9iYWJseSBleHBlY3QgdGhpcyB0
byBiZWhhdmUKc2ltaWxhciB0byB0aGUgJy1kIHN1JyBvcHRpb24gYW5kIGNvbXBsYWluIGFib3V0
IGludmFsaWQgaW5wdXQuLj8KCkJyaWFuCgo+IAo+IOKAi1RoYW5rc+KAiy4KPiAKPiBDaGVlcnMs
Cj4gSmFuCj4gCj4gLS0gCj4gSmFuIFR1bGFrCj4ganR1bGFrQHJlZGhhdC5jb20gLyBqYW5AdHVs
YWsubWUKCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
PiB4ZnMgbWFpbGluZyBsaXN0Cj4geGZzQG9zcy5zZ2kuY29tCj4gaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3Nz
LnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
