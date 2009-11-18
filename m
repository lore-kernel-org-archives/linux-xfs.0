Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAI8uSdK134464 for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 02:56:28 -0600
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 7/7] xfs: Don't use PF_MEMALLOC
In-Reply-To: <20091117221108.GK9467@discord.disaster>
References: <20091117162235.3DEB.A69D9226@jp.fujitsu.com>
	<20091117221108.GK9467@discord.disaster>
Message-Id: <20091118153302.3E20.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 17:56:46 +0900 (JST)
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>, kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

PiBPbiBUdWUsIE5vdiAxNywgMjAwOSBhdCAwNDoyMzo0M1BNICswOTAwLCBLT1NBS0kgTW90b2hp
cm8gd3JvdGU6Cj4gPiAKPiA+IE5vbiBNTSBzdWJzeXN0ZW0gbXVzdCBub3QgdXNlIFBGX01FTUFM
TE9DLiBNZW1vcnkgcmVjbGFpbSBuZWVkIGZldwo+ID4gbWVtb3J5LCBhbnlvbmUgbXVzdCBub3Qg
cHJldmVudCBpdC4gT3RoZXJ3aXNlIHRoZSBzeXN0ZW0gY2F1c2UKPiA+IG15c3RlcmlvdXMgaGFu
Zy11cCBhbmQvb3IgT09NIEtpbGxlciBpbnZva2F0aW9uLgo+IAo+IFRoZSB4ZnNidWZkIGlzIGEg
d29rZW4gcnVuIGJ5IGEgcmVnaXN0ZXJlZCBtZW1vcnkgc2hha2VyLiBpLmUuIGl0Cj4gcnVucyB3
aGVuIHRoZSBzeXN0ZW0gbmVlZHMgdG8gcmVjbGFpbSBtZW1vcnkuIEl0IGZvcmNl0ZUgdGhlCj4g
ZGVsYXllZCB3cml0ZSBtZXRhZGF0YSBidWZmZXJzIChvZiB3aGljaCB0aGVyZSBjYW4gYmUgYSBs
b3QpIHRvIGRpc2sKPiBzbyB0aGF0IHRoZXkgY2FuIGJlIHJlY2xhaW1lZCBvbiBJTyBjb21wbGV0
aW9uLiBUaGlzIElPIHN1Ym1pc3Npb24KPiBtYXkgcmVxdWlyZSDRlW9tZSBtZW1vcnkgdG8gYmUg
YWxsb2NhdGVkIHRvIGJlIGFibGUgdG8gZnJlZSB0aGF0Cj4gbWVtb3J5Lgo+IAo+IEhlbmNlLCBB
RkFJQ1QgdGhlIHVzZSBvZiBQRl9NRU1BTExPQyBpcyB2YWxpZCBoZXJlLgoKVGhhbmtzIGEgbG90
LiAKSSBoYXZlIG9uZSBhZGRpdGlvbmFsIHF1ZXN0aW9uLCBtYXkgSSBhc2sgeW91PwoKSG93IGNh
biB3ZSBjYWxjdWxhdGUgbWF4aW11bSBtZW1vcnkgdXNhZ2UgaW4geGZzYnVmZD8KSSdtIGFmcmFp
ZCB0aGF0IFZNIGFuZCBYRlMgd29ya3MgcHJvcGVybHkgYnV0IGFkZGluZyB0d28gbWFrZXMgbWVt
b3J5IGV4aGF1c3QuCgpBbmQsIEkgY29uY2x1ZGUgWEZTIGRvZXNuJ3QgbmVlZCBzaGFyaW5nIHJl
c2VydmF0aW9uIG1lbW9yeSB3aXRoIFZNLAppdCBvbmx5IG5lZWQgbm9uIGZhaWxlZCBhbGxvY2F0
aW9uLiByaWdodD8gSU9XIEknbSBwcmVmZXIgcGVydGVyJ3MKc3VnZ2VzdGlvbi4KCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
