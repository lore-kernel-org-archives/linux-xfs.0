Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B4F87FB6
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 06:45:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69EFD304032
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 04:45:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rkdEvTdLN9Feeg0e (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2015 04:45:18 -0800 (PST)
Date: Tue, 27 Jan 2015 07:44:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: I think that get direct directory size int the xfs file system
Message-ID: <20150127124459.GA2115@laptop.bfoster>
References: <201501261707321631278@sobey.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201501261707321631278@sobey.com>
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
To: "lihongliang@sobey.com" <lihongliang@sobey.com>
Cc: xfs <xfs@oss.sgi.com>

T24gTW9uLCBKYW4gMjYsIDIwMTUgYXQgMDU6MDc6MzdQTSArMDgwMCwgbGlob25nbGlhbmdAc29i
ZXkuY29tIHdyb3RlOgo+IEhlbGxvCj4gICAgICAgICBDYW4gZ2V0IGRpcmVjdCBkaXJlY3Rvcnkg
c2l6ZSBpbnQgdGhlIFhGUyBmaWxlIHN5c3RlbT8KPiBleGFtcGxl77yaCj4gIHJvb3RAZmljc05v
ZGUxIHRlc3QxXSMgbW91bnQgfCBncmVwIHhmcyAKPiAvZGV2L3NkYyBvbiAveGZzIHR5cGUgeGZz
IChydyx1cXVvdGEpIAo+IFtyb290QGZpY3NOb2RlMSB0ZXN0MV0jIHB3ZCAKPiAveGZzL3Rlc3Qx
IAo+IFtyb290QGZpY3NOb2RlMSB0ZXN0MV0jIGxzIC1saCAKPiB0b3RhbCA1TSAKPiAtcnctci0t
ci0tIDEgcm9vdCByb290IDEuME0gSmFuIDI2IDA5OjMzIGJsb2NrMSAKPiAtcnctci0tci0tIDEg
cm9vdCByb290IDEuME0gSmFuIDI2IDA5OjMzIGJsb2NrMiAKPiAtcnctci0tci0tIDEgcm9vdCBy
b290IDEuME0gSmFuIDI2IDA5OjMzIGJsb2NrMyAKPiAtcnctci0tci0tIDEgcm9vdCByb290IDEu
ME0gSmFuIDI2IDA5OjMzIGJsb2NrNCAKPiAtcnctci0tci0tIDEgcm9vdCByb290IDEuME0gSmFu
IDI2IDA5OjMzIGJsb2NrNSAKPiBbcm9vdEBmaWNzTm9kZTEgdGVzdDFdIyAgCj4gCj4gICAgY2Fu
IEkgZ2V0IGRpcmVjdCBpdCAgYnkgY2FsbCBzeXN0ZW0gZnVuY3Rpb24gdGhlIHRoYXQgdGhlIC94
ZnMvdGVzdDEgaXMgNU0/Cj4gCgpObywgYmVjYXVzZSB0aGF0IDVNQiBkYXRhIHBvaW50IGlzIG5v
dCBhIGRpcmVjdCBhdHRyaWJ1dGUgb2YgdGhlCmRpcmVjdG9yeS4gSXQncyB0aGUgc3VtIG9mIHRo
ZSBzcGFjZSB1c2VkIGJ5IGZpbGVzIHdpdGhpbiB0aGUgZGlyZWN0b3J5LgpUaGUgYmxvY2tzIHVz
ZWQgYnkgdGhlIGRpcmVjdG9yeSBpdHNlbGYgYXJlIGZpbGxlZCB3aXRoIGRpcmVjdG9yeQplbnRy
aWVzIChlLmcuLCBkYXRhIHN0cnVjdHVyZXMgdGhhdCBjb250YWluIHRoZSBmaWxlIG5hbWVzIGxp
c3RlZCBhYm92ZQphbG9uZyB3aXRoIGEgcmVmZXJlbmNlIHRvIGFuIGlub2RlKS4KCkEgdG9vbCBs
aWtlIGxzIG9yIGR1IGlzIHVzZWQgdG8gcHJvY2VzcyBhIGRpcmVjdG9yeSB0byBvYnRhaW4gY3Vt
dWxhdGl2ZQpkYXRhIHN1Y2ggYXMgdGhlIHRvdGFsIHNwYWNlIHVzZWQgYnkgZmlsZXMgaW4gc29t
ZSBwYXJ0aWN1bGFyIHN1YnRyZWUuCgpCcmlhbgoKPiAKPiBsaWhvbmdsaWFuZ0Bzb2JleS5jb20K
Cj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiB4ZnMg
bWFpbGluZyBsaXN0Cj4geGZzQG9zcy5zZ2kuY29tCj4gaHR0cDovL29zcy5zZ2kuY29tL21haWxt
YW4vbGlzdGluZm8veGZzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
