Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAR1IXPO248504 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 19:18:33 -0600
Received: from mail-ea0-f181.google.com (mail-ea0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	xUY7VBW5dHXSq1vw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 17:20:48 -0800 (PST)
Received: by mail-ea0-f181.google.com with SMTP id k14so3736644eaa.26
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 17:20:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121126145559.GK31891@thunk.org>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
	<alpine.LFD.2.00.1211261442490.18234@localhost>
	<20121126145559.GK31891@thunk.org>
Date: Tue, 27 Nov 2012 09:20:47 +0800
Message-ID: <CAPxxNQmgOmEzkmzL7Tei4KAxaP49yx1fmhNgxvwaFNiYVosGtA@mail.gmail.com>
Subject: Re: How to run xfstests against multipath disks on SuSE?
From: Ryan Wang <openspace.wang@gmail.com>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

MjAxMi8xMS8yNiBUaGVvZG9yZSBUcydvIDx0eXRzb0BtaXQuZWR1PjoKPiBPbiBNb24sIE5vdiAy
NiwgMjAxMiBhdCAwMjo0Mzo0MFBNICswMTAwLCBMdWvDocWhIEN6ZXJuZXIgd3JvdGU6Cj4+ID4g
VGhlIEkgY2hlY2tlZCB0aGUgc2NyaXB0IGNvbW1vbi5yYywgYW5kIGZvdW5kIHRoYXQgaXQgdXNl
cwo+PiA+IGRmIHRvIGRldGVybWluZSB0aGUgZmlsZXN5c3RlbSB0eXBlIGFuZCBpdCB1c2VzIHRo
ZSByZWFscGF0aAo+PiA+ICIvZGV2L2RtLTAiIGluc3RlYWQgb2YgIi9kZXYvbWFwcGVyL21wYXRo
YSIsIHdoaWxlIGRmIGFsd2F5cwo+PiA+IHNob3dzICJkZXZ0bXBmcyIgaW5zdGVhZCBvZiAiZXh0
NCIgZm9yIC9kZXYvZG0tMC4KPj4gPgo+PiA+IEkgcnVuICJtb3VudCIgYW5kIGZvdW5kIHRoYXQg
ZGV2dG1wZnMgaXMgbW91bnQgb24gL2Rldi8gb24gb3BlbnN1c2UKPj4gPiAqKipieSBkZWZhdWx0
KioqLiBFdmVuIHRob3VnaCAgSSBydW4gIm1vdW50IC10IGJ0cmZzIC9kZXYvZG0tMCAvc29tZWRp
ciIsCj4+ID4gZGYgc3RpbGwgc2hvd2VkIGRldnRtcGZzLgo+PiA+Cj4+ID4gQW55IGlkZWFzIHRv
IGtpY2sgb2ZmIHRoZSB4ZnN0ZXN0cz8KPgo+IEF0IGxlYXN0IHdpdGggdGhlIGRmIHdoaWNoIHNo
aXBzIHdpdGggRGViaWFuIFRlc3RpbmcsIGRmIHdpbGwgZGlzcGxheQo+IHRoZSBmaWxlIHN5c3Rl
bSBpbiB1c2UgaWYgaXQgbWF0Y2hlcyB0aGUgZGV2aWNlIG5hbWUgd2hpY2ggaXMKPiAvZXRjL210
YWIuICBJdCBsb29rcyB0aGUgaXNzdWUgaXMgdGhhdCBtb3VudCBpcyBjYW5vbmljYWxpemluZyB0
aGUKPiBkZXZpY2UgbmFtZSB0byBiZSB0aGUgaHVtYW4gZnJpZW5kbHkgdmVyc2lvbjoKPgo+ICMg
bHMgLWwgL2Rldi9tYXBwZXIvY2xvc3VyZS1iaWdzY3JhdGNoCj4gMCBscnd4cnd4cnd4IDEgcm9v
dCByb290IDcgTm92IDE2IDE1OjE1IC9kZXYvbWFwcGVyL2Nsb3N1cmUtYmlnc2NyYXRjaCAtPiAu
Li9kbS03Cj4gPHR5dHNvLnJvb3RAY2xvc3VyZT4gey9ob21lL3R5dHNvL2Jpbn0sIGxldmVsIDIK
PiAjIG1vdW50IC9kZXYvZG0tNyAvdTIKPiAjIGRmIC91Mgo+IEZpbGVzeXN0ZW0gICAgICAgICAg
ICAgICAgICAgICAxSy1ibG9ja3MgICBVc2VkIEF2YWlsYWJsZSBVc2UlIE1vdW50ZWQgb24KPiAv
ZGV2L21hcHBlci9jbG9zdXJlLWJpZ3NjcmF0Y2ggIDUyNDAzMjAwIDIyNDc3MiAgNTIxNzg0Mjgg
ICAxJSAvdTIKPiAjIGdyZXAgL3UyIC9ldGMvbXRhYgo+IC9kZXYvbWFwcGVyL2Nsb3N1cmUtYmln
c2NyYXRjaCAvdTIgeGZzIHJ3LHJlbGF0aW1lLGF0dHIyLGlub2RlNjQsbm9xdW90YSAwIDAKPgo+
IFNvIHRoZSBzaW1wbGVzdCBzb2x1dGlvbiBpcyB0byBqdXN0IHVzZSAvZGV2L21hcHBlci9tcGF0
aGEgaW5zdGVhZCBvZgo+IGluc2lzdGluZyBvbiB1c2luZyAvZGV2L2RtLTAuICBUaGF0J3Mgd2hh
dCBJIGRvLi4uLgoKSW4geGZzdGVzdHMvY29tbW9uLnJjLCBpdCB3aWxsIHVzZSByZWFscGF0aCB0
byBvYnRhaW4gL2Rldi9kbS0wLCBldmVuIGlmIHlvdQpzcGVjaWZpZWQgL2Rldi9tYXBwZXIvbXBh
dGhhLgpNeSBwcm9ibGVtIGlzIGluIFN1U0UsIHRoZSBkZXZ0bXBmcyBpcyBtb3VudGVkIG9uIC9k
ZXYgYnkgZGVmYXVsdCwgc2VlbXMKdXNlZCBieSB1ZGV2LiBBbmQgZGYgcmVwb3J0cyBkZXZ0bXBm
cyBvbiAvZGV2L2RtLTAsIGluc3RlYWQgb2YgZXh0NC4KCj4KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtIFRlZAo+CgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dp
LmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
