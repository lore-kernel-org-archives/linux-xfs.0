Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A6117CBF
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 11:38:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7824A8F8084
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 09:38:56 -0700 (PDT)
Received: from mail-pb0-f48.google.com (mail-pb0-f48.google.com
	[209.85.160.48]) by cuda.sgi.com with ESMTP id xLyPl5GB8RS46qRq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Apr 2013 09:38:55 -0700 (PDT)
Received: by mail-pb0-f48.google.com with SMTP id xb4so1498740pbc.21
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 09:38:54 -0700 (PDT)
Message-ID: <5168388C.5050404@gmail.com>
Date: Sat, 13 Apr 2013 00:38:36 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix the regex pattern in get_group_list of check
References: <5167A5D3.4070903@gmail.com> <20130412075728.GD30622@dastard>
In-Reply-To: <20130412075728.GD30622@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>, Rich Johnston <rjohnston@sgi.com>, Dave Chinner <dchinner@redhat.com>

T24gMjAxM+W5tDA05pyIMTLml6UgMTU6NTcsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBPbiBGcmks
IEFwciAxMiwgMjAxMyBhdCAwMjoxMjozNVBNICswODAwLCBXYW5nIFNoZW5nLUh1aSB3cm90ZToK
Pj4gSW4gZ3JvdXAgZmlsZXMsIG5vbiBjb21tZW50IGxpbmUgc3RhcnRzIHdpdGggYSAzLWRpZ2l0
cywgdGhlbiBmb2xsb3dlZCBieQo+PiBzcGFjZSBhbmQgb3RoZXIgY2hhcmFjdGVycywgYnV0IG5v
IGdyb3VwIG5hbWVzLgo+Cj4gSSBkb24ndCBmb2xsb3cuIEEgZ3JvdXAgZmlsZSBsaW5lIGxvb2tz
IGxpa2U6Cj4KPiAwMDMgZGIgYXV0byBxdWljawo+Cj4gV2hpY2ggZGVmaW5lcyB0aGUgdGVzdCBu
YW1lLCBmb2xsb3dlZCBieSB0aGUgZ3JvdXAgbmFtZXMgdGhlIHRlc3QKPiBiZWxvbmdzIHRvLgo+
Cj4+IFRoZSBvbGQgcmVnZXggaW4gZ2V0X2dyb3VwX2xpc3QgdXNlcyB0aGUgZ3JvdXAgbmFtZSBh
cyBwYXJ0IG9mIHRoZSByZWdleCwKPj4gYW5kIGZhaWxzICcuL2NoZWNrIC1nIHhmcycgcnVuOgo+
PiAgICAgICAgICBHcm91cCAieGZzIiBpcyBlbXB0eSBvciBub3QgZGVmaW5lZD8KPgo+IFdlbGws
IHllcywgInhmcyIgaXMgbm90IGEgZGVmaW5lZCBncm91cCBuYW1lOgo+Cj4gJCBncmVwIHhmcyB0
ZXN0cy8qL2dyb3VwCj4gJAo+Cj4gSWYgSSBkZWZpbmUgYSAieGZzIiBncm91cCBieSBhc3NpZ25p
bmcgdGVzdHMgdG8gaXQsIGNoZWNrIHJ1bnMganVzdAo+IGZpbmUuCj4KPiAkIGdyZXAgeGZzIHRl
c3RzLyovZ3JvdXAKPiB0ZXN0cy94ZnMvZ3JvdXA6MDAzIGRiIGF1dG8gcXVpY2sgeGZzCj4gJCBz
dWRvIC4vY2hlY2sgLWcgeGZzCj4gRlNUWVAgICAgICAgICAtLSB4ZnMgKGRlYnVnKQo+IFBMQVRG
T1JNICAgICAgLS0gTGludXgveDg2XzY0IHRlc3QtMiAzLjkuMC1yYzQtZGdjKwo+IE1LRlNfT1BU
SU9OUyAgLS0gLWYgLWJzaXplPTQwOTYgL2Rldi92ZGIKPiBNT1VOVF9PUFRJT05TIC0tIC9kZXYv
dmRiIC9tbnQvc2NyYXRjaAo+Cj4geGZzLzAwMyAgMXMKPiBSYW46IHhmcy8wMDMKPiBQYXNzZWQg
YWxsIDEgdGVzdHMKPiAkCj4KPiBTbyB3aGF0IGNoZWNrIGlzIGRvaW5nIGxvb2tzIHBlcmZlY3Rs
eSBPSyB0byBtZSBhbmQgZG9lc24ndCBuZWVkCj4gY2hhbmdpbmcuCj4KPj4gVGhlIHBhdGNoIHJl
bW92ZXMgdGhlIHBhdHRlcm4gZm9yIGdyb3VwIG5hbWUsIGFuZCB0aHVzIHdlIGNhbiB0cmlnZ2Vy
IHRlc3RzCj4+IGxpa2UgIi4vY2hlY2sgLWcgeGZzIiBhcyBub3JtYWwuCj4KPiBJZiB5b3Ugd2Fu
dCB0byBydW4gYWxsIHRoZSB0ZXN0cyBpbiBhIHNwZWNpZmljIHN1YmRpcmVjdG9yeSByZWdhcmRs
ZXNzCj4gb2YgZ3JvdXBzLCB0aGVuIHlvdSBjYW4gZG8gaXQgbGlrZToKPgo+ICQgc3VkbyAuL2No
ZWNrIHhmcy9bMC05XVswLTldWzAtOV0KClRoYW5rcywgRGF2ZS4KCkkgY29uZnVzZWQgdGhlIGdy
b3VwIHdpdGggZnMgdHlwZS4KCj4gRlNUWVAgICAgICAgICAtLSB4ZnMgKGRlYnVnKQo+IFBMQVRG
T1JNICAgICAgLS0gTGludXgveDg2XzY0IHRlc3QtMiAzLjkuMC1yYzQtZGdjKwo+IE1LRlNfT1BU
SU9OUyAgLS0gLWYgLWJzaXplPTQwOTYgL2Rldi92ZGIKPiBNT1VOVF9PUFRJT05TIC0tIC9kZXYv
dmRiIC9tbnQvc2NyYXRjaAo+Cj4geGZzLzAwMyAgMHMKPiB4ZnMvMDA0ICAwcwo+IHhmcy8wMDgg
IDFzCj4gLi4uLi4KPgo+IFRoZXJlJ3MgZGVmaW5pdGVseSBiZXR0ZXIgd2F5cyB0byBkbyB0aGlz
LCBidXQgY29uZmxhdGluZyBzb3VyY2UgdHJlZQo+IGxheW91dCB3aXRoIHJ1bnRpbWUgdGVzdCBn
cm91cCBkZWZpbml0aW9ucyBpcyBub3QgaXQuIDspCj4KPiBQZXJoYXBzIHNvbWV0aGluZyBsaWtl
ICJjaGVjayB4ZnMiIHdpbGwganVzdCBydW4gYWxsIHRlc3RzIGluIHRoZQo+IHhmcyB0ZXN0IGRp
ciwgc2ltaWxhciBmb3IgZXh0NCwgc2hhcmVkLCBldGM/Cj4KPiBDaGVlcnMsCj4KPiBEYXZlLgo+
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
