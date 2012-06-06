Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q56F02O9230223 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 10:00:02 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id Bbr97z37RaQee6vF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Jun 2012 08:00:00 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1ScHiK-0004Aj-2m
	for xfs@oss.sgi.com; Wed, 06 Jun 2012 08:00:00 -0700
Message-ID: <33970511.post@talk.nabble.com>
Date: Wed, 6 Jun 2012 08:00:00 -0700 (PDT)
From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
In-Reply-To: <20120518101010.GW25351@dastard>
MIME-Version: 1.0
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
	<20120423143843.GN9541@dastard>
	<CADLDEKvFF3FvEHVtmwdWhbM58_jrCRX+Uk9vLBg1hA8sizh5BQ@mail.gmail.com>
	<20120423235840.GQ9541@dastard>
	<CADLDEKsfckBw2oVYFfaaTbpe8Ri+rYJr2e5SB7-pM0BU9nRUeA@mail.gmail.com>
	<20120424120731.GT9541@dastard>
	<CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
	<20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<loom.20120510T180646-433@post.
	gmane.org> <20120516184231.GK16099@sgi.com>
	<4FB3FA1D.6050102@canonical.com> <4FB41C1D.8000808@sgi.com>
	<20120518101010.GW25351@dastard>
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
To: xfs@oss.sgi.com

