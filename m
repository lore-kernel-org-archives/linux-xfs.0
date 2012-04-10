Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AKhrGw207779 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 15:43:53 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 12kBylbTqbztzffS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Apr 2012 13:43:52 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so190134yhj.26
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 13:43:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F849817.4060102@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
	<4F8055E4.1000808@hardwarefreak.com>
	<CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
	<4F8372DC.7030405@hardwarefreak.com>
	<CAAxjCEx14NrgUatB349vx8h0kCxE=cS7d4DLLPnjwB035tB3Hw@mail.gmail.com>
	<4F849817.4060102@hardwarefreak.com>
Date: Tue, 10 Apr 2012 22:43:51 +0200
Message-ID: <CAAxjCEyjwSvsiUg1zYDjikWZ8NAYiaNLAkL6HHQMJn9DaJh4GA@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: stan@hardwarefreak.com
Cc: Linux fs XFS <xfs@oss.sgi.com>

PiBXaGF0IHdhcyB0aGUgbG9jYXRpb24gb2YgdGhlIEtWTSBpbWFnZXMgeW91IHdlcmUgY29weWlu
Zz8gwqBJcyBpdAo+IHBvc3NpYmxlIHRoZSBzb3VyY2UgZGV2aWNlIHNpbXBseSBzbG93ZWQgZG93
bj8gwqBPciBuZXR3b3JrIGNvbmdlc3Rpb24gaWYKPiB0aGlzIHdhcyBhbiBORlMgY29weT8KClBp
cGVkIHZpYSBzc2ggZnJvbSBhbm90aGVyIGhvc3QuIE5vLCBldmVyeXRoaW5nIHdhcyBjb21wbGV0
ZWx5IGlkbGUgb3RoZXJ3aXNlLgoKPj4gU28gSSB0aHJldyBYRlMgYmFjayBpbiwgcmVzdGFydGVk
IHRoZSByZXN0b3JlLCBhbmQgaXQgd2VudCB2ZXJ5Cj4+IHNtb290aGx5IHdoaWxlIHN0aWxsIHBy
b3ZpZGluZyBhY2NlcHRhYmxlIGludGVyYWN0aXZpdHkuCj4KPiBJdCdzIG5pY2UgdG8ga25vdyBY
RlMgInNhdmVkIHRoZSBkYXkiIGJ1dCBJJ20gbm90IHNvIHN1cmUgWEZTIGRlc2VydmVzCj4gdGhl
IGNyZWRpdCBoZXJlLiDCoFRoZSBFWFQ0IGRyaXZlciBpdHNlbGYvYWxvbmUgc2hvdWxkbid0IGNh
dXNlIHRoZSBsYWNrCj4gb2YgcmVzcG9uc2l2ZW5lc3MgYmVoYXZpb3IgeW91IHNhdy4gwqBJJ20g
Z3Vlc3Npbmcgc29tZXRoaW5nIHdlbnQgd3JvbmcKPiBvbiB0aGUgc291cmNlIHNpZGUgb2YgdGhl
c2UgZmlsZSBjb3BpZXMsIGdpdmVuIHlvdXIgcmVwb3J0IG9mIGRyb3BwaW5nCj4gdG8gMzAtNDBN
Qi9zIG9uIHRoZSB3cml0ZW91dC4KCk1heWJlIGl0IHNob3VsZG7igJl0LCBidXQgc29tZXRoaW5n
IHN1cmUgZGlkLiBBbmQgdGhlIGNpcmN1bXN0YW5jZXMgc2VlbQp0byBwb2ludCBhdCBleHQ0LiBT
aW5jZSB0aGUgc2l0dWF0aW9uIHBlcnNpc3RlZCBmb3IgbWludXRlcyBhZnRlciBJCmhhZCBzdG9w
cGVkIHRoZSB0cmFuc2ZlciwgaXQgY2Fubm90IHBvc3NpYmx5IGhhdmUgYmVlbiByZWxhdGVkIHRv
IHRoZQpzb3VyY2UuCgpJIGhhdmUgYSBmZWVsaW5nIHRoYXQgd2l0aCBhcHByb3ByaWF0ZSB2bS5k
aXJ0eV9yYXRpbyB0dW5pbmcgKGFuZApwcm9iYWJseSByZWxhdGVkIHNldHRpbmdzKSwgSSBjb3Vs
ZCBoYXZlIHJlbWVkaWVkIHRoaXMuIEJ1dCB0aGF04oCZcwpqdXN0IG9uZSBtb3JlIHRoaW5nIEni
gJlkIGhhdmUgdG8gdGlua2VyIHdpdGgganVzdCB0byBnZXQgdG8gZ2V0CmFjY2VwdGFibGUgYmVo
YXZpb3Igb3V0IG9mIHRoaXMgbWFjaGluZS4gSSBkb27igJl0IG1pbmQgaWYgSSBkb27igJl0IGdl
dAp0b3Atbm90Y2ggcGVyZm9ybWFuY2Ugb3V0IG9mIHRoZSBib3gsIGJ1dCB0aGlzIGlzIHNpbXBs
eSB0b28gbXVjaC4gSQpkb27igJl0IHdhbnQgdG8gYmUgZXhwZWN0ZWQgdG8gaGFuZC10dW5lIGV2
ZXJ5IGRhbW4gdGhpbmcuCgo+PiBYRlMgaXMgbm90IGEgcGFuYWNlYSAob2J2aW91c2x5KSwgYW5k
IGl0IG1heSBiZSBhIGJpdCBzbG93ZXIgaW4gbWFueQo+PiBjYXNlcywgYW5kIGRvZXNu4oCZdCBz
ZWVtIHRvIGNvcGUgd2VsbCB3aXRoIGZyYWdtZW50ZWQgZnJlZSBzcGFjZSAod2hpY2gKPj4gaXMg
d2hhdCB0aGlzIGVudGlyZSB0aHJlYWQgaXMgcmVhbGx5IGFib3V0KSwKPgo+IERpZCB5b3UgcmV0
ZXN0IGZyYWdtZW50ZWQgZnJlZXNwYWNlIHdyaXRlcyB3aXRoIHRoZSBsaW5lYXIgY29uY2F0IG9y
Cj4gUkFJRDEwPyDCoElmIG5vdCB5b3UncmUgZHJhd2luZyBpbmNvcnJlY3QgY29uY2x1c2lvbnMg
ZHVlIHRvIG5vdCBoYXZpbmcKPiBhbGwgdGhlIGZhY3RzLgoKWWVzLCBJIGRpZCB0aGlzLiBJdCBw
ZXJmb3JtZWQgdmVyeSB3ZWxsLiBPbmx5IHNsaWdodGx5IHNsb3dlciB0aGFuIG9uCmEgY29tcGxl
dGVseSBlbXB0eSBmaWxlIHN5c3RlbS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
