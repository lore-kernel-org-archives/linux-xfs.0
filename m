Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 821777CA2
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:19:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40D4A304062
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 07:19:05 -0700 (PDT)
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
	by cuda.sgi.com with ESMTP id w5vkF3rvWbiiDI09 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 07:19:03 -0700 (PDT)
Message-ID: <1460556627.24985.28.camel@hpe.com>
Subject: Re: ext4 error
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 13 Apr 2016 08:10:27 -0600
In-Reply-To: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
References: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
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
To: Eric Shang <EricShang@zhaoxin.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

T24gV2VkLCAyMDE2LTA0LTEzIGF0IDEzOjQ0ICswMDAwLCBFcmljIFNoYW5nIHdyb3RlOgo+IEhJ
IEFsbDoKPiDCoCBJIG1lZXQgYW4gZXh0NCBlcnJvciwgZm9sbG93aW5nIGlzIHRoZSBlcnJvciBs
b2cuIEFmdGVyIHBhbmljLCBJIGNoZWNrIHRoZQo+IGVtbWMgYnkgdGhlIHRvb2wgZGVidWZzLCB0
aGUgaW5vZGUgNjk4NzggaV9ubGluayBpcyBub3QgemVyby4gQW5kIHRoaXMgaW5vZGUKPiBkb24n
dCBiZWxvbmcgdG8gcGFyZW50IGRpciA2OTg3LCBpdCBiZWxvbmcgdG8gb3RoZXIgZmlsZSh0aGlz
IGlub2RlIGJlbG9uZyB0bwo+IHR3byBmaWxlcyB3aGVuIGNoZWNrIGJ5IGRlYnVnZnMgbmNoZWNr
KSwgSSBndWVzcyB0aGFuIHRoaXMgaW5vZGUgaGFzIGJlZWQKPiBkZWxldGVkIGluIG1lbW9yeSBh
bmQgYWxyZWFkeSB1c2VkIGJ5IG90aGVyIGZpbGUuIEJ1dCB0aGUgcGFyZW50IGRlbnRyeQo+IGJ1
ZmZfaGVhZCBub3QgZmx1c2ggdG8gZW1tYy4gQnV0IHdoZW4gbG9va3VwIHRoaXMgZGVudHJ5IGNh
bid0IGZpbmQgaXQnIGluCj4gZGVudHJ5IGNhY2hlLCBhbmQgdGhlbiBsb29rdXBfcmVhbCwgcmVh
ZCB0aGUgZGVudHJ5IGZyb20gZW1tYywgZ2V0IHRoZSBmaWxlCj4gaW5vZGUgd2hpY2ggYWxyZWFk
eSBiZSBkZWxldGVkLgo+IMKgIENhbiBhbnkgZ2l2ZSBtZSBzb21lIGhlbHAgaG93IHRvIGNoZWNr
IHRoaXMgaXNzdWUuIE15IGtlcm5lbCB2ZXJzaW9uIGlzIDMuMTgKPiBmb3JtIEFuZHJvaWQgLiBJ
IHRoaW5rcyBzb21ldGhpbmcgd3Jvbmcgd2l0aCBkZW50cnkgY2FjaGUgZmx1c2ggYW5kIGRpcnR5
Cj4gYnVmZl9oZWFkIGZsdXNoIHRvIGVtbWMuIFRoYW5rcyBhbGwhCgpBcmUgeW91IHNvbWVob3cg
dXNpbmcgREFYIGFuZCBteSBkYXhfZ2V0X3VubWFwcGVkX2FyZWEgcGF0Y2hlcyBpbiB5b3VyIEFu
ZHJvaWQKMy4xOCBrZXJuZWw/IEkgZG91YnQgdGhpcyBpcyB0aGUgY2FzZSwgYnV0IEkgdGhvdWdo
dCBJIHNob3VsZCBjaGVjayBzaW5jZSB5b3UKcmVwb3J0ZWQgaXQgdG8gbWUgYW5kIE1hdHRoZXcg
d2l0aCB0aGUgc2FtZSBjYyBsaXN0LgoKSWYgeW91IGFyZSBzaW1wbHkgdXNpbmcgYSBkaXN0cmli
dXRlZCBBbmRyb2lkIGtlcm5lbCwgeW91IHNob3VsZCByZXBvcnQgaXQgdG8KQW5kcm9pZCBlbWFp
bCBsaXN0IG9yIGJ1ZyB0cmFja2VyLgoKLVRvc2hpCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
