Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C0D27FB2
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 03:56:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 294DE8F8050
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 01:56:47 -0800 (PST)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id wjU1mFnmAeeAQLFe for
	<xfs@oss.sgi.com>; Sat, 01 Feb 2014 01:56:45 -0800 (PST)
Date: Sat, 1 Feb 2014 10:56:16 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
Message-ID: <20140201105616.1a1906eb@galadriel.home>
In-Reply-To: <D52B7046-0672-4C4E-AC79-DCB7F811DB2E@gmail.com>
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
	<1391009068.4294.83.camel@montana.filmlight.ltd.uk>
	<1391014448.2573.95.camel@islero.dmt.upm.es>
	<20140129184250.7af7200f@harpe.intellique.com>
	<CC18E95B-75B3-47CE-8FBE-9FA511A38CD5@torroja.dmt.upm.es>
	<20140131223715.0a977fc2@galadriel.home>
	<D52B7046-0672-4C4E-AC79-DCB7F811DB2E@gmail.com>
Mime-Version: 1.0
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
To: Juan Antonio Sillero Sepulveda <juan.sillero@gmail.com>
Cc: xfs@oss.sgi.com, Roger Willcocks <roger@filmlight.ltd.uk>, Guillem Borrell i Nogueras <guillem@torroja.dmt.upm.es>

TGUgRnJpLCAzMSBKYW4gMjAxNCAyMjo1MDo1MSArMDEwMCB2b3VzIMOpY3JpdmllejoKCj4gR3Vp
bGxlbSwgbXkgY29sbGVhZ3VlIGFuZCBleHBlcnQsIGNvcnJlY3QgbWUuIFRoZXNlIGlzIHRoZSBo
YXJkd2FyZS4KPiAKPiBEaXNrIC9kZXYvc2RxIC0gMjAgVEIgLyAxOCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2RyIC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2RzIC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2R0IC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2R1IC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2R2IC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2R3IC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2R4IC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2R5IC0gMjIgVEIgLyAyMCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKPiBEaXNrIC9kZXYvc2R6IC0gMjAgVEIgLyAxOCBUaUIgLSBEb3RIaWxsIFIv
RXZvIDU3MzAtMlIKClRoaXMgaXMgcXVpdGUgbmV3IGhhcmR3YXJlLCBpdCdzIHByb2JhYmx5IHN1
cHBvcnRlZC9tYWludGFpbmVkLiBZb3UKc2hvdWxkIGRlZmluaXRlbHkgY2hlY2sgd2l0aCBEb3RI
aWxsIHN1cHBvcnQuCgo+IFdlIHN0b3JlIGV2ZXJ5dGhpbmcsIGJhc2ljYWxseS4gSW1hZ2VzLCBt
YXRsYWJzIGZpbGVzLCB0eHQsIGRhdCwgcGRmLAo+IGJpbmFyeSBmaWxlcywgaGRmNSBmaWxlcywg
Lm1hdCwgRm9ydHJhbiBmaWxlcywgZXRjLi4uCgpQaG90b3JlYyBjYW4gcmVjb2duaXplIG1hbnkg
Y29tbW9uIGZpbGUgZm9ybWF0cywgYnV0IG5vdCBhbGwuIEkndmUKc3VjY2Vzc2Z1bGx5IHJlc3Rv
cmVkIHNldmVyYWwgdGVyYWJ5dGVzIHdpdGggaXQsIGhvd2V2ZXIgeW91IHdvbid0IGdldAphbnkg
bWV0YWRhdGEgYmFjayB3aXRoIGl0LgoKLS0gCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpFbW1hbnVlbCBGbG9y
YWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAgICAgICAgICAgfCAgIElu
dGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGludGVsbGlxdWUuY29tPgog
ICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWls
aW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL3hmcwo=
