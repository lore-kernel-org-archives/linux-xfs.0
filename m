Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AEWmVC162436 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 09:32:48 -0500
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	yOJZQAfsT7wHtEAm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 07:32:47 -0700 (PDT)
Received: by iagk10 with SMTP id k10so8362441iag.26
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 07:32:46 -0700 (PDT)
Message-ID: <4F844474.3010005@gmail.com>
Date: Tue, 10 Apr 2012 10:32:20 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20120405213740.GA22824@infradead.org>
	<CAAxjCExBcaB6J-u7ivZKWnKiF7oP10JRxzKzQNRuppHkTE2Tzw@mail.gmail.com>
	<201204072057.38286.Martin@lichtvoll.de>
	<CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
In-Reply-To: <CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

T24gMDQvMTAvMjAxMiAxMDowMiBBTSwgU3RlZmFuIFJpbmcgd3JvdGU6Cj4+IEFuZCBpcyBYRlMg
YWxpZ25lZCB0byB0aGUgUkFJRCA2Pwo+Pgo+PiBXaGF0IGRvZXMgeGZzX2luZm8gZGlzcGxheSBv
biBpdD8KPgo+IFllcywgaXTigJlzIGFsaWduZWQuCj4KPiBtZXRhLWRhdGE9L2Rldi9tYXBwZXIv
dmdfZGF0YS1sdmhvbWUgaXNpemU9MjU2ICAgIGFnY291bnQ9NCwKPiBhZ3NpemU9NzMyMzM2NTYg
Ymxrcwo+ICAgICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBzZWN0c3o9NTEyICAgYXR0
cj0yCj4gZGF0YSAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgYnNpemU9NDA5NiAgIGJsb2Nr
cz0yOTI5MzQ2MjQsIGltYXhwY3Q9NQo+ICAgICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAg
ICBzdW5pdD04ICAgICAgc3dpZHRoPTMyIGJsa3MKPiBuYW1pbmcgICA9dmVyc2lvbiAyICAgICAg
ICAgICAgICBic2l6ZT00MDk2ICAgYXNjaWktY2k9MAo+IGxvZyAgICAgID1pbnRlcm5hbCAgICAg
ICAgICAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9MTQzMDQwLCB2ZXJzaW9uPTIKPiAgICAgICAg
ICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIHN1bml0PTggYmxrcywgbGF6
eS1jb3VudD0xCj4gcmVhbHRpbWUgPW5vbmUgICAgICAgICAgICAgICAgICAgZXh0c3o9NDA5NiAg
IGJsb2Nrcz0wLCBydGV4dGVudHM9MAo+Cj4gSSBjaGFuZ2VkIHRoZSBzdHJpcGUgc2l6ZSB0byAz
MmtiIGluIHRoZSBtZWFudGltZS4gVGhpcyB3YXksIGl0Cj4gcGVyZm9ybXMgc2xpZ2h0bHkgYmV0
dGVyLgoKdHJ5IDEyOGsgdG8gNTEyayBmb3Igc3RyaXBlIHNpemUuICBBbmQgdHJ5IHRvIGluY3Jl
YXNlIHlvdXIgYWdjb3VudCBieSAKKG5lYXJseSkgYW4gb3JkZXIgb2YgbWFnbml0dWRlLgoKCi0t
IApKb3NlcGggTGFuZG1hbiwgUGguRApGb3VuZGVyIGFuZCBDRU8KU2NhbGFibGUgSW5mb3JtYXRp
Y3MgSW5jLgplbWFpbDogbGFuZG1hbkBzY2FsYWJsZWluZm9ybWF0aWNzLmNvbQp3ZWIgIDogaHR0
cDovL3NjYWxhYmxlaW5mb3JtYXRpY3MuY29tCiAgICAgICAgaHR0cDovL3NjYWxhYmxlaW5mb3Jt
YXRpY3MuY29tL3NpY2x1c3RlcgpwaG9uZTogKzEgNzM0IDc4NiA4NDIzIHgxMjEKZmF4ICA6ICsx
IDg2NiA4ODggMzExMgpjZWxsIDogKzEgNzM0IDYxMiA0NjE1CgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dp
LmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
