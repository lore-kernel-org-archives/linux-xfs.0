Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DJaLwL089699 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 14:36:21 -0500
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	J6IN3YRTQCFCQlXM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 12:36:20 -0700 (PDT)
Received: by ggnl1 with SMTP id l1so2560685ggn.26
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 12:36:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120409144558.6072c1eb@galadriel.home>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<20120407104912.44881be3@galadriel.home>
	<4F81F5FD.1090809@hardwarefreak.com>
	<20120408234555.695e291f@galadriel.home>
	<4F827341.2000607@hardwarefreak.com>
	<20120409144558.6072c1eb@galadriel.home>
Date: Fri, 13 Apr 2012 21:36:19 +0200
Message-ID: <CAAxjCEw-WZ9AtEJTZ6eS9+mjm+yh=e_19aJqxUN-ABRp8r3ZyQ@mail.gmail.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

PiBMZXQncyByZXJ1biBpdCB3aXRoIGZpbGVzIGNhY2hlZCAodGhlIG1hY2hpbmUgaGFzIDE2IEdC
IFJBTSwgc28KPiBldmVyeSBzaW5nbGUgZmlsZSBtdXN0IGJlIGNhY2hlZCk6Cj4KPiAjIHRpbWUg
dGFyIHhmIHRlc3QudGFyCj4KPiByZWFsIMKgIMKgMG01MC44NDJzCj4gdXNlciDCoCDCoDBtMC44
MDlzCj4gc3lzIMKgIMKgIDBtMTMuNzY3cwoKVGhhdOKAmXMgYWJvdXQgdGhlIHNhbWUgdGltZSBJ
4oCZbSBnZXR0aW5nIG9uIGEgZnJlc2ggKG5vbi1mcmFnbWVudGVkKQpmaWxlIHN5c3RlbSB3aXRo
IHRoZSBSQUlEIDYgdm9sdW1lLgoKSW50ZXJlc3RpbmdseSwgdGhlIFA0MDDigJlzIHN1Y2Nlc3Nv
ciwgdGhlIFA0MTAgZG9lcyByZWNvZ25pemUgYSBzZXR0aW5nCnRoYXQgdGhlIFA0MDAgbGFja3Ms
IHdoaWNoIGlzIGNhbGxlZCBlbGV2YXRvcnNvcnQuIEl0IHNvdW5kcyBsaWtlIHRoaXMKY291bGQg
bWFrZSBhbGwgdGhlIGRpZmZlcmVuY2UuIFVuZm9ydHVuYXRlbHksIHRoZSBQNDAwIGRvZXNu4oCZ
dCBoYXZlCml0LiBJIGRvbuKAmXQgaGF2ZSBhIFA0MTAgd2l0aCBtb3JlIHRoYW4gMiBkcml2ZXMg
dG8gdGVzdCB0aGlzLCBidXQgc29tZQplZmZlY3Qgc2hvdWxkIGRlZmluaXRlbHkgYmUgbWVhc3Vy
YWJsZS4KClNpbmNlIHRoaXMgZmluZGluZyBoYXMgcGlxdWVkIG15IGludGVyZXN0IGFnYWluLCBJ
4oCZbSB3aWxsaW5nIHRvIGludmVzdAphIGxpdHRsZSBtb3JlIHRpbWUsIGJ1dCBJ4oCZbSBjb21w
bGV0ZWx5IG9jY3VwaWVkIGZvciB0aGUgbmV4dCBmZXcgZGF5cywKc28gaXQgd2lsbCBoYXZlIHRv
IHdhaXQgYSB3aGlsZS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
