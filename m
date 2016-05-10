Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26A507CA0
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 14:49:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF49D304062
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 12:49:05 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	TbV6YMLVB8OE3LFo for <xfs@oss.sgi.com>;
	Tue, 10 May 2016 12:49:05 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 4/5] dax: for truncate/hole-punch, do zeroing through
	the driver if possible
Date: Tue, 10 May 2016 19:49:01 +0000
Message-ID: <1462909729.29294.21.camel@intel.com>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
	<1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
	<20160510192507.GA29312@infradead.org>
In-Reply-To: <20160510192507.GA29312@infradead.org>
Content-Language: en-US
Content-ID: <21F7193DF9ABD64A97ED656576D4EB94@intel.com>
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
To: "hch@infradead.org" <hch@infradead.org>, "axboe@fb.com" <axboe@fb.com>
Cc: "boaz@plexistor.com" <boaz@plexistor.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

T24gVHVlLCAyMDE2LTA1LTEwIGF0IDEyOjI1IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gSGkgVmlzaGFsLA0KPiANCj4gY2FuIHlvdSBhbHNvIHBpY2sgdXAgdGhlIG15IHBhdGNo
IHRvIGFkZCBhIGxvdy1sZXZlbCBfX2RheF96ZXJvX3JhbmdlDQo+IHRoYXQgSSBjY2VkIHlvdSBv
bj/CoMKgVGhhdCB3YXkgd2UgY2FuIGF2b2lkIGEgbmFzdHkgbWVyZ2UgY29uZmxpY3Qgd2l0aA0K
PiBteSB4ZnMvaW9tYXAgY2hhbmdlcy4NCg0KR29vZCBpZGVhIC0gSSdsbCBkbyB0aGF0IGZvciB0
aGUgbmV4dCBwb3N0aW5nLiBJJ2xsIHdhaXQgYSBkYXkgb3IgdHdvDQpmb3IgYW55IGFkZGl0aW9u
YWwgcmV2aWV3cy9hY2tzLg0KDQpJJ20gbG9va2luZyB0byBnZXQgYWxsIHRoaXMgaW50byBhIGJy
YW5jaCBpbiB0aGUgbnZkaW1tIHRyZWUgb25jZSBKYW4NCnNwbGl0cyB1cCBoaXMgZGF4LWxvY2tp
bmcgc2VyaWVzLi4NCg0KTW9zdGx5IEkgZ3Vlc3MgSSdtIGxvb2tpbmcgZm9yIGEgeWF5IG9yIG5h
eSBmb3IgdGhlIGJsb2NrIGxheWVyIGNoYW5nZXMNCihwYXRjaCAyKS4gSmVucz8KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
