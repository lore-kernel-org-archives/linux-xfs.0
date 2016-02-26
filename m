Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97F557CB9
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2016 01:31:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 660B6304039
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 23:31:38 -0800 (PST)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id WZpAyUGM8m9saeWa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Feb 2016 23:31:35 -0800 (PST)
Date: Fri, 26 Feb 2016 02:31:34 -0500 (EST)
From: Prasanna Kumar Kalever <pkalever@redhat.com>
Message-ID: <805263868.53795563.1456471894885.JavaMail.zimbra@redhat.com>
In-Reply-To: <957291997.53773945.1456468677495.JavaMail.zimbra@redhat.com>
References: <957291997.53773945.1456468677495.JavaMail.zimbra@redhat.com>
Subject: Re: How to copy files with preserving reflinks ?
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
To: xfs@oss.sgi.com
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>

T24gRnJpZGF5LCBGZWJydWFyeSAyNiwgMjAxNiAxMjowNzo1NyBQTSwgUHJhc2FubmEgS3VtYXIg
S2FsZXZlciB3cm90ZToKPiBIaSwKPiAKPiBJIGhhdmUgYSBWTSBmaWxlIHdpdGggcmVmbGlua3Mg
dG8gaXQsIHRoZSByZWZsaW5rcyB3ZXJlIHRha2VuIGV2ZXJ5IG5pZ2h0Lgo+IAo+IE15IHF1ZXN0
aW9uIGlzIGhvdyB0byBjb3B5L21pZ3JhdGUgYWxsIHRoZXNlIGZpbGUgdG8gYSBkaWZmZXJlbnQg
eGZzCj4gcGFydGl0aW9uICh3aGljaCBhbHNvIGhhdmUgcmVmbGluayBlbmFibGVkKSB3aXRob3V0
IGxvb3NpbmcgdGhlIHJlZmxpbmtzCj4gcHJvcGVydHksIGVsc2UgbWF5IGxlYWQgdG8gY29weSBh
bGwgdGhlIHNoYXJlZCBibG9ja3MgcGVyIGZpbGUgd2hpY2ggd2lsbAo+IGNvc3QgbGFyZ2UgZGlz
ayBzcGFjZS4KPiAKPiBJIGhhdmUgdHJpZWQgdG8gY29weSB0aGVtIHVzaW5nIHJzeW5jIGFzIGJl
bG93Ogo+IAo+IE9uIFBhcnRpdGlvbiAxOgo+IAo+IEFjdHVhbEZpbGUuaW1nIC0tIFsxXSBBY3Rh
dWwgU2l6ZSAxMEdCICsgWzJdIEFwcGVuZCAyR0IgKyBbM10gQXBwZW5kIDFHQgo+IFJlZmxpbmtD
b3B5MSAgIC0tIFsxXSBBY3R1YWwgU2l6ZSAgMCAgLS0gU2hhcmVkIGJsb2NrcyAxMEdCCj4gUmVm
bGlua0NvcHkyICAgLS0gWzJdIEFjdHVhbCBTaXplICAwICAtLSBTaGFyZWQgYmxvY2tzIDEyR0IK
PiAKPiAKPiBJIGhhdmUgZmlyc3QgcnN5bmMgdGhlIGZpbGVzIGludG8gUGFydGl0aW9uIDIgYXMg
YmVsb3c6Cj4gCj4gIyBjZCBQQVJUSVRJT04yCj4gCj4gIyByc3luYyAvUEFSVElUSU9OMS9SZWZs
aW5rQ29weTEgQWN0dWFsRmlsZS5pbWcKPiAjIGR1IC1zaCBBY3R1YWxGaWxlLmltZwo+IDEwR0IK
PiAjIGNwIC0tcmVmbGluaz1hbHdheXMgQWN0dWFsRmlsZS5pbWcKPiAKPiAjIHJzeW5jIC9QQVJU
SVRJT04xL1JlZmxpbmtDb3B5MiBBY3R1YWxGaWxlLmltZwo+ICMgZHUgLXNoIEFjdHVhbEZpbGUu
aW1nCj4gMTJHQgo+ICMgY3AgLS1yZWZsaW5rPWFsd2F5cyBBY3R1YWxGaWxlLmltZwo+IAo+ICMg
cnN5bmMgIC9QQVJUSVRJT04xL0FjdHVhbEZpbGUuaW1nIEFjdHVhbEZpbGUuaW1nCj4gCj4gQnV0
IHRoZSBzaXplIHVzZWQgYnkgcGFydGl0aW9uIHdhcyAzNUdCICh2ZXJpZmllZCB1c2luZyBkZiAt
aCkgaW5zdGVhZCBvZgo+IDEzR0IKCkh1cnJleXl5ISEhIS4uLi4gZXJyLi4KV2hpbGUgZXhwZXJp
bWVudGluZyB3aXRoIHJzeW5jIGZvdW5kICItLW5vLXdob2xlLWZpbGUiICYmICItLWlucGxhY2Ui
ICwgd2l0aCB0aGVzZSBvcHRpb25zIGl0IHNlZW1zIHRvIGJlIHdvcmtpbmcKCgojcnN5bmMgLS1u
by13aG9sZS1maWxlIC0taW5wbGFjZSAtLWh1bWFuLXJlYWRhYmxlIC0tc3RhdHMgcmVmbGlua3Mv
ZmlsZSAgLi4vbW91bnQyL3JlZmxpbmtzL2ZpbGUgCgpOdW1iZXIgb2YgZmlsZXM6IDEgKHJlZzog
MSkKTnVtYmVyIG9mIGNyZWF0ZWQgZmlsZXM6IDAKTnVtYmVyIG9mIGRlbGV0ZWQgZmlsZXM6IDAK
TnVtYmVyIG9mIHJlZ3VsYXIgZmlsZXMgdHJhbnNmZXJyZWQ6IDEKVG90YWwgZmlsZSBzaXplOiA2
OS42M00gYnl0ZXMKVG90YWwgdHJhbnNmZXJyZWQgZmlsZSBzaXplOiA2OS42M00gYnl0ZXMKTGl0
ZXJhbCBkYXRhOiA4LjIwTSBieXRlcwpNYXRjaGVkIGRhdGE6IDYxLjQzTSBieXRlcwpGaWxlIGxp
c3Qgc2l6ZTogMApGaWxlIGxpc3QgZ2VuZXJhdGlvbiB0aW1lOiAwLjAwMSBzZWNvbmRzCkZpbGUg
bGlzdCB0cmFuc2ZlciB0aW1lOiAwLjAwMCBzZWNvbmRzClRvdGFsIGJ5dGVzIHNlbnQ6IDguMjNN
ClRvdGFsIGJ5dGVzIHJlY2VpdmVkOiA1NC45NUsKCkJ1dCBJIHN0aWxsIG5lZWQgdG8gcmVwZWF0
IHRoZSBwcm9jZXNzIG9mIHRha2luZyByZWZsaW5rcyBtdWx0aXBsZSB0aW1lcyBvbiBuZXcgcGFy
dGl0aW9uIChwZXIgZmlsZSkuCgpEaWQgbm90IGhhZCBsdWNrIHRvIGZpZ3VyZS1vdXQgcmVmbGlu
ayByZWxhdGVkIHRvb2xzIChkdSwgbHMgLi4uKQoKLVByYXNhbm5hCgo+IAo+IAo+IAo+IEFsc28s
IHdoZXJlIGNhbiBJIGZpbmQgcmVmbGluayByZWxhdGVkIHRvb2xzID8KPiAKPiAKPiBUaGFua3Ms
Cj4gLVByYXNhbm5hIOKAiwo+IAo+IAo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
