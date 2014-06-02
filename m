Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BBDE29DF8
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 13:52:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22523AC001
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 11:52:55 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24]) by
	cuda.sgi.com with ESMTP id EV7FlnPIS3bxoxDV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 11:52:53 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 20:52:43 +0200
Message-ID: <5109660.teHoOW5tSd@wuerfel>
In-Reply-To: <6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
MIME-Version: 1.0
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
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, LKML Kernel <linux-kernel@vger.kernel.org>, lftan@altera.com, Christoph Hellwig <hch@infradead.org>, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

T24gTW9uZGF5IDAyIEp1bmUgMjAxNCAxMTowNDoyMyBDaHVjayBMZXZlciB3cm90ZToKPiBJ4oCZ
bSB3b25kZXJpbmcgd2hhdCBzaG91bGQgYmUgZG9uZSBhYm91dCBORlMuIEEgc29sdXRpb24gZm9y
IE5GUyBzaG91bGQKPiBtYXRjaCBhbnkgc2NoZW1lIHRoYXQgaXMgY29uc2lkZXJlZCBmb3IgbG9j
YWwgZmlsZSBzeXN0ZW1zLCBJTU8uCj4gCj4gTkZTdjIvMyB0aW1lc3RhbXBzIGFyZSBhIHBhaXIg
b2YgdW5zaWduZWQgMzItYml0IHZhbHVlczogb25lIHZhbHVlIGZvcgo+IHNlY29uZHMgc2luY2Ug
bWlkbmlnaHQgR01UIEphbiAxLCAxOTcwLCBhbmQgb25lIHZhbHVlIGZvciBuYW5vc2Vjb25kcy4K
PiAoU2VlIHRoZSBkZWZpbml0aW9uIG9mIG5mc3RpbWUzIGluIFJGQyAxODEzKS4KPiAKPiBORlN2
NCB1c2VzIGEgc2lnbmVkIDY0LWJpdCB2YWx1ZSB3aGVyZSB6ZXJvIHJlcHJlc2VudHMgbWlkbmln
aHQgVVRDCj4gb24gSmFudWFyeSAxLCAxOTcwLCBhbmQgYW4gdW5zaWduZWQgMzItYml0IHZhbHVl
IGZvciBuYW5vc2Vjb25kcy4gKFNlZQo+IHRoZSBkZWZpbml0aW9uIG9mIG5mc3RpbWU0IGluIFJG
QyA1NjYxKS4KPiAKPiBUaGUgTkZTdjQgcHJvdG9jb2wgaXMgcHJvYmFibHkgbm90IHByb2JsZW1h
dGljLCBhbmQgTkZTdjMgc2hvdWxkIGJlIG91dAo+IG9mIHRoZSBwaWN0dXJlIGJ5IDIwMzguIEJ1
dCBpZiBjaGFuZ2VzIGFyZSBwbGFubmVkIGZvciBkZWFsaW5nIF9ub3dfCj4gd2l0aCB0aW1lc3Rh
bXAgaXNzdWVzLCBjb21wYXRpYmlsaXR5IHdpdGggTkZTdjMgaXMgYSBjb25zaWRlcmF0aW9uLgo+
IAo+IEl0IGlzIGFscmVhZHkgdGhlIGNhc2UgdGhhdCwgdmlhIE5GU3YzLCB0aGUgTGludXggTkZT
IGNsaWVudCB0cmFuc21pdHMKPiB0aW1lc3RhbXBzIGVhcmxpZXIgdGhhbiAxOTcwIGFzIGxhcmdl
IHBvc2l0aXZlIG51bWJlcnMuIFRyeSB0aGlzIHdpdGgKPiB4ZnN0ZXN0cyBnZW5lcmljLzI1OC4K
CklmIEkgcmVhZCB0aGUgY29kZSBjb3JyZWN0bHksIGEgcHJlLTE5NzAgdGltZXN0YW1wIHdpbGwg
YmUgc2VudCBhcwphIGxhcmdlIHVuc2lnbmVkIGludGVnZXIsIGJ1dCByZWNlaXZlZCBhcyBhIHBv
c3QtMjAzOCB0aW1lc3RhbXAgb24KNjQtYml0IGtlcm5lbHMsIGJvdGggaW4gdGhlIG5mcyBjbGll
bnQgYW5kIHNlcnZlciBjb2RlLgoKVGhpcyBiZWhhdmlvciBpcyBjbGVhcmx5IHdyb25nLCBidXQg
aXQncyB0aGUgc2FtZSBidWcgdGhhdCB3ZSBoYXZlCmluIGxvdHMgb2Ygb3RoZXIgZmlsZSBzeXN0
ZW1zLCBhbmQgaXQgbWFrZXMgc2Vuc2UgdG8gaGF2ZSB0aGUKc2FtZSBmaXggZXZlcnl3aGVyZSwg
YXQgbGVhc2UgdGhlIGNhc2VzIHdoZXJlIHdlIGtub3cgd2hhdCBpbnRlcnByZXRhdGlvbgp3ZSBh
Y3R1YWxseSB3YW50LiBORlMgaGFzIHRoZSBsdXh1cnkgb2YgaGF2aW5nIGFuIGFjdHVhbCBzcGVj
aWZpY2F0aW9uCnNheWluZyB0aGF0IHRoZSB2YWx1ZSBpcyB1bnNpZ25lZC4gRm9yIG1vc3Qgb2Yg
dGhlIGxlZ2FjeSBmaWxlIHN5c3RlbXMsCndlIGNhbiBvbmx5IG1ha2UgYSBndWVzcyBhdCBob3cg
b3RoZXIgT1NzIHdvdWxkIGludGVycHJldCB0aGUgc2FtZQpudW1iZXJzLgoKCUFybmQKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxp
c3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hm
cwo=
