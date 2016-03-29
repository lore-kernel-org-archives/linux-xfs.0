Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 456447CA4
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 13:57:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0410F304062
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 11:57:21 -0700 (PDT)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	skN4frLI7uuKEcZQ for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2016 11:57:21 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
	dax_clear_sectors
Date: Tue, 29 Mar 2016 18:57:16 +0000
Message-ID: <1459277829.6412.3.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	<1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
	<CAPcyv4iKK=1Nhz4QqEkhc4gum+UvUS4a=+Sza2zSa1Kyrth41w@mail.gmail.com>
	<1458939796.5501.8.camel@intel.com>
	<CAPcyv4jWqVcav7dQPh7WHpqB6QDrCezO5jbd9QW9xH3zsU4C1w@mail.gmail.com>
	<1459195288.15523.3.camel@intel.com>
	<CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
In-Reply-To: <CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <64C5EAC5F614C94A96594C71EC7AFD03@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

T24gTW9uLCAyMDE2LTAzLTI4IGF0IDE2OjM0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQoN
Cjw+DQoNCj4gU2VlbXMga2luZCBvZiBzYWQgdG8gZmFpbCB0aGUgZmF1bHQgZHVlIHRvIGEgYmFk
IGJsb2NrIHdoZW4gd2Ugd2VyZQ0KPiBnb2luZyB0byB6ZXJvIGl0IGFueXdheSwgcmlnaHQ/wqDC
oEknbSBub3Qgc2VlaW5nIGEgY29tcGVsbGluZyByZWFzb24gdG8NCj4ga2VlcCBhbnkgemVyb2lu
ZyBpbiBmcy9kYXguYy4NCg0KQWdyZWVkIC0gYnV0IGhvdyBkbyB3ZSBkbyB0aGlzPyBjbGVhcl9w
bWVtIG5lZWRzIHRvIGJlIGFibGUgdG8gY2xlYXIgYW4NCmFyYml0cmFyeSBudW1iZXIgb2YgYnl0
ZXMsIGJ1dCB0byBnbyB0aHJvdWdoIHRoZSBkcml2ZXIsIHdlJ2QgbmVlZCB0bw0Kc2VuZCBkb3du
IGEgYmlvPyBJZiBvbmx5IHRoZSBkcml2ZXIgaGFkIGFuIHJ3X2J5dGVzIGxpa2UgaW50ZXJmYWNl
IHRoYXQNCmNvdWxkIGJlIHVzZWQgYnkgYW55b25lLi4uIDopCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