CgpEYXZlIENoaW5uZXIgd3JvdGU6Cj4gCj4gSXQgc2VlbXMgdW5saWtlbHksIGJ1dCBpZiB5b3Ug
dHVybiBvbiBrbWVtbGVhayBpdCBtaWdodCBmaW5kIGEKPiBtZW1vcnkgbGVhayBvciBvdmVyd3Jp
dGUgdGhhdCBpcyBjYXVzaW5nIHRoaXMuCj4gCgpSdW5uaW5nIGttZW1sZWFrIG9uIGEgMy4wLjAg
a2VybmVsIHJlc3VsdHMgaW4gdGhlIGZvbGxvd2luZzoKCmRtZXNnOgpbIDM4NTUuNzUxMzkzXSBY
RlMgKHNkYTIpOiB4bG9nX3ZlcmlmeV9ncmFudF90YWlsOiBzcGFjZSA+CkJCVE9CKHRhaWxfYmxv
Y2tzKQpbMjI5ODcuOTMyMzE3XSBrbWVtbGVhazogMSBuZXcgc3VzcGVjdGVkIG1lbW9yeSBsZWFr
cyAoc2VlCi9zeXMva2VybmVsL2RlYnVnL2ttZW1sZWFrKQoKa21lbWxlYWs6CnVucmVmZXJlbmNl
ZCBvYmplY3QgMHhmZmZmODgwMTU2MTJhMzQwIChzaXplIDIwOCk6CiBjb21tICJjb3B5LWZpbGVz
IiwgcGlkIDE0ODMsIGppZmZpZXMgNDMxMDU2MDI4NSAoYWdlIDE2NTcxLjY1NnMpCiBoZXggZHVt
cCAoZmlyc3QgMzIgYnl0ZXMpOgogICAgMDAgZjMgMWIgNTcgMDEgODggZmYgZmYgMDAgMDggMDAg
NTggMDEgODggZmYgZmYgIC4uLlcuLi4uLi4uWC4uLi4KICAgIGEwIGE3IDMyIGEwIGZmIGZmIGZm
IGZmIDA0IDAwIDAwIDAwIDAwIDAwIDAwIDAwICAuLjIuLi4uLi4uLi4uLi4uCiBiYWNrdHJhY2U6
CiAgICBbPGZmZmZmZmZmODE1YzYxOTY+XSBrbWVtbGVha19hbGxvYysweDI2LzB4NTAKICAgIFs8
ZmZmZmZmZmY4MTE1NDJlMz5dIGttZW1fY2FjaGVfYWxsb2MrMHgxMjMvMHgxOTAKICAgIFs8ZmZm
ZmZmZmZhMDMxMzk2Nz5dIGttZW1fem9uZV9hbGxvYysweDY3LzB4ZTAgW3hmc10KICAgIFs8ZmZm
ZmZmZmZhMDMxMzlmZD5dIGttZW1fem9uZV96YWxsb2MrMHgxZC8weDUwIFt4ZnNdCiAgICBbPGZm
ZmZmZmZmYTAyYjAzM2Y+XSB4ZnNfYWxsb2NidF9pbml0X2N1cnNvcisweGRmLzB4MTMwIFt4ZnNd
CiAgICBbPGZmZmZmZmZmYTAyYWRiNGM+XSB4ZnNfYWxsb2NfYWdfdmV4dGVudF9uZWFyKzB4NmMv
MHhkODAgW3hmc10KICAgIFs8ZmZmZmZmZmZhMDJhZWE4OD5dIHhmc19hbGxvY19hZ192ZXh0ZW50
KzB4MjI4LzB4MjkwIFt4ZnNdCiAgICBbPGZmZmZmZmZmYTAyYWY3ZDk+XSB4ZnNfYWxsb2NfdmV4
dGVudCsweDY0OS8weDhjMCBbeGZzXQogICAgWzxmZmZmZmZmZmEwMmJjZmM2Pl0geGZzX2JtYXBf
YnRhbGxvYysweDI4Ni8weDdjMCBbeGZzXQogICAgWzxmZmZmZmZmZmEwMmJkNTIxPl0geGZzX2Jt
YXBfYWxsb2MrMHgyMS8weDQwIFt4ZnNdCiAgICBbPGZmZmZmZmZmYTAyYzZiYTM+XSB4ZnNfYm1h
cGkrMHhkYzMvMHgxOTUwIFt4ZnNdCiAgICBbPGZmZmZmZmZmYTAyZjUwNTk+XSB4ZnNfaW9tYXBf
d3JpdGVfYWxsb2NhdGUrMHgxNzkvMHgzNDAgW3hmc10KICAgIFs8ZmZmZmZmZmZhMDMxNDdkNT5d
IHhmc19tYXBfYmxvY2tzKzB4MjE1LzB4MzgwIFt4ZnNdCiAgICBbPGZmZmZmZmZmYTAzMTU3OTI+
XSB4ZnNfdm1fd3JpdGVwYWdlKzB4MWIyLzB4NTEwIFt4ZnNdCiAgICBbPGZmZmZmZmZmODExMTQy
ZTc+XSBfX3dyaXRlcGFnZSsweDE3LzB4NDAKICAgIFs8ZmZmZmZmZmY4MTExNDg1ZD5dIHdyaXRl
X2NhY2hlX3BhZ2VzKzB4MjBkLzB4NDYwCgphbmFseXNpczoKICAgIEkgdHVybmVkIG9uIGttZW1s
ZWFrLCBmdW5jdGlvbiB0cmFjaW5nLCBhbmQgeGZzIGRlYnVnZ2luZyBpbiB0aGUgYnVpbGQKaW4g
d2hpY2ggSSByYW4gdGhpcy4gU28gZmFyIEnigJl2ZSBiZWVuIGFibGUgdG8gcnVuIHRoZSBjb3B5
LWZpbGVzIHNjcmlwdCBmb3IKYWJvdXQgMjQgaHJzICB3aXRob3V0IGZhaWx1cmUuIEnigJltIG5v
dCBzdXJlIGlmIHRoaXMgaXMgYmVjYXVzZSBhbGwgdGhlc2UKZmVhdHVyZXMgYXJlIHR1cm5lZCBv
biBhbmQgaXQgaGFzIHNsb3dlZCBzb21ldGhpbmcgZG93biAoc28gaXQgdGFrZXMgbG9uZ2VyCnRv
IHJlcHJvZHVjZSksIG9yIGlmIHRoZSBkZWJ1Z2dpbmcgY29kZSBpcyBjaGFuZ2luZyB0aGUgYmVo
YXZpb3IuIEnigJltIG5vdApzdXJlIGlmIHRoaXMgYmFja3RyYWNlIGlzIHZhbGlkLCBzbyBJ4oCZ
bSBhdHRhY2hpbmcgYW4gYW5ub3RhdGVkIG9iamR1bXAgb2YgbXkKeGZzIG1vZHVsZS4KCi0tY2hy
aXMgaiBhcmdlcwoKaHR0cDovL29sZC5uYWJibGUuY29tL2ZpbGUvcDMzOTcwNTExL3hmc19vYmpk
dW1wXzMuMC50eHQudGFyLmJ6Mgp4ZnNfb2JqZHVtcF8zLjAudHh0LnRhci5iejIgCi0tIApWaWV3
IHRoaXMgbWVzc2FnZSBpbiBjb250ZXh0OiBodHRwOi8vb2xkLm5hYmJsZS5jb20vU3RpbGwtc2Vl
aW5nLWhhbmdzLWluLXhsb2dfZ3JhbnRfbG9nX3NwYWNlLXRwMzM3MzI4ODZwMzM5NzA1MTEuaHRt
bApTZW50IGZyb20gdGhlIFhmcyAtIEdlbmVyYWwgbWFpbGluZyBsaXN0IGFyY2hpdmUgYXQgTmFi
YmxlLmNvbS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWls
bWFuL2xpc3RpbmZvL3hmcwo=
