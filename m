Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HLhOTV009503 for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:43:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0E66353296
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 14:45:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	T0F1IkYZSuKmcrFU for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 14:45:40 -0700 (PDT)
Date: Tue, 18 May 2010 07:45:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
Message-ID: <20100517214532.GL8120@dastard>
References: <20100510022033.GB7165@dastard>
 <4BF1B4FE.7020503@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BF1B4FE.7020503@redhat.com>
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
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, xfs@oss.sgi.com

T24gTW9uLCBNYXkgMTcsIDIwMTAgYXQgMDU6Mjg6MzBQTSAtMDQwMCwgRG91ZyBMZWRmb3JkIHdy
b3RlOgo+IE9uIDA1LzA5LzIwMTAgMTA6MjAgUE0sIERhdmUgQ2hpbm5lciB3cm90ZToKPiA+IE9u
IFN1biwgTWF5IDA5LCAyMDEwIGF0IDA4OjQ4OjAwUE0gKzAyMDAsIFJhaW5lciBGdWVnZW5zdGVp
biB3cm90ZToKPiA+Pgo+ID4+IHRvZGF5IGluIHRoZSBtb3JuaW5nIHNvbWUgZGFlbW9uIHByb2Nl
c3NlcyB0ZXJtaW5hdGVkIGJlY2F1c2Ugb2YKPiA+PiBlcnJvcnMgaW4gdGhlIHhmcyBmaWxlIHN5
c3RlbSBvbiB0b3Agb2YgYSBzb2Z0d2FyZSByYWlkNSwgY29uc2lzdGluZwo+ID4+IG9mIDQqMS41
VEIgV0QgY2F2aWFyIGdyZWVuIFNBVEEgZGlza3MuCj4gPiAKPiA+IFJlbWluZHMgbWUgb2YgYSBy
ZWNlbnQoLWlzaCkgbWQvZG0gcmVhZGFoZWFkIGNhbmNlbGxhdGlvbiBmaXggLSB0aGF0Cj4gPiB3
b3VsZCBmaXQgdGhlIHN5bXB0b21zIG9mIChidHJlZSBjb3JydXB0aW9uIHNob3dpbmcgdXAgdW5k
ZXIgaGVhdnkgSU8KPiA+IGxvYWQgYnV0IG5vIGNvcnJ1cHRpb24gb24gZGlzay4gSG93ZXZlciwg
SSBjYW4ndCBzZWVtIHRvIGZpbmQgYW55Cj4gPiByZWZlcmVuY2VzIHRvIGl0IGF0IHRoZSBtb21l
bnQgKGNhbid0IHJlbWVtYmVyIHRoZSBidWcgdGl0bGUpLCBidXQKPiA+IHBlcmhhcHMgeW91ciBk
aXN0cm8gZG9lc24ndCBoYXZlIHRoZSBmaXggaW4gaXQ/Cj4gPiAKPiA+IENoZWVycywKPiA+IAo+
ID4gRGF2ZS4KPiAKPiBUaGF0IHNvdW5kcyBwbGF1c2libGUsIGFzIGRvZXMgaGFyZHdhcmUgZXJy
b3IuICBBIG1lbW9yeSBiaXQgZmxpcCB1bmRlcgo+IGhlYXZ5IGxvYWQgd291bGQgY2F1c2UgdGhl
IGluIG1lbW9yeSBkYXRhIHRvIGJlIGNvcnJ1cHQgd2hpbGUgdGhlIG9uCj4gZGlzayBkYXRhIGlz
IGdvb2QuCgpUaGUgZGF0YSBkdW1wcyBmcm9tIHRoZSBiYWQgYmxvY2tzIHdlcmVuJ3Qgd3Jvbmcg
YnkgYSBzaW5nbGUgYml0IC0KdGhleSB3ZXJlIHVucmVjb2duadGVYWJsZSBnYXJiYWdlIC0gc28g
dGhhdCBpdCB2ZXJ5IHVubGlrZWx5IHRvIGJlCmEgbWVtb3J5IGVycm8gY2F1c2luZyB0aGUgcHJv
YmxlbS4KCj4gQnkgd2FpdGluZyB0byBjaGVjayBpdCB1bnRpbCBsYXRlciwgdGhlIGJhZCBtZW1v
cnkKPiB3YXMgZmx1c2hlZCBhdCBzb21lIHBvaW50IGFuZCB3aGVuIHRoZSBkYXRhIHdhcyByZWxv
YWRlZCBpdCBjYW1lIGluIG9rCj4gdGhpcyB0aW1lLgoKWXVwIC0gWEZTIG5lZWRzIHRvIGRvIGEg
YmV0dGVyIGpvYiBvZiBjYXRjaGluZyB0aGlzIGNhc2UgLSB0aGUKcHJvdG90eXBlIG1ldGFkYXRh
IGNoZWNrc3VtbWluZyBwYXRjaCBjYXVnaHQgbW9zdCBvZiB0aGVzZSBjYXNlcy4uLgoKQ2hlZXJz
LAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
