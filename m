Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64DB87FB4
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 16:26:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5643F304066
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:26:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tcKFnmEnxTCxsHiU for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 14:26:39 -0700 (PDT)
Date: Fri, 4 Apr 2014 08:26:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] fsx: Add fallocate collapse range operation
Message-ID: <20140403212637.GP17603@dastard>
References: <1396452800-25775-1-git-send-email-lczerner@redhat.com>
	<alpine.LFD.2.00.1404021752340.2169@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404021752340.2169@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gV2VkLCBBcHIgMDIsIDIwMTQgYXQgMDU6NTU6MDdQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IE9uIFdlZCwgMiBBcHIgMjAxNCwgTHVrYXMgQ3plcm5lciB3cm90ZToKPiAKPiA+
IERhdGU6IFdlZCwgIDIgQXByIDIwMTQgMTc6MzM6MTkgKzAyMDAKPiA+IEZyb206IEx1a2FzIEN6
ZXJuZXIgPGxjemVybmVyQHJlZGhhdC5jb20+Cj4gPiBUbzogeGZzQG9zcy5zZ2kuY29tCj4gPiBD
YzogbGludXgtZXh0NEB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwu
b3JnLAo+ID4gICAgIEx1a2FzIEN6ZXJuZXIgPGxjemVybmVyQHJlZGhhdC5jb20+Cj4gPiBTdWJq
ZWN0OiBbUEFUQ0ggMS8yXSBmc3g6IEFkZCBmYWxsb2NhdGUgY29sbGFwc2UgcmFuZ2Ugb3BlcmF0
aW9uCj4gPiAKPiA+IFRoaXMgY29tbWl0IGFkZHMgZmFsbG9jYXRlIEZBTExPQ19GTF9DT0xMQVBT
RV9SQU5HRSBzdXBwb3J0IGZvciBmc3guCj4gCj4gQnR3LCB0aGlzIGFjdHVhbGx5IG1ha2VzIHRo
ZSBmc3ggZmFpbCBvbiBleHQ0IGFuZCB4ZnMgYWZ0ZXIgYSB3aGlsZS4KPiBJIHdhcyB0cnlpbmcg
dG8gZmluZCBhIHByb2JsZW0gaW4gZnN4IGl0c2VsZiBidXQgSSB0aGluayBpdCBpcwo+IGFjdHVh
bGx5IG9rLiBUaGF0IG1lYW5zIHRoYXQgd2UgY291bGQgcG9zc2libHkgaGF2ZSBidWdzIGluIGV4
dDQgYW5kCj4geGZzIGNvbGxhcHNlIHJhbmdlIGltcGxlbWVudGF0aW9uLiBNb3JlIGV5ZXMgYXJl
IG5lZWRlZCBvbiB0aGlzIQoKTm8gc3VycHJpc2UsIHJlYWxseS4gQXMgaXQgaXMsIHlvdXIgcHJl
dmlvdXMgWkVST19SQU5HRSBhZGRpdGlvbnMKY2F1c2VkIHByb2JsZW1zIGZvciBYRlMsIGFuZCB0
aG9zZSBhcmUgbW9zdGx5IGZpeGVkIGluIHRoZSA2IHBhdGNoCnNlcmllcyBJIHNlbnQgYmVmb3Jl
IExTRk1NLiAgSGVuY2UgSSB3b3VsZG4ndCBiZSBzdXJwcmlzZWQgaWYgdGhhdCdzCndoYXQgeW91
IGFyZSBzZWVpbmcgKG9uIFhGcywgYXQgbGVhc3QpIGFuZCBpdCdzIG5vdCBhY3R1YWxseQpDT0xM
QVBTRV9SQU5HRSB0aGF0IGlzIGNhdXNpbmcgcHJvYmxlbXMuLi4KCkNoZWVycywKCkRhdmUuCi0t
IApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
