Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C77957CA4
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 10:09:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BE14AC005
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 08:09:35 -0700 (PDT)
Received: from us-smtp-delivery-194.mimecast.com
	(us-smtp-delivery-194.mimecast.com [216.205.24.194]) by
	cuda.sgi.com with ESMTP id Ky4aWV5f6Cov9fKw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Jun 2016 08:09:30 -0700 (PDT)
From: Trond Myklebust <trondmy@primarydata.com>
Subject: Re: [PATCH 10/12] NFS: Do not serialise O_DIRECT reads and writes
Date: Wed, 15 Jun 2016 15:09:23 +0000
Message-ID: <02DCF6B5-AFDF-4E33-A8F2-DBFE67A87E91@primarydata.com>
References: <1465931115-30784-5-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-6-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-7-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-8-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-9-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-10-git-send-email-trond.myklebust@primarydata.com>
	<20160615071343.GC4318@infradead.org>
	<755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
	<20160615144801.GB18524@infradead.org>
	<C13D01C1-4B83-442A-A0EA-D7624BE8A782@primarydata.com>
	<20160615145638.GC5297@infradead.org>
In-Reply-To: <20160615145638.GC5297@infradead.org>
Content-Language: en-US
Content-ID: <5594A498DF247448A4B9742EF574217F@namprd11.prod.outlook.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4680638439736777196=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4680638439736777196==
Content-Language: en-US
Content-ID: <5594A498DF247448A4B9742EF574217F@namprd11.prod.outlook.com>
Content-Type: multipart/alternative;
	boundary="MCBoundary=_11606151109270731"

--MCBoundary=_11606151109270731
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

DQoNCk9uIDYvMTUvMTYsIDEwOjU2LCAiQ2hyaXN0b3BoIEhlbGx3aWciIDxoY2hAaW5mcmFkZWFk
Lm9yZz4gd3JvdGU6DQoNCj5PbiBXZWQsIEp1biAxNSwgMjAxNiBhdCAwMjo1MjoyNFBNICswMDAw
LCBUcm9uZCBNeWtsZWJ1c3Qgd3JvdGU6DQo+PiA+QnV0IFhGUyBhbGxvd3MgZnVsbCBwYXJhbGxl
bGlzbSBmb3IgZGlyZWN0IHJlYWRzIGFuZCB3cml0ZXMgYXMgbG9uZw0KPj4gPmFzIHRoZXJlIGlz
IG5vIG1vcmUgcGFnZWNhY2hlIHRvIGZsdXNoLiAgQnV0IGlmIHlvdSBoYXZlIHBhZ2VzIGluDQo+
PiA+dGhlIHBhZ2VjYWNoZSB5b3UgbmVlZCB0aGUgZXhjbHVzaXZlIGxvY2sgdG8gcHJldmVudCBh
Z2FpbnN0IG5ldw0KPj4gPnBhZ2VjYWNoZSBwYWdlcyBiZWluZyBhZGRlZC4NCj4+IA0KPj4gRXhh
Y3RseS4gU28gZG9lcyB0aGlzLg0KPg0KPlNvIGxldCdzIGF2b2lkIGJsb2F0aW5nIHRoZSBpbm9k
ZSB3aXRoIGFub3RoZXIgcndfc2VtYXBob3JlLCBhbmQgbWFrZQ0KPmV2ZXJ5b25lcyBsaWZlIGVh
c2llciBieSB1c2luZyB0aGUgZXhpc3RpbmcgbG9jay4NCg0KQXMgSSBzYWlkIGVhcmxpZXIsIHRo
ZSBwcm9ibGVtIHdpdGggdGhhdCBpcyB5b3UgZW5kIHVwIGFydGlmaWNpYWxseSBzZXJpYWxpc2lu
ZyBidWZmZXJlZCByZWFkcyBhbmQgYnVmZmVyZWQgd3JpdGVzLg0KDQrigKIgVGhlIHJlYWRzIG9u
bHkgbmVlZCBhIHNoYXJlZCBsb2NrIGluIG9yZGVyIHRvIHByb3RlY3QgdGhlIEkvTyBtb2RlIGZy
b20gZmxpcHBpbmcgdG8gT19ESVJFQ1QgKGFuZCByZWx5aW5nIG9uIHBhZ2UgbG9ja3MgdG8gcHJv
dGVjdCBhZ2FpbnN0IGJ1ZmZlcmVkIHdyaXRlcykuDQrigKIgVGhlIHdyaXRlcyBuZWVkIHByb3Rl
Y3Rpb24gYWdhaW5zdCBPX0RJUkVDVCwgdGhleSBkb27igJl0IG5lZWQgc2VyaWFsaXNhdGlvbiB3
aXRoIG90aGVyIHJlYWRzLCBidXQgdGhleSBkbyBuZWVkIHRvIGJlIHNlcmlhbGlzZWQgYWdhaW5z
dCBvdGhlciBidWZmZXJlZCB3cml0ZXMuDQoNCkRpc2NsYWltZXINCg0KVGhlIGluZm9ybWF0aW9u
IGNvbnRhaW5lZCBpbiB0aGlzIGNvbW11bmljYXRpb24gZnJvbSB0aGUgc2VuZGVyIGlzIGNvbmZp
ZGVudGlhbC4gSXQgaXMgaW50ZW5kZWQgc29sZWx5IGZvciB1c2UgYnkgdGhlIHJlY2lwaWVudCBh
bmQgb3RoZXJzIGF1dGhvcml6ZWQgdG8gcmVjZWl2ZSBpdC4gSWYgeW91IGFyZSBub3QgdGhlIHJl
Y2lwaWVudCwgeW91IGFyZSBoZXJlYnkgbm90aWZpZWQgdGhhdCBhbnkgZGlzY2xvc3VyZSwgY29w
eWluZywgZGlzdHJpYnV0aW9uIG9yIHRha2luZyBhY3Rpb24gaW4gcmVsYXRpb24gb2YgdGhlIGNv
bnRlbnRzIG9mIHRoaXMgaW5mb3JtYXRpb24gaXMgc3RyaWN0bHkgcHJvaGliaXRlZCBhbmQgbWF5
IGJlIHVubGF3ZnVsLg0K
--MCBoundary=_11606151109270731
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<HTML><body><BR>
<BR>
On 6/15/16, 10:56, &quot;Christoph Hellwig&quot; &lt;hch@infradead.org&gt; =
wrote:<BR>
<BR>
&gt;On Wed, Jun 15, 2016 at 02:52:24PM +0000, Trond Myklebust wrote:<BR>
&gt;&gt; &gt;But XFS allows full parallelism for direct reads and writes as=
 long<BR>
