Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EC77B7F7D
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 17:44:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D38AA8F8050
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 15:44:04 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Bd58gSnhPHVf9qz3 for <xfs@oss.sgi.com>;
	Mon, 23 Dec 2013 15:44:02 -0800 (PST)
Date: Tue, 24 Dec 2013 10:43:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] directory quota survey on xfs
Message-ID: <20131223234355.GK3220@dastard>
References: <20131222095929.GA11444@gmail.com> <20131223014222.GC3220@dastard>
	<201312231012.19204.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201312231012.19204.arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org

T24gTW9uLCBEZWMgMjMsIDIwMTMgYXQgMTA6MTI6MTlBTSArMDEwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IE9uIE1vbmRheSAyMyBvZiBEZWNlbWJlciAyMDEzLCBEYXZlIENoaW5u
ZXIgd3JvdGU6Cj4gCj4gPiA+IEFzIGFsd2F5cywgYW55IGNvbW1lbnQgb3IgaWRlYSBhcmUgd2Vs
Y29tZS4KPiA+IAo+ID4gSSdkIHN1Z2dlc3QgdGhhdCB5b3UgaW1wbGVtZW50IHByb2plY3QgcXVv
dGFzLCBub3QgZGlyZWN0b3J5IHF1b3Rhcy4KPiA+IFRoZXkgYXJlIHdheSBtb3JlIGZsZXhpYmxl
IHRoYW4gcHVyZSBkaXJlY3RvcnkgcXVvdGFzLCBidXQgd2l0aCBvbmx5Cj4gPiBhIGZldyBsaW5l
cyBvZiBjb2RlIGFuZCBhIHNwZWNpYWwgZGlyZWN0b3J5IGZsYWcgdGhleSBjYW4gYmUgdXNlZCB0
bwo+ID4gPiBpbXBsZW1lbnQgZGlyZWN0b3J5IHN1YnRyZWUgcXVvdGFzLi4uLgo+IAo+IFdvdWxk
IGJlIGFsc28gbmljZSB0byBhbGxvdyBhIGZpbGUgdG8gYmVsb25nIHRvIG1vcmUgdGhhbiBvbmUg
cHJvamVjdC4KCk5vdCBwb3NzaWJsZS4gQXBhcnQgZnJvbSB0aGVyZSBvbmx5IGJlaW5nIGEgc2lu
Z2xlIHByb2plY3QgSUQgdG8gYW4KaW5vZGUsIGhhdmluZyB0byBhY2NvdW50IGFuIGlub2RlIG90
IG11bGl0cGxlIHByb2plY3QgcXVvdGFzCmVmZmVjdGl2ZWx5IG1ha2VzIGV2ZXJ5IHRyYW5zYWN0
aW9uIGluIFhGUyBoYXZlIHRvIG1vZGlmeSBhbiB1bmJvdW5kCm51bWJlciBvZiBkcXVvdHMuIFdl
IGRvbid0IGhhdmUgdGhlIGluZnJhc3RydWN0dXJlIHRvIGRvIHRoYXQsIHdlCmNhbid0IHJlc2Vy
dmUgbG9nIHNwYWNlIGZvciB1bmJvdW5kIHNpemVkIHRyYW5zYWN0aW9ucywgZXRjLgoKPiBMZXQg
c2F5IEkgd2FudCB0byBoYXZlCj4gCj4gL3Byb2plY3RzLyB3aXRoIDEwR0IgcXVvdGEKPiBhbmQK
PiAvcHJvamVjdHMvcHJvamVjdEEvIHdpdGggMUdCIHF1b3RhCj4gL3Byb2plY3RzL3Byb2plY3RC
LyB3aXRoIDJHQiBxdW90YQo+IGFuZCBzbyBvbiB0aGF0J3Mgc3RpbGwgbGltaXRlZCBieSAvcHJv
amVjdHMvIDEwR0IgcXVvdGEgbGltaXQuCgpXaGF0IHlvdSBnZXQgaXMgZXhjbHVzaXZlIGFjY291
bnRpbmcgLSB0aGUgMTBHQiBsaW1pdCBvbiAvcHJvamVjdHMvCmV4Y2x1ZGVzIHRoZSBsaW1pdHMg
c2V0IG9uIC9wcm9qZWN0cy9wcm9qZWN0QS8gYW5kCi9wcm9qZWN0cy9wcm9qZWN0Qi8uCgpUaGlu
ayBhYm91dCBpdCBmb3IgYSBtaW51dGUgLSBpZiB3ZSBtYWtlIHN1YnRyZWVzIG5lc3QgbGlrZSB5
b3UKc3VnZ2VzdCwgdGhlbjoKCi9wcm9qZWN0cy8gd2l0aCAxMEdCIHF1b3RhCi9wcm9qZWN0cy9w
cm9qZWN0QS8gd2l0aCA1R0IgcXVvdGEKL3Byb2plY3RzL3Byb2plY3RBL3N1YnByb2oxIHdpdGgg
M0dCIHF1b3RhCi9wcm9qZWN0cy9wcm9qZWN0QS9zdWJwcm9qMS9zc3AyIHdpdGggMkdCIHF1b3Rh
Ci9wcm9qZWN0cy9wcm9qZWN0QS9zdWJwcm9qMS9zc3AyL3Nzc3AzIHdpdGggMUdCIHF1b3RhCgpp
ZiB3ZSBtb2RpZnkgYSBmaWxlIGluIC4uLi4vc3NzcDMvLCB0aGVuIHdlIGhhdmUgNSBwcm9qZWN0
IHF1b3RhcyB3ZQpoYXZlIHRvIGNoZWNrIGZvciBsaW1pdCBlbmZvcmNlbWVudCwgcmVzZXJ2ZSBi
bG9ja3Mgb24gYW5kIHRoZW4KdHJhbnNhY3Rpb25hbGx5IG1vZGlmeSAocGx1cyB1c2VyIGFuZCBn
cm91cCBmb3IgdGhlIGZpbGUgaXRzZWxmKS4KClRoYXQncyBleGNlZWRpbmdseSBjb21wbGV4IGJl
Y2F1c2Ugd2UgZG9uJ3QgaGF2ZSBwb2ludGVycyB0byBhbGwKdGhlIGlub2RlcyBpbiB0aGUgcGF0
aCBiYWNrIHVwIHRvIHRoZSByb290LCBzbyBqdXN0IHRvIGZpbmQgdGhhdCB3ZQpoYXZlIG5lc3Rl
ZCBwcm9qZWN0IHF1b3RhcyByZXF1aXJlcyBhIHJldmVyc2UgcGF0aCB3YWxrIHRvIGZpbmQgdGhl
CmRpcmVjdG9yeSBpbm9kZXMgdG8gZ2V0IHRoZWlyIHByb2plY3QgSURzIHRvIGxvb2sgdXAgdGhl
IGRxdW90cyB3ZSdkCm5lZWQgdG8gbW9kaWZ5LiBUaGUgY29tcGxleGl0eSBhbmQgcGVyZm9ybWFu
Y2Ugb3ZlcmhlYWQgb2YgcmVjdXJzaXZlCnByb2plY3QgcXVvdGEgYWNjb3VudGluZyBzaW1wbHkg
aXNuJ3Qgd29ydGggaXQuCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZy
b21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
