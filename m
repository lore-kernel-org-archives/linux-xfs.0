Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G0KeTK214729 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 18:20:40 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EBcwaMcb7zgUdruG for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 16:20:38 -0800 (PST)
Date: Thu, 16 Feb 2012 11:20:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount recovery taking quite long time
Message-ID: <20120216002036.GV14132@dastard>
References: <201202151225.13673.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201202151225.13673.arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gV2VkLCBGZWIgMTUsIDIwMTIgYXQgMTI6MjU6MTNQTSArMDEwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IAo+IDMuMC4xNyBrZXJuZWwsIDgwMEdCIGZzLCBmcmVzaCBib290LCBt
b3VudCBvZiAvaG9tZSBhdCBib290IChzbyBubyBkYWVtb25zIAo+IHJ1bm5pbmcgeWV0KSwgIGFu
ZCA6Cj4gCj4gWyAgIDE3Ljc2ODQ1OV0gWEZTIChtZDMpOiBTdGFydGluZyByZWNvdmVyeSAobG9n
ZGV2OiBpbnRlcm5hbCkKPiBbICA4NzIuNDI3MDYxXSBYRlMgKG1kMyk6IEVuZGluZyByZWNvdmVy
eSAobG9nZGV2OiBpbnRlcm5hbCkKPiAKPiBUaGF0IG1vdW50IHdhcyBhZnRlciAodW5mb3J0dW5h
dGUpIG1hY2hpbmUgcmVzZXQgd2hpbGUgaXQgd2FzIGRvaW5nIG1hbnkgCj4gdGhpbmdzLgo+IAo+
IFRoZSBxdWVzdGlvbiBpcyAtIHdoYXQgY291bGQgdGFrZSBzbyBsb25nIGluIGhlcmU/CgpIb3cg
YmlnIGlzIHRoZSBsb2c/IEl0J3MgZW50aXJlbHkgcG9zc2libGUgdGhhdCB5b3VyIGxvZyBpcyBm
dWxsIG9mCm1vZGlmaWVkIGlub2RlcyBhbmQgc28gaXQncyBoYXZpbmcgdG8gcmVhZCB0aGVtIGFs
bCBpbiBmaXJzdC4gQQptb2RpZmllZCBpbm9kZSBvbmx5IHRha2VzIGEgY291cGxlIG9mIGh1bmRy
ZWQgYnl0ZXMgaW4gdGhlIGxvZywgc28KZXZlbiBpZiB5b3UgaGF2ZSBhIDEwME1CIGxvZywgeW91
IGNhbiBzdGlsbCBoYXZlIGEgY291cGxlIG9mIG1pbGxpb24KZGlydHkgaW5vZGVzIGluIHRoZSBs
b2cgdGhhdCBoYXZlIHRvIGJlIHJlYWQgYW5kIHJlcGxheWVkLgoKVGhpcyBoYXMgYmVlbiBrbm93
biBmb3Igc29tZSB0aW1lLCBidXQgdGhlIHdvcnNlIGNhc2UgKGFyb3VuZAoxNSBtaW51dGVzIC0g
d2hhdCB5b3UndmUgc2VlbiBoZXJlIC0gaXMgbW9zdCBJJ3ZlIHNlZW4gb3IgaGVhcmQKcmVwb3J0
ZWQpIGlzIHJlbGF0aXZlbHkgcmFyZSBzbyB0aGVyZSBoYXNuJ3QgYmVlbiBhbnkgdXJnZW5jeSB0
bwpzb2x2ZSB0aGlzOgoKaHR0cDovL3hmcy5vcmcvaW5kZXgucGhwL0ltcHJvdmluZ19NZXRhZGF0
YV9QZXJmb3JtYW5jZV9CeV9SZWR1Y2luZ19Kb3VybmFsX092ZXJoZWFkI1JlZHVjaW5nX1JlY292
ZXJ5X1RpbWUKCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0
LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
