Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7BE727FB0
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 02:44:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D55E304043
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 00:44:18 -0700 (PDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	Oa3hjLjr2TxfYPqM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 00:44:12 -0700 (PDT)
Received: by mail-wi0-f175.google.com with SMTP id ho1so5614906wib.14
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 00:44:11 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH] Detect strto* failures based on errno.
Date: Wed, 16 Jul 2014 09:44:07 +0200
References: <20140713230406.GE22339@dastard>
	<1405324619-25515-1-git-send-email-arekm@maven.pl>
	<20140716030132.GB20518@dastard>
In-Reply-To: <20140716030132.GB20518@dastard>
MIME-Version: 1.0
Message-Id: <201407160944.07266.arekm@maven.pl>
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
Cc: xfs@oss.sgi.com

T24gV2VkbmVzZGF5IDE2IG9mIEp1bHkgMjAxNCwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IE9uIE1v
biwgSnVsIDE0LCAyMDE0IGF0IDA5OjU2OjU5QU0gKzAyMDAsIEFya2FkaXVzeiBNacWba2lld2lj
eiB3cm90ZToKPiA+IENvZGUgd2FzIHRlc3RpbmcgZm9yIEVSQU5HRSBlcnJubyBvbmx5IGluIHNv
bWUgcGxhY2VzLiBJbiBvdGhlciBwbGFjZXMKPiA+IGl0IGRpZG4ndCBkbyBhbnkgZXJybm8gY2hl
Y2tpbmcgYXQgYWxsLgo+ID4gCj4gPiBVbmlmeSBzdHJ0byogcmVzdWx0IHRlc3RpbmcgYnkgdHJl
YXRpbmcgYW55IG5vbiB6ZXJvIGVycm5vIGFzIGZhaWx1cmUuCj4gPiAKPiA+IFNpZ25lZC1vZmYt
Ynk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJla21AbWF2ZW4ucGw+Cj4gCj4gVGhpcyBwYXRj
aCBhcHBlYXJzIHRvIGNhdXNlIHhmcy8wNzEgdG8gZmFpbDoKPiAKPiAKPiAKPiAgICAgIFdyaXRp
bmcgNTEyIGJ5dGVzLCBvZmZzZXQgaXMgKzAgKGRpcmVjdD1mYWxzZSkKPiAgICAgLXB3cml0ZTY0
OiBGaWxlIHRvbyBsYXJnZQo+ICAgICArbm9uLW51bWVyaWMgb2Zmc2V0IGFyZ3VtZW50IC0tIDxP
RkZTRVQ+Cj4gICAgICBSZWFkaW5nIDUxMiBieXRlcyAoZGlyZWN0PWZhbHNlKQo+ICAgICAgcmVh
ZCAwLzUxMiBieXRlcyBhdCBvZmZzZXQgPE9GRlNFVD4KPiAgICAgLi4uCj4gICAgIChSdW4gJ2Rp
ZmYgLXUgdGVzdHMveGZzLzA3MS5vdXQKPiAvaG9tZS9kYXZlL3NyYy94ZnN0ZXN0cy1kZXYvcmVz
dWx0cy8veGZzLzA3MS5vdXQuYmFkJyAgdG8gc2VlIHRoZSBlbnRpcmUKPiBkaWZmKQo+IAo+IENh
biB5b3UgaGF2ZSBhIGxvb2sgaW50byB0aGlzPwoKVGhlIHRlc3QgcnVuczoKeGZzX2lvIC1jICdw
d3JpdGUgOTIyMzM3MzEzNjM2NjQwMzU4MyA1MTInIGZpbGUKCndoZXJlIDkyMjMzNzMxMzYzNjY0
MDM1ODMgaXMgYmlnZ2VyIHRoYW4gTExPTkdfTUFYICg5MjIzMzcyMDM2ODU0Nzc1ODA3KSwgc28K
CiMgTENfQUxMPUMgeGZzX2lvIC1jICdwd3JpdGUgOTIyMzM3MzEzNjM2NjQwMzU4MyA1MTInIC4v
eAooTVlERUJVRylzdHJlcnJvcigzNCk6IE51bWVyaWNhbCByZXN1bHQgb3V0IG9mIHJhbmdlCm5v
bi1udW1lcmljIG9mZnNldCBhcmd1bWVudCAtLSA5MjIzMzczMTM2MzY2NDAzNTgzCgoKV2hhdCB3
b3VsZCBiZSBiZXN0IGFwcHJvYWNoIHRvIGZpeCB0aGlzIC0gc29tZSBjdnR1bnVtIGZvciB1bnNp
Z25lZCBsb25nIGxvbmc/Cgo+IENoZWVycywKPiAKPiBEYXZlLgoKCi0tIApBcmthZGl1c3ogTWnF
m2tpZXdpY3osIGFyZWttIC8gbWF2ZW4ucGwKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6
Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
