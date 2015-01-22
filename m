Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 613C77F59
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 10:21:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CB3C304051
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 08:21:04 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id gNGut3qnUmzPBtBE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 08:21:02 -0800 (PST)
Date: Thu, 22 Jan 2015 17:21:00 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: a simple and scalable pNFS block layout server V2
Message-ID: <20150122162100.GA10801@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<0851E625-04F8-4DE0-971D-1EAB591B3F28@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0851E625-04F8-4DE0-971D-1EAB591B3F28@oracle.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

T24gVGh1LCBKYW4gMjIsIDIwMTUgYXQgMTE6MDQ6MTVBTSAtMDUwMCwgQ2h1Y2sgTGV2ZXIgd3Jv
dGU6Cj4gSeKAmW0gc3RpbGwgbm90IGNsZWFyIG9uIHdoYXQgbGF5b3V0IHR5cGVzIGFyZSBzdXBw
b3J0ZWQuIENsZWFybHkKPiB0aGUgYmxvY2sgbGF5b3V0IHR5cGUgaXMgc3VwcG9ydGVkLiBCdXQg
eW91IG1lbnRpb24gWEZTIGhlcmUuIERvZXMKPiB0aGF0IG1lYW4gZmlsZSBsYXlvdXRzIGFyZSBh
bHNvIHN1cHBvcnRlZCBub3c/IElmIHNvLCBjYW4geW91Cj4gYnJpZWZseSBkZXNjcmliZSB0aGUg
YXJjaGl0ZWN0dXJlIGFuZCBhbnkgY3VycmVudCBsaW1pdGF0aW9ucz8KPiAKPiBEaWQgSSBtaXNz
IGRvY3VtZW50YXRpb24gZm9yIGhvdyBhZG1pbmlzdHJhdG9ycyBjb25zdHJ1Y3QgbGF5b3V0cz8K
Ck9ubHkgYmxvY2sgbGF5b3V0cyBhcmUgc3VwcG9ydGUgYXQgdGhlIG1vbWVudC4gIFRoZXkgYXJl
IGF1dG9tYXRpY2FsbHkKZW5hYmxlZCB3aGVuIGFuIFhGUyBmaWxlc3lzdGVtIGlzIGV4cG9ydGVk
LiAgIFRoZXJlIGlzIG5vIHJlcXVpcmVtZW50CmZvciB0aGUgYWRtaW5pc3RyYXRvciB0byBjb25z
dHJ1Y3QgaW4gbGF5b3V0LCB0aGUgb25seSByZXF1aXJlbWVudApmb3Igd29ya2luZyBibG9jayBs
YXlvdXRzIGlzIHNoYXJlZCBzdG9yYWdlIHRoYXQgaXMgYWNjZXNzaWJsZQp0byB0aGUgTkZTIFNl
cnZlciAvIE1EUyBhbmQgdGhlIGNsaWVudHMgdGhhdCB3aXNoIHRvIHVzZSBwTkZT4oClCgpJZiB5
b3UgYXJlIGludGVyZXN0ZWQgaW4gZmlsZSBsYXlvdXQgc3VwcG9ydCBwb3J0aW5nIG92ZXIgdGhl
IGV4aXN0aW5nCmZpbGUgbGF5b3V0IGRyaXZlcnMgZnJvbSB0aGUgb2xkIHBORlMgc2VydmVyIHRy
ZWUgc2hvdWxkIG9ubHkgYmUKYSBtb2RlcmF0ZSBlZmZvcnQsIGFuZCBhdCBsZWFzdCB0aGUgbGV4
cCBjb2RlIHdvdWxkIGJlIGdyYXRlbHkKc2ltcGxpZmllZCBieSB0aGUgY29tbW9uIHJlY2FsbCBp
bmZyYXN0cnVjdHVyZSBpbiB0aGlzIHNlcmllcy4KCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
