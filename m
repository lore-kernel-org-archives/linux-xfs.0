Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0F797F50
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 18:28:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 946278F804C
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 16:28:21 -0700 (PDT)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166]) by
	cuda.sgi.com with ESMTP id P1BIgoPMA5qo0QOy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 May 2015 16:28:18 -0700 (PDT)
Message-ID: <555A7585.6000003@foxmail.com>
Date: Tue, 19 May 2015 07:28:05 +0800
From: Wang Sheng-Hui <shhuiw@foxmail.com>
MIME-Version: 1.0
Subject: Re: xfsprogs/mkfs: what's the relationship between max trans res
	and min log size
References: <555987A2.3050604@foxmail.com>
	<20150518133439.GA43596@bfoster.bfoster>
In-Reply-To: <20150518133439.GA43596@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs <xfs@oss.sgi.com>

CgpPbiAyMDE15bm0MDXmnIgxOOaXpSAyMTozNCwgQnJpYW4gRm9zdGVyIHdyb3RlOgo+IE9uIE1v
biwgTWF5IDE4LCAyMDE1IGF0IDAyOjMzOjA2UE0gKzA4MDAsIFdhbmcgU2hlbmctSHVpIHdyb3Rl
Ogo+PiBIaSBndXlzLAo+Pgo+Pgo+PiBJbiBtYXh0cnJlcy5jL21heF90cmFuc19yZXMsIGl0IGNh
bGxzIHhmc19sb2dfY2FsY19taW5pbXVtX3NpemUgdG8gY29tcHV0ZSB0aGUKPj4gICAgICAgICAg
ICAgICBtYXhpbXVtIHRyYW5zYWN0aW9uIHJlc2VydmF0aW9uCj4+Cj4+IEJ1dCBmb3IgeGZzX2xv
Z19jYWxjX21pbmltdW1fc2l6ZSwgaXQncyB1c2VkIHRvIGNhbGN1bGF0ZSB0aGUKPj4gICAgICAg
ICAgICAgICBtaW5pbXVtIHZhbGlkIGxvZyBzaXplCj4+Cj4+Cj4+IFRoZSBuYW1pbmcgbWF4L21p
bmltdW0gc2VlbXMgY29uZnVzaW5nLgo+Pgo+PiBXaHkgYXJlIHRoZXkgbmFtZWQgaW4gc3VjaCB3
YXk/IFdoYXQncyB0aGUgcmVsYXRpb25zaGlwIGJldHdlZW4gbWF4IHRyYW5zIHJlcwo+PiBhbmQg
bWluaW11biBsb2cgc2l6ZSwgKG1heCB0cmFucyByZXMpIDw9IChtaW5pbXVuIGxvZyBzaXplKT8K
Pj4KPj4KPj4gQW55IGV4cGxhbmF0aW9ucyBhcmUgd2VsY29tZWQhCj4+Cj4gCj4+RnJvbSB0aGUg
Y29tbWVudCBpbiB4ZnNfbG9nX2NhbGNfbWluaW11bV9zaXplKCk6Cj4gCj4gICAgICAgICAvKgo+
ICAgICAgICAgICogVHdvIGZhY3RvcnMgc2hvdWxkIGJlIHRha2VuIGludG8gYWNjb3VudCBmb3Ig
Y2FsY3VsYXRpbmcgdGhlIG1pbmltdW0KPiAgICAgICAgICAqIGxvZyBzcGFjZS4KPiAgICAgICAg
ICAqIDEpIFRoZSBmdW5kYW1lbnRhbCBsaW1pdGF0aW9uIGlzIHRoYXQgbm8gc2luZ2xlIHRyYW5z
YWN0aW9uIGNhbiBiZQo+ICAgICAgICAgICogICAgbGFyZ2VyIHRoYW4gaGFsZiBzaXplIG9mIHRo
ZSBsb2cuCj4gICAgICAgICAgKgo+ICAgICAgICAgICogICAgRnJvbSBta2ZzLnhmcywgdGhpcyBp
cyBjb25zaWRlcmVkIGJ5IHRoZSBYRlNfTUlOX0xPR19GQUNUT1IKPiAgICAgICAgICAqICAgIGRl
ZmluZSwgd2hpY2ggaXMgc2V0IHRvIDMuIFRoYXQgbWVhbnMgd2UgY2FuIGRlZmluaXRlbHkgZml0
Cj4gICAgICAgICAgKiAgICBtYXhpbWFsbHkgc2l6ZWQgMiB0cmFuc2FjdGlvbnMgaW4gdGhlIGxv
Zy4gV2UnbGwgdXNlIHRoaXMgc2FtZQo+ICAgICAgICAgICogICAgdmFsdWUgaGVyZS4KPiAJIC4u
Lgo+IAkgKi8KPiAKPiBTbyB0aGUgbG9nIG11c3QgYmUgYXQgbGVhc3QgdGhlIHNpemUgb2YgdHdv
IHNpbmdsZSB0cmFuc2FjdGlvbnMgKGl0Cj4gbG9va3MgbGlrZSB0aGUgY29kZSBpcyBjb25zZXJ2
YXRpdmUgYW5kIHVzZXMgYSBmYWN0b3Igb2YgMykuIFRoaXMgaXMgYQo+IGxpbWl0YXRpb24gb24g
dGhlIG1pbmltdW0gYWxsb3dhYmxlIGxvZyBzaXplIGZvciB0aGUgZnMuIFRyYW5zYWN0aW9ucwo+
IGFyZSBvZiB2YXJpYWJsZSBzaXplLCBzbyB0byBkZXRlcm1pbmUgd2hhdCB0aGF0IG1lYW5zIGlu
IHRlcm1zIG9mIGFjdHVhbAo+IHNpemUgd2UgbXVzdCBjYWxjdWxhdGUgdGhlIG1heGltdW0gcG9z
c2libGUgKGkuZS4sIHdvcnN0IGNhc2UpCj4gdHJhbnNhY3Rpb24gc2l6ZSBmb3IgdGhlIHBhcnRp
Y3VsYXIgZnMgZ2VvbWV0cnkgYW5kIHRoZW4gdXNlIHRoYXQgdG8KPiBjYWxjdWxhdGUgdGhlIG1p
bmltdW0gdG90YWwgbG9nIHNpemUuCgpUaGFua3MsIEJyaWFuLgoKUmVnYXJkcywKU2hlbmctSHVp
Cj4gCj4gQnJpYW4KPiAKPj4KPj4gVGhhbmtzLAo+PiBTaGVuZy1IdWkKPj4KPj4KPj4gX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPj4geGZzIG1haWxpbmcg
bGlzdAo+PiB4ZnNAb3NzLnNnaS5jb20KPj4gaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCj4gCj4gCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