&gt;&gt; &gt;as there is no more pagecache to flush.  But if you have pages=
 in<BR>
&gt;&gt; &gt;the pagecache you need the exclusive lock to prevent against n=
ew<BR>
&gt;&gt; &gt;pagecache pages being added.<BR>
&gt;&gt; <BR>
&gt;&gt; Exactly. So does this.<BR>
&gt;<BR>
&gt;So let's avoid bloating the inode with another rw_semaphore, and make<B=
R>
&gt;everyones life easier by using the existing lock.<BR>
<BR>
As I said earlier, the problem with that is you end up artificially seriali=
sing buffered reads and buffered writes.<BR>
<BR>
=E2=80=A2 The reads only need a shared lock in order to protect the I/O mod=
e from flipping to O_DIRECT (and relying on page locks to protect against b=
uffered writes).<BR>
=E2=80=A2 The writes need protection against O_DIRECT, they don=E2=80=99t n=
eed serialisation with other reads, but they do need to be serialised again=
st other buffered writes.<BR>
<br /><br /><p style=3D"font-family: Verdana; font-size:10pt; color:#666666=
;"><b>Disclaimer</b></p><p style=3D"font-family: Verdana; font-size:8pt; co=
lor:#666666;">The information contained in this communication from the send=
er is confidential. It is intended solely for use by the recipient and othe=
rs authorized to receive it. If you are not the recipient, you are hereby n=
otified that any disclosure, copying, distribution or taking action in rela=
tion of the contents of this information is strictly prohibited and may be =
unlawful.<br /></p></body></HTML>

--MCBoundary=_11606151109270731--


--===============4680638439736777196==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4680638439736777196==--
