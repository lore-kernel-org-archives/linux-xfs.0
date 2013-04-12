Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C3CB7F37
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 00:16:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09A688F80A1
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 22:16:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RTZO1z8BNZOCkmTE for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 22:16:31 -0700 (PDT)
Message-ID: <516798AE.9050908@sandeen.net>
Date: Fri, 12 Apr 2013 00:16:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
	<CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
In-Reply-To: <CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
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
To: =?UTF-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gNC8xMS8xMyAxMTozMiBQTSwg56ym5rC45rabIHdyb3RlOgo+IEhpIEJyaWFuLAo+IFNvcnJ5
IGJ1dCB3aGVuIEkgZXhlY3V0ZSB0aGUgc2NyaXB0IGl0IHNheXM6Cj4gV0FSTklORzogY2Fubm90
IGZpbmQgbW9kdWxlIHhmcyBkZWJ1Z2luZm86IE5vIERXQVJGIGluZm9ybWF0aW9uIGZvdW5kCj4g
c2VtYW50aWMgZXJyb3I6IG5vIG1hdGNoIHdoaWxlIHJlc29sdmluZyBwcm9iZSBwb2ludCBtb2R1
bGUoInhmcyIpLmZ1bmN0aW9uKCJ4ZnNfaXVubGluayIpCj4gCj4gdW5hbWUgLWEKPiAyLjYuMzIt
Mjc5LmVsNi54ODZfNjQKPiBrZXJuZWwgZGVidWdpbmZvIGhhcyBiZWVuIGluc3RhbGxlZC4KPiAK
PiBXaGVyZSBjYW4gSSBmaW5kIHRoZSBjb3JyZWN0IHhmcyBkZWJ1Z2luZm8/CgppdCBzaG91bGQg
YmUgaW4gdGhlIGtlcm5lbC1kZWJ1Z2luZm8gcnBtIChvZiB0aGUgc2FtZSB2ZXJzaW9uL3JlbGVh
c2UgYXMgdGhlIGtlcm5lbCBycG0geW91J3JlIHJ1bm5pbmcpCgpZb3Ugc2hvdWxkIGhhdmU6Cgov
dXNyL2xpYi9kZWJ1Zy9saWIvbW9kdWxlcy8yLjYuMzItMjc5LmVsNi54ODZfNjQva2VybmVsL2Zz
L3hmcy94ZnMua28uZGVidWcKCklmIG5vdCwgY2FuIHlvdSBzaG93OgoKIyB1bmFtZSAtYQojIHJw
bSAtcSBrZXJuZWwKIyBycG0gLXEga2VybmVsLWRlYnVnaW5mbwoKLUVyaWMKCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
