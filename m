Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D6C57CA0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:10:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFD12AC001
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:10:26 -0700 (PDT)
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	by cuda.sgi.com with ESMTP id fDlGNO9CnCsFER0P (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:10:24 -0700 (PDT)
Message-ID: <1460746909.4597.7.camel@hpe.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
From: Toshi Kani <toshi.kani@hpe.com>
Date: Fri, 15 Apr 2016 13:01:49 -0600
In-Reply-To: <CAPcyv4hRQj2ZsFj7Xa_=OwcHrzP9_5yUpt3LQ+bPH4PcLe7UCQ@mail.gmail.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
	<x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
	<1460741821.3012.11.camel@intel.com>
	<CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
	<x49lh4e6928.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4hRQj2ZsFj7Xa_=OwcHrzP9_5yUpt3LQ+bPH4PcLe7UCQ@mail.gmail.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@fb.com" <axboe@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

T24gRnJpLCAyMDE2LTA0LTE1IGF0IDExOjE3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gRnJpLCBBcHIgMTUsIDIwMTYgYXQgMTE6MDYgQU0sIEplZmYgTW95ZXIgPGptb3llckByZWRo
YXQuY29tPiB3cm90ZToKPiA+IAo+ID4gRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRl
bC5jb20+IHdyaXRlczoKPiA+wqAKPiA+ID4gPiA+IFRoZXJlJ3MgYSBsb3Qgb2Ygc3BlY2lhbCBj
YXNpbmcgaGVyZSwgc28geW91IG1pZ2h0IGNvbnNpZGVyCj4gPiA+ID4gPiBhZGRpbmcgY29tbWVu
dHMuCj4gPiA+ID4gQ29ycmVjdCAtIG1heWJlIHdlIHNob3VsZCByZWNvbnNpZGVyIHdyYXBwZXIt
aXppbmcgdGhpcz8gOikKPiA+ID4gQW5vdGhlciBvcHRpb24gaXMganVzdCB0byBza2lwIGRheF9k
b19pbygpIGFuZCB0aGlzIHNwZWNpYWwgY2FzaW5nCj4gPiA+IGZhbGxiYWNrIGVudGlyZWx5IGlm
IGVycm9ycyBhcmUgcHJlc2VudC7CoMKgSS5lLiBvbmx5IGF0dGVtcHQgZGF4X2RvX2lvCj4gPiA+
IHdoZW46IElTX0RBWCgpICYmIGdlbmRpc2stPmJiICYmIGJiLT5jb3VudCA9PSAwLgo+ID4KPiA+
IFNvLCBpZiB0aGVyZSdzIGFuIGVycm9yIGFueXdoZXJlIG9uIHRoZSBkZXZpY2UsIHBlbmFsaXpl
IGFsbCBJL08gKG5vdAo+ID4ganVzdCB3cml0ZXMsIGFuZCBub3QganVzdCBvbiBzZWN0b3JzIHRo
YXQgYXJlIGJhZCk/wqDCoEknbSBub3Qgc3VyZQo+ID4gdGhhdCdzIGEgZ3JlYXQgcGxhbiwgZWl0
aGVyLgo+ID4gCj4gSWYgZXJyb3JzIGFyZSByYXJlIGhvdyBtdWNoIGFyZSB3ZSBhY3R1YWxseSBs
b3NpbmcgaW4gcHJhY3RpY2U/Cj4gTW9yZW92ZXIsIHdlJ3JlIGdvaW5nIHRvIGRvIHRoZSBmdWxs
IGJhZGJsb2NrcyBsb29rdXAgYW55d2F5IHdoZW4gd2UKPiBjYWxsIC0+ZGlyZWN0X2FjY2Vzcygp
LsKgwqBJZiB3ZSBoYWQgdGhhdCBpbmZvcm1hdGlvbiBlYXJsaWVyIHdlIGNhbgo+IGF2b2lkIHRo
aXMgZmFsbGJhY2sgZGFuY2UuCgpBIHN5c3RlbSBydW5uaW5nIHdpdGggREFYIG1heSBoYXZlIGFj
dGl2ZSBkYXRhIHNldCBpbiBOVkRJTU0gbGFnZXIgdGhhbiBSQU0Kc2l6ZS4gwqBJbiB0aGlzIGNh
c2UsIGZhbGxpbmcgYmFjayB0byBub24tREFYIHdpbGwgYWxsb2NhdGUgcGFnZSBjYWNoZSBmb3IK
dGhlIGRhdGEsIHdoaWNoIHdpbGwgc2F0dXJhdGUgdGhlIHN5c3RlbSB3aXRoIG1lbW9yeSBwcmVz
c3VyZS4KClRoYW5rcywKLVRvc2hpIMKgCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
