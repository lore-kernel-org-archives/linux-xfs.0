Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64A337CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 13:40:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 370A0304048
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:40:02 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	sXLc3Ly6Teq4GiCW for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 11:40:01 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 4/5] dax: for truncate/hole-punch, do zeroing through
	the driver if possible
Date: Wed, 11 May 2016 18:39:59 +0000
Message-ID: <1462991986.29294.29.camel@intel.com>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
	<1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <5E1FB0B45FA4AB4A819E9443201F1C82@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "boaz@plexistor.com" <boaz@plexistor.com>, "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

T24gVHVlLCAyMDE2LTA1LTEwIGF0IDEyOjQ5IC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
wqANCi4uLg0KDQo+IEBAIC0xMjQwLDExICsxMjU0LDE2IEBAIGludCBkYXhfemVyb19wYWdlX3Jh
bmdlKHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+IGxvZmZfdCBmcm9tLCB1bnNpZ25lZCBsZW5ndGgs
DQo+IMKgCQkJLnNpemUgPSBQQUdFX1NJWkUsDQo+IMKgCQl9Ow0KPiDCoA0KPiAtCQlpZiAoZGF4
X21hcF9hdG9taWMoYmRldiwgJmRheCkgPCAwKQ0KPiAtCQkJcmV0dXJuIFBUUl9FUlIoZGF4LmFk
ZHIpOw0KPiAtCQljbGVhcl9wbWVtKGRheC5hZGRyICsgb2Zmc2V0LCBsZW5ndGgpOw0KPiAtCQl3
bWJfcG1lbSgpOw0KPiAtCQlkYXhfdW5tYXBfYXRvbWljKGJkZXYsICZkYXgpOw0KPiArCQlpZiAo
ZGF4X3JhbmdlX2lzX2FsaWduZWQoYmRldiwgJmRheCwgb2Zmc2V0LCBsZW5ndGgpKQ0KPiArCQkJ
cmV0dXJuIGJsa2Rldl9pc3N1ZV96ZXJvb3V0KGJkZXYsIGRheC5zZWN0b3IsDQo+ICsJCQkJCWxl
bmd0aCA+PiA5LCBHRlBfTk9GUywgdHJ1ZSk7DQoNCkZvdW5kIGFub3RoZXIgYnVnIGhlcmUgd2hp
bGUgdGVzdGluZy4gVGhlIHplcm9vdXQgbmVlZHMgdG8gYmUgZG9uZSBmb3INCnNlY3RvciArIChv
ZmZzZXQgPj4gOSkuIFRoZSBhYm92ZSBqdXN0IHplcm9lZCBvdXQgdGhlIGZpcnN0IHNlY3RvciBv
Zg0KdGhlIHBhZ2UgaXJyZXNwZWN0aXZlIG9mIG9mZnNldCwgd2hpY2ggaXMgd3JvbmcuCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxp
c3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hm
cwo=
