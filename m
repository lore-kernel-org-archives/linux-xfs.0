Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQErmjx206475 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 08:53:48 -0600
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id jHek5CY9WuB2qP5j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 06:56:03 -0800 (PST)
Date: Mon, 26 Nov 2012 09:55:59 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: How to run xfstests against multipath disks on SuSE?
Message-ID: <20121126145559.GK31891@thunk.org>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
	<alpine.LFD.2.00.1211261442490.18234@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211261442490.18234@localhost>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Ryan Wang <openspace.wang@gmail.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gTW9uLCBOb3YgMjYsIDIwMTIgYXQgMDI6NDM6NDBQTSArMDEwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+ID4gVGhlIEkgY2hlY2tlZCB0aGUgc2NyaXB0IGNvbW1vbi5yYywgYW5kIGZvdW5k
IHRoYXQgaXQgdXNlcwo+ID4gZGYgdG8gZGV0ZXJtaW5lIHRoZSBmaWxlc3lzdGVtIHR5cGUgYW5k
IGl0IHVzZXMgdGhlIHJlYWxwYXRoCj4gPiAiL2Rldi9kbS0wIiBpbnN0ZWFkIG9mICIvZGV2L21h
cHBlci9tcGF0aGEiLCB3aGlsZSBkZiBhbHdheXMKPiA+IHNob3dzICJkZXZ0bXBmcyIgaW5zdGVh
ZCBvZiAiZXh0NCIgZm9yIC9kZXYvZG0tMC4KPiA+IAo+ID4gSSBydW4gIm1vdW50IiBhbmQgZm91
bmQgdGhhdCBkZXZ0bXBmcyBpcyBtb3VudCBvbiAvZGV2LyBvbiBvcGVuc3VzZQo+ID4gKioqYnkg
ZGVmYXVsdCoqKi4gRXZlbiB0aG91Z2ggIEkgcnVuICJtb3VudCAtdCBidHJmcyAvZGV2L2RtLTAg
L3NvbWVkaXIiLAo+ID4gZGYgc3RpbGwgc2hvd2VkIGRldnRtcGZzLgo+ID4gCj4gPiBBbnkgaWRl
YXMgdG8ga2ljayBvZmYgdGhlIHhmc3Rlc3RzPwoKQXQgbGVhc3Qgd2l0aCB0aGUgZGYgd2hpY2gg
c2hpcHMgd2l0aCBEZWJpYW4gVGVzdGluZywgZGYgd2lsbCBkaXNwbGF5CnRoZSBmaWxlIHN5c3Rl
bSBpbiB1c2UgaWYgaXQgbWF0Y2hlcyB0aGUgZGV2aWNlIG5hbWUgd2hpY2ggaXMKL2V0Yy9tdGFi
LiAgSXQgbG9va3MgdGhlIGlzc3VlIGlzIHRoYXQgbW91bnQgaXMgY2Fub25pY2FsaXppbmcgdGhl
CmRldmljZSBuYW1lIHRvIGJlIHRoZSBodW1hbiBmcmllbmRseSB2ZXJzaW9uOgoKIyBscyAtbCAv
ZGV2L21hcHBlci9jbG9zdXJlLWJpZ3NjcmF0Y2ggCjAgbHJ3eHJ3eHJ3eCAxIHJvb3Qgcm9vdCA3
IE5vdiAxNiAxNToxNSAvZGV2L21hcHBlci9jbG9zdXJlLWJpZ3NjcmF0Y2ggLT4gLi4vZG0tNwo8
dHl0c28ucm9vdEBjbG9zdXJlPiB7L2hvbWUvdHl0c28vYmlufSwgbGV2ZWwgMiAgCiMgbW91bnQg
L2Rldi9kbS03IC91MgojIGRmIC91MgpGaWxlc3lzdGVtICAgICAgICAgICAgICAgICAgICAgMUst
YmxvY2tzICAgVXNlZCBBdmFpbGFibGUgVXNlJSBNb3VudGVkIG9uCi9kZXYvbWFwcGVyL2Nsb3N1
cmUtYmlnc2NyYXRjaCAgNTI0MDMyMDAgMjI0NzcyICA1MjE3ODQyOCAgIDElIC91MgojIGdyZXAg
L3UyIC9ldGMvbXRhYgovZGV2L21hcHBlci9jbG9zdXJlLWJpZ3NjcmF0Y2ggL3UyIHhmcyBydyxy
ZWxhdGltZSxhdHRyMixpbm9kZTY0LG5vcXVvdGEgMCAwCgpTbyB0aGUgc2ltcGxlc3Qgc29sdXRp
b24gaXMgdG8ganVzdCB1c2UgL2Rldi9tYXBwZXIvbXBhdGhhIGluc3RlYWQgb2YKaW5zaXN0aW5n
IG9uIHVzaW5nIC9kZXYvZG0tMC4gIFRoYXQncyB3aGF0IEkgZG8uLi4uCgoJCQkJCQktIFRlZAoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxp
bmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGlu
Zm8veGZzCg==
