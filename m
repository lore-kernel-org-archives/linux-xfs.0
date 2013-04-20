Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F8F529DFA
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 22:41:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0CB55304067
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 20:41:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nIXqkvZapr0pEewq for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 20:41:00 -0700 (PDT)
Message-ID: <51720E49.9020001@sandeen.net>
Date: Fri, 19 Apr 2013 20:40:57 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com>
	<CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
	<51705EC4.4000306@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
	<CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
	<5171790C.70400@sandeen.net>
	<CADFMGuKfyw-mCsRn1Y5H5ek+z_nRMHDmW4bG-Ez9ANJm7_ec5A@mail.gmail.com>
	<CADFMGuL4+vSH9ZpWODXWbHVz9ndMcg2aZY9b0ccq74SJp3XzEw@mail.gmail.com>
	<CADFMGuK7FEbWibRrctK7B=XXAfAKtpjRej3NVB2k7JXhhYFLLg@mail.gmail.com>
	<CADFMGuJozkBQdp5o_BK7HbrPdv6iKUie=jHyz5LrtBBvHY1b4w@mail.gmail.com>
	<CADFMGuL05J+b=bv5jAneLT451eQFNNz2RNHQHccBOjqWsE68Kw@mail.gmail.com>
In-Reply-To: <CADFMGuL05J+b=bv5jAneLT451eQFNNz2RNHQHccBOjqWsE68Kw@mail.gmail.com>
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
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gNC8xOS8xMyA3OjUxIFBNLCDnrKbmsLjmtpsgd3JvdGU6Cj4gQWZ0ZXIgY2hhbmdlIG1vdW50
IG9wdGlvbiB0byBzeW5jIHNodXRkb3duIHN0aWxsIGhhcHBlbnMsIGFuZCBJIGdvdCBhIHRyYWNl
IGFnYWluLCB0aGUgaW5vZGUgMHgxYzU3ZCBpcyBhYm5vcm1hbC4KCnNpbmNlIHRoaXMgaXMgYSBy
YWNlIG9uIG5hbWVzcGFjZSBvcGVyYXRpb25zLCBJIHdvdWxkbid0IGhhdmUgZXhwZWN0ZWQgc3lu
YyB0byBtYXR0ZXIuCgo+IGh0dHBzOi8vZG9jcy5nb29nbGUuY29tL2ZpbGUvZC8wQjduMkM0VDV0
Zk5DWVcxak5XaEJiWEJZYWtFL2VkaXQ/dXNwPXNoYXJpbmcKPiBJIGhhdmUgYSBxdWVzdGlvbiBp
ZiB0aGUgcHJvYmxlbSBpcyBoYXJkIHRvIHJlcHJvZHVjZSB3aHkgSSBnb3QgOCB0aW1lcyBpbiBh
IHdlZWsgb25seSBpbiBhIHRlc3QgY2x1c3RlciB3aXRoIDggbm9kZT8KPiBXaGF0J3MgdGhlIHBy
b2JsZW0/Cgp5b3UgbXVzdCBoYXZlIHNvbWV0aGluZyB1bmlxdWUgaW4geW91ciBlbnZpcm9ubWVu
dCwgYW5kIHdlIGRvbid0IGtub3cgd2hhdCBpdCBpcy4KClRvIGdhdGhlciBtb3JlIGluZm9ybWF0
aW9uLCBjYW4geW91IGFsc28gdHVybiBvbiB0cmFjZXBvaW50cyBmb3I6Cgp4ZnNfcmVuYW1lCnhm
c19jcmVhdGUKeGZzX2xpbmsKeGZzX3JlbW92ZQoKaW4gYWRkaXRpb24gdG8geGZzX2l1bmxpbmsg
YW5kIHhmc19pdW5saW5rX3JlbW92ZSwKYW5kIHdlJ2xsIHNlZSB3aGF0IHRoYXQgdGVsbHMgdXMu
CgpUaGVyZSBhcmUgbWFueSBwYXRocyB0aGF0IG1hbmlwdWxhdGUgdGhlIGRpX25saW5rIGNvdW50
LCBhbmQgc29tZXRoaW5nIGlzIHJhY2luZywgYnV0IHdlIGRvbid0IHlldCBrbm93IHdoYXQgdHdv
IGNhbGxjaGFpbnMgdGhleSBhcmUuCgpUaGUgYWJvdmUgYXJlIGFsbCB0aGUgY2FsbGVycyB0aGF0
IG1hbmlwdWxhdGUgdGhlIGxpbmsgY291bnQsIHNvIHRoZXkgd2lsbCB5aWVsZCBtb3JlIGluZm9y
bWF0aW9uIGFib3V0IHdobyBpcyBtYW5pcHVsYXRpbmcgdGhlIGNvdW50cy4KClRoYW5rcywKLUVy
aWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
