Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5BGn0Cb078087 for <xfs@oss.sgi.com>; Sat, 11 Jun 2011 11:49:01 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E533751A880
	for <xfs@oss.sgi.com>; Sat, 11 Jun 2011 09:48:59 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id KpQBUWKJpANncplT for
	<xfs@oss.sgi.com>; Sat, 11 Jun 2011 09:48:59 -0700 (PDT)
Message-ID: <4DF39C71.7060706@tlinx.org>
Date: Sat, 11 Jun 2011 09:48:49 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: FYI: LSI rebuilding;
	and XFS speed V. raw - hints on maxing out 'dd'....(if not already
	obvious)...
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>	<20110502191323.417ef644@harpe.intellique.com>	<4DF2C5D4.6030507@tlinx.org>
	<20110611113049.2868f9c7@galadriel2.home>
In-Reply-To: <20110611113049.2868f9c7@galadriel2.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Paul Anderson <pha@umich.edu>, xfs@oss.sgi.com

CgpFbW1hbnVlbCBGbG9yYWMgd3JvdGU6Cj4gTGUgRnJpLCAxMCBKdW4gMjAxMSAxODozMzowOCAt
MDcwMCB2b3VzIMOpY3JpdmllejoKPiAKPj4gSSBoYXZlIGEgOTI4NS04RSBhbmQgaGF2ZSBiZWVu
IHByZXR0eSBoYXBweSB3aXRoIGl0J3MgcGVyZm9ybWFuY2UsCj4+IGJ1dCBJIG9ubHkgaGF2ZSAx
MCBkYXRhIGRpc2tzICgyeDYtZGlzayBSQUlENSA9PlJBSUQ1MCkgd2l0aCAyVEIKPj4gU0FUQSdz
IGFuZCBnZXQgMUdCIHBlcmYuLi4gYWJvdXQgd2hhdCBJJ2QgZXhwZWN0IGZyb20gZGlza3MgdGhh
dCBnZXQKPj4gYXJvdW5kIDEyME1CIGVhY2ggYW5kIGRvaW5nIDIgUkFJRDUgY2FsY3MuLi4pLi4u
Cj4gCj4gSSd2ZSBtYWRlIHNvbWUgbW9yZSB0ZXN0cyBzaW5jZSB0aGVuLCBhbmQgSSB3YXMgdXNp
bmcgY2hlYXBvIGRyaXZlcyBmb3IKPiB0ZXN0aW5nIHRoYXQgZm9yIHNvbWUgcmVhc29uLCBiZWhh
dmUgZXh0cmFvcmRpbmFyaWx5IHBvb3JseSBpbgo+IGNvbWJpbmF0aW9uIHdpdGggdGhlIExTSSBj
YXJkLiBJJ3ZlIHJldGVzdGVkIHRoZSBjYXJkIHdpdGggaGl0YWNoaQo+IFVsdHJhc3RhcnMgYW5k
IGl0IHdvcmtlZCBqdXN0IGZpbmUgKHRob3VnaCBhIGJpdCBzbG93ZXIgdGhhbiBBZGFwdGVjCj4g
Nnh4NSkuIE9UT0gsIHRoZSBBZGFwdGVjIHdvcmtzIGZpbmUgd2l0aCB0aGUgImJhZCIgZHJpdmVz
IHRvbywgZ28KPiBmaWd1cmUuIAotLS0tLQoJSSBub3RpY2VkIHRoaXMgaXNzdWUgd2l0aCB0aGUg
TFNJIGNhcmQgYXMgd2VsbCAtLSBpLmUuIHdpdGgKJ2JhZCcgbG93LXF1YWwgZHJpdmVzLgoKCVdo
YXQgSSBub3RpY2VkIHRob3VnaCAtLSBpbiBpbmRlcGVuZGVudCB0ZXN0aW5nIG9mIHRoZSAKbG93
ZXIgcXVhbGl0eSBkcml2ZXMsIHdhcyB0aGF0IGV2ZW4gdGhvdWdoIHRoZXkgd2VyZSBhbGwgc3Bl
YydlZCBhdAo3MjAwUlBNLCB0aGVpciBhY3R1YWwgc3BlZWRzIHZhcmllZCwgZnJvbSB0b3AgdG8g
Ym90dG9tIGJ5IGFsbW9zdCA1MCUKKEluZGlyZWN0bHkgbWVhc3VyZWQgYnkgdG9wIHRyYW5zZmVy
IHNwZWVkcyBjb3B5aW5nIGZyb20gJiB0byB0aGUgZHJpdmVzCjEyOEcgZmlsZXMuLi4gLi4gYWxs
IGZyZXNobHkgZm9ybWF0dGVkLCBmYWN0b3J5ICduZXcnLCBmcm9tIHRoZSBzYW1lCmdlbmVyYXRp
b24pLiAgIFNwZWVkcyB2YXJpZWQgZnJvbSB0b3AgdG8gYm90dG9tIHdpdGggbWF4IGFyb3VuZCAx
MjlNQi9zCnRvIGJvdHRvbSBAIDg3TUIvcywgd2l0aCB0eXBpY2FsIGJlaW5nIDk1LTEyMC4gIFRo
YXQgd2FzIHF1aXRlIGEgcmFuZ2UgCm9mIHNwZWVkcy4gICBUcnlpbmcgdG8gJ3N5bmNocm9uaXpl
IHJlYWRzL3dyaXRlcy8gb24gZHJpdmVzIHdpdGggc3VjaAp2YXJ5aW5nIHNwZWVkcyB3b3VsZCBi
ZSBhIG5pZ2h0bWFyZS4gIAoKCUkgdHJpZWQgYW5vdGhlciBSQUlEIGNvbnRyb2xsZXIgYW5kIGdv
dCBhYm91dCA2MCUgdGhlIHBlcmZvcm1hbmNlCm9mIHRoZSBMU0kncyAtLSBidXQgaXQgd2FzIGFs
c28gd2l0aCB0aGUgY2hlYXBlciBkcml2ZXMuICBUaGUgTFNJIGNvbnRyb2xsZXIKd291bGRuJ3Qg
InBhc3MiIHRoZSBkcml2ZXMgYXMgImFjY2VwdGFibGUiIGlmIHRoZXkgd2VyZSB0b28gZmFyIG91
dCBvZiBzcGVjLgoKCVRoZSBVbHRyYXN0YXJzIChOT1QgdGhlIGRlc2tzdGFycywgd2hpY2ggYXJl
IG5vdCBzcGVlZCBjb250cm9sbGVkKQphbGwgd2VyZSBmaW5lLiAgSSd2ZSBoZWFyZCBvZiBwZW9w
bGUgaGF2aW5nIHByb2JsZW1zIHdpdGggRW50ZXJwcmlzZQpDbGFzcyBXRCBkcml2ZXMgZHVlIHRv
IHRoZSBpc3N1ZS4gICBTbyBpdCBtYXkgYmUgYSBtYXR0ZXIgb2YgdGhlIGNvbnRyb2xsZXIKJ3By
b3RlY3RpbmcgaXRzZWxmJyBmcm9tIGRyaXZlcyB0aGF0IGFyZSBvdXQgb2Ygc3BlYyAtLSBhbmQg
YXJlIHRoZXJlZm9yZSBub3QKY29uc2lkZXJlZCAnUkFJRCBjbGFzcycgZHJpdmVzLi4uICAgCgoJ
U29tZSB3b3VsZCBhcmd1ZSB0aGF0IGJlaW5nIG1vcmUgJ3RvbGVyYW50JyBvZiBwb29yIGRyaXZl
cyBpcyBhIGdvb2QKdGhpbmcuLi4gIEJ1dCBpZiB5b3Ugd2FudCB0aGUgZmFzdGVzdCBzcGVlZCwg
eW91IG5lZWQgdG8gbWFrZSBzdXJlIHRoZSBkcml2ZQpzcGVlZHMgYXJlIHdlbGwgbWF0Y2hlZC4K
CgoKCnNhbWUgaXNzdWUuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
