Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 043C07F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 10:31:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E63AD304043
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 08:31:43 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id hcXtOa1BnKd4Dyf6 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 08:31:42 -0700 (PDT)
Date: Mon, 2 Jun 2014 11:31:24 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602153124.GH30598@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
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
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, LKML Kernel <linux-kernel@vger.kernel.org>, lftan@altera.com, Christoph Hellwig <hch@infradead.org>, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

T24gTW9uLCBKdW4gMDIsIDIwMTQgYXQgMTE6MDQ6MjNBTSAtMDQwMCwgQ2h1Y2sgTGV2ZXIgd3Jv
dGU6Cj4gSeKAmW0gd29uZGVyaW5nIHdoYXQgc2hvdWxkIGJlIGRvbmUgYWJvdXQgTkZTLiBBIHNv
bHV0aW9uIGZvciBORlMgc2hvdWxkCj4gbWF0Y2ggYW55IHNjaGVtZSB0aGF0IGlzIGNvbnNpZGVy
ZWQgZm9yIGxvY2FsIGZpbGUgc3lzdGVtcywgSU1PLgo+IAo+IEFuIGFsdGVybmF0aXZlIHdvdWxk
IGJlIHRvIOKAnGNhcOKAnSB0aGUgdGltZXN0YW1wcyB0cmFuc21pdHRlZCB2aWEgTkZTdjMgYnkK
PiBMaW51eCwgc28gdGhhdCBhIHByZS1lcG9jaCB0aW1lc3RhbXAgaXMgdHJhbnNtaXR0ZWQgYXMg
emVybywgYW5kIGEgbGFyZ2UKPiB0aW1lc3RhbXAgaXMgdHJhbnNtaXR0ZWQgYXMgVUlOVF9NQVgu
CgoKSSB3b25kZXIgaWYgaXQgd291bGQgbWFrZSBzZW5zZSB0byB0cnkgdG8gcHJvbXVsZ2F0ZSB2
aWEgdGhlIEF1c3Rpbgpncm91cCwgYW5kIHBvc3NpYmx5IHRoZSBDIHN0YW5kYXJkcyBjb21taXR0
ZWUgdGhlIGNvbmNlcHQgb2YgYSBiaXQKcGF0dGVybiAodGhhdCBtaWdodCBjb21tb25seSBiZSBJ
TlRfTUFYIG9yIFVJTlRfTUFYKSB0aGF0IG1lYW5zICJ0aW1lCnVua25vd24iLCBvciAidGltZSBp
bmRlZmluaXRlIiBvciAid2UgY291bGRuJ3QgZW5jb2RlIHRoZSB0aW1lIi4KCldlIHdvdWxkIHRo
ZW4gdGVhY2ggZ210aW1lKDMpIGFuZCBhc2N0aW1lKDMpIHRvIHByaW50IHNvbWUgYXBwcm9wcmlh
dGUKbWVzc2FnZSwgYW5kIHdlIGNvdWxkIHRlYWNoIHByb2dyYW1zIGxpa2UgZmluZCAod2l0aCB0
aGUgLW10aW1lKQpvcHRpb24sIG1ha2UsIHRtcHdhdGNoLCBldC4gYWwuLCB0aGF0IHRoZXkgY2Fu
J3QgbWFrZSBhbnkgcHJlc3VtcHRpb24KYWJvdXQgdGhlIGNvbXBhcmliaWxpdHkgb2YgYW55IHRp
bWVzdGFtcCB3aGljaCBoYXMgYSB2YWx1ZSBvZgpUSU1FX1VOREVGSU5JRUQuCgpJdCB3b3VsZCBi
ZSBwcm9ibGVtYXRpYyBmb3IgdGltZSgyKSBvciBnZXR0aW1lb2ZkYXkoMikgdG8gcmV0dXJuClRJ
TUVfVU5ERUZJTkVELCBzaW5jZSB0aGVyZSBhcmUgcHJvZ3JhbXMgdGhhdCBjYXJlIGFib3V0IHRp
bWUgdGlja2luZwpmb3J3YXJkLCBidXQgSSBjb3VsZCBpbWFnaW5lIGEgbmV3IGludGVyZmFjZSB3
aGljaCB3b3VsZCBiZSBwZXJtaXR0ZWQKdG8gcmV0dXJuIGEgZmxhZyBpbmRpY2F0aW5nIHRoYXQg
d2UgZG9uJ3Qga25vdyB0aGUgY3VycmVudCB0aW1lCihiZWNhdXNlIHRoZSBDTU9TIGJhdHRlcnkg
aGFkIHJ1biBkb3duLCBldGMuKSBzbyBpbnN0ZWFkIHdlJ3JlIGdvaW5nCnRvIGJlIGNvdW50aW5n
IHRoZSBudW1iZXIgb2Ygc2Vjb25kcyBzaW5jZSB0aGUgc3lzdGVtIHdhcyBib290ZWQuCgogICAg
CSAgICAgIAkgICAgICAJICAgIAkgICAgICAgLSBUZWQKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
