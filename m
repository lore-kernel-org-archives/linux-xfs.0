Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C752B7F3F
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 01:15:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BF9B8F8040
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2016 23:15:39 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id G4lDIrWHli2XH2A4 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 10 Jan 2016 23:15:36 -0800 (PST)
Subject: Re: [resend PATCH 1/3] block, fs: reliably communicate bdev
	end-of-life
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160109075414.GA5008@ZenIV.linux.org.uk>
	<CAPcyv4gyNKHPbhwNrK3N3qtrpO5j=B6Os3ZHZFUrGA-DU6kHNQ@mail.gmail.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <56935694.1000408@suse.de>
Date: Mon, 11 Jan 2016 08:15:32 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gyNKHPbhwNrK3N3qtrpO5j=B6Os3ZHZFUrGA-DU6kHNQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Williams <dan.j.williams@intel.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

T24gMDEvMDkvMjAxNiAwMzoxNyBQTSwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+IE9uIEZyaSwgSmFu
IDgsIDIwMTYgYXQgMTE6NTQgUE0sIEFsIFZpcm8gPHZpcm9AemVuaXYubGludXgub3JnLnVrPiB3
cm90ZToKPj4gT24gTW9uLCBKYW4gMDQsIDIwMTYgYXQgMTA6MjA6MDVBTSAtMDgwMCwgRGFuIFdp
bGxpYW1zIHdyb3RlOgo+IFsuLl0KPj4gICAgICAgICAgV291bGQgeW91IG1pbmQgZXhwbGFpbmlu
ZyB3aGF0IHRoZSBoZWxsIGlzIF90aGVfIGJhY2tpbmcgZGV2aWNlCj4+IG9mIGEgZmlsZXN5c3Rl
bT8gIFdoYXQgZG9lcyB0aGF0IHRyYW5zbGF0ZSBpbnRvIGluIGNhc2Ugb2YgZS5nLiBidHJmcwo+
PiBzcGFubmluZyBzZXZlcmFsIGRpc2tzPyAgT3IgZXh0NCB3aXRoIGpvdXJuYWwgb24gYSBkaWZm
ZXJlbnQgZGV2aWNlLCBmb3IKPj4gdGhhdCBtYXR0ZXI/Cj4+Cj4+ICAgICAgICAgIElmIGFueXRo
aW5nLCBJIHdvdWxkIGFyZ3VlIHRoYXQgZmlsZXN5c3RlbSBpcyBvdXQgb2YgcGxhY2UgaGVyZSAt
Cj4+IGdlbmVyYWwgc2l0dWF0aW9uIGlzICJJTyBvbiBYIG1heSByZXF1aXJlIElPIG9uIGRldmlj
ZSBZIGFuZCBYIG5lZWRzIHRvIGRvCj4+IHNvbWV0aGluZyB3aGVuIFkgZ29lcyBhd2F5Ii4gIENv
bnNpZGVyIGUuZy4gL2Rldi9sb29wIGJhY2tlZCBieSBhIGRldmljZQo+PiB0aGF0IHdlbnQgYXdh
eS4gIE9yIGJ5IGEgZmlsZSBvbiBmcyB0aGF0IGhhcyBydW4gZG93biB0aGUgY3VydGFpbiBhbmQg
am9pbmVkCj4+IHRoZSBibGVlZGluIGNob2lyIGludmlzaWJsZS4gIFdpdGggYW5vdGhlciBmcyBw
YXJ0aWFsbHkgaG9zdGVkIGJ5IHRoYXQKPj4gbG9vcGJhY2sgZGV2aWNlLiAgT3IgYnkgUkFJRDAg
Y29udGFpbmluZyBzYWlkIGRldmljZS4KPj4KPj4gICAgICAgICAgWW91IGFyZSBnaXZlbiBZIGFu
ZCBhdHRlbXB0IHRvIGxvY2F0ZSB0aGUgYWZmZWN0ZWQgWC4gIF9UaGVuXwo+PiB5b3UgYXNzdW1l
IHRoYXQgWCBpcyBhIGZpbGVzeXN0ZW0gYW5kIGhhcyAic29tZXRoaW5nIHRvIGJlIGRvbmUiIGlu
ZGVwZW5kZW50Cj4+IGZyb20gdGhlIHJvbGUgWSBwbGF5ZWQgZm9yIGl0LCBzbyB5b3UgY2FuIHBp
Y2sgdGhhdCBhY3Rpb24gZnJvbSBzdXBlcmJsb2NrCj4+IG1ldGhvZC4KPj4KPj4gICAgICAgICAg
SU1PIHlvdSBhcmUgcGxhY2luZyB0aGUgYnVyZGVuIGluIHRoZSB3cm9uZyBwbGFjZS4gIF9SZWNl
cGllbnRfCj4+IGtub3dzIHdoYXQgaXQgZGVwZW5kcyB1cG9uIGFuZCB3aGF0IHNob3VsZCBiZSBk
b25lIGZvciBlYWNoIHNvdXJjZSBvZgo+PiB0cm91YmxlLiAgU28gbWFrZSBpdCByZWNlcGllbnQn
cyByZXNwb25zaWJpbGl0eSB0byByZXF1ZXN0IG5vdGlmaWNhdGlvbnMuCj4+IEF0IHdoaWNoIHBv
aW50IHRoZSBzdXBlcmJsb2NrIG1ldGhvZCBnb2VzIGF3YXksIGFsb25nIHdpdGggdGhlIHJlcXVp
cmVtZW50Cj4+IHRvIGhhbmRsZSBhbGwgc291cmNlcyBvZiB0cm91YmxlIHRoZSBzYW1lIHdheSwg
ZXRjLgo+Pgo+PiAgICAgICAgICBXaGF0J3MgbW9yZSwgdGhpbmdzIGxpa2UgUkFJRDUgKGFsc28g
aW50ZXJlc3RlZCBpbiBrbm93aW5nIHdoZW4KPj4gYSBjb21wb25lbnQgaGFzIGJlZW4gcmlwcGVk
IG91dCkgbWlnaHQgb3IgbWlnaHQgbm90IGRlY2lkZSB0byBwcm9wYWdhdGUKPj4gdGhlIGV2ZW50
IGZ1cnRoZXIgLSBhZnRlciBhbGwsIHRoYXQncyBleGFjdGx5IHRoZSBwb2ludCBvZiByZWR1bmRh
bmN5Lgo+Pgo+PiAgICAgICAgICBJJ2QgbG9vayBpbnRvIHNvbWV0aGluZyBhbG9uZyB0aGUgbGlu
ZXMgb2Ygbm90aWZpZXIgY2hhaW4gcGVyCj4+IGdlbmRpc2ssIHdpdGggcG90ZW50aWFsIHZpY3Rp
bXMgcmVnaXN0ZXJpbmcgYSBjYWxsYmFjayB3aGVuIHRoZXkgZGVjaWRlCj4+IHRoYXQgZnJvbSBu
b3cgb24gc3VjaCBhbmQgc3VjaCBkZXZpY2UgbWlnaHQgc2NyZXcgdGhlbSBvdmVyLi4uCj4KPiBN
YWtlcyBzZW5zZS4gIEknbGwgZHJvcCB0aGlzIHNlcmllcyBmb3Igbm93IGFuZCBjb21lIGJhY2sg
YWZ0ZXIKPiByZS13b3JraW5nIGl0IHVzZSBub3RpZmllcnMuCgpZZXMgcGxlYXNlLiBJIG5lZWQg
YSBzaW1pbGFyIHRoaW5nIGZvciBjb21tdW5pY2F0aW5nIGRldmljZSBjaGFuZ2VzIAoocmVzaXpp
bmcsIHRvcG9sb2d5IGNoYW5nZXMpLCBzbyBJJ2QgYmUgdmVyeSBtdWNoIGludGVyZXN0ZWQgaW4g
dGhlbS4KCkFuZCB3aGlsZSB5b3UncmUgYXQgaXQsIG1heWJlIHdlIGNhbiBmb2xkIHRoZSBibG9j
ayBkZXZpY2UgZXZlbnQgCmhhbmRsaW5nIGludG8gdGhhdCwgdG9vLgoKQ2hlZXJzLAoKSGFubmVz
Ci0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkgICAgICAgICAgICAgICB6U2VyaWVzICYgU3RvcmFn
ZQpoYXJlQHN1c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIExJ
TlVYIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJm
ZmVyLCBKLiBTbWl0aGFyZCwgSi4gR3VpbGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpIUkIgMjEy
ODQgKEFHIE7DvHJuYmVyZykKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
