Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 668E27CA2
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 09:52:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4F02AC002
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 07:52:50 -0700 (PDT)
Received: from us-smtp-delivery-194.mimecast.com
	(us-smtp-delivery-194.mimecast.com [63.128.21.194]) by
	cuda.sgi.com with ESMTP id hBcz4gCySPB9AEJC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Jun 2016 07:52:31 -0700 (PDT)
From: Trond Myklebust <trondmy@primarydata.com>
Subject: Re: [PATCH 10/12] NFS: Do not serialise O_DIRECT reads and writes
Date: Wed, 15 Jun 2016 14:52:24 +0000
Message-ID: <C13D01C1-4B83-442A-A0EA-D7624BE8A782@primarydata.com>
References: <1465931115-30784-3-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-4-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-5-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-6-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-7-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-8-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-9-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-10-git-send-email-trond.myklebust@primarydata.com>
	<20160615071343.GC4318@infradead.org>
	<755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
	<20160615144801.GB18524@infradead.org>
In-Reply-To: <20160615144801.GB18524@infradead.org>
Content-Language: en-US
Content-ID: <03C34F082829B84FB19C8F422DED8E81@namprd11.prod.outlook.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6527841080106357650=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6527841080106357650==
Content-Language: en-US
Content-ID: <03C34F082829B84FB19C8F422DED8E81@namprd11.prod.outlook.com>
Content-Type: multipart/alternative;
	boundary="MCBoundary=_11606151052282941"

--MCBoundary=_11606151052282941
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

T24gNi8xNS8xNiwgMTA6NDgsICJDaHJpc3RvcGggSGVsbHdpZyIgPGhjaEBpbmZyYWRlYWQub3Jn
PiB3cm90ZToNCg0KPk9uIFdlZCwgSnVuIDE1LCAyMDE2IGF0IDAyOjI5OjQyUE0gKzAwMDAsIFRy
b25kIE15a2xlYnVzdCB3cm90ZToNCj4+IFRoZSBsb2NraW5nIGlzIGFjdHVhbGx5IHNpbXBsZXIg
dGhhbiBYRlMuDQo+DQo+SXQgbG9va3Mgd2F5IG1vcmUgY29tcGxpY2F0ZWQuICBBbmQgdG90YWxs
eSB1bmRvY3VtZW50ZWQuDQo+DQo+PiBXZSBoYXZlIDIgSS9PIG1vZGVzOiBidWZmZXJlZCBJL08g
YW5kIGRpcmVjdCBJL08uIFRoZSB3cml0ZSBsb2NrIGlzIHRoZXJlIHRvIGVuc3VyZSBzYWZlIHRy
YW5zaXRpb25zIGJldHdlZW4gdGhvc2UgMiBtb2RlcywgYnV0IG9uY2UgdGhlIG1vZGUgaXMgc2V0
LA0KPj4gd2UgX29ubHlfIHVzZSBzaGFyZWQgbG9ja3MgaW4gb3JkZXIgdG8gYWxsb3cgcGFyYWxs
ZWxpc20uDQo+DQo+RnJvbSByZWFkaW5nIHRoZSBwYXRjaCB0aGF0J3Mgbm90IHdoYXQgYWN0dWFs
bHkgaGFwcGVucyAtIEkgdGhpbmsgeW91J3JlDQo+c3RpbGwgdGFraW5nIGlfcndzZW0gZXhjbHVz
aXZlIGZvciBidWZmZXJlZCB3cml0ZXMsIGFyZW4ndCB5b3U/DQo+DQo+RG9pbmcgdGhhdCBpcyBh
YnNvbHV0ZWx5IG1hbmRhdG9yeSBmb3IgUG9zaXggYXRvbWljeSByZXF1aXJlbWVudHMsIG9yDQo+
eW91J2xsIGJyZWFrIHRvbnMgb2Ygb2YgYXBwbGljYXRpb25zLg0KDQpZZXMuIFdlIGNvbnRpbnVl
IHRvIGxldCB0aGUgVkZTIG1hbmFnZSBzZXJpYWxpc2F0aW9uIG9mIHdyaXRlcy4NCg0KPkJ1dCBY
RlMgYWxsb3dzIGZ1bGwgcGFyYWxsZWxpc20gZm9yIGRpcmVjdCByZWFkcyBhbmQgd3JpdGVzIGFz
IGxvbmcNCj5hcyB0aGVyZSBpcyBubyBtb3JlIHBhZ2VjYWNoZSB0byBmbHVzaC4gIEJ1dCBpZiB5
b3UgaGF2ZSBwYWdlcyBpbg0KPnRoZSBwYWdlY2FjaGUgeW91IG5lZWQgdGhlIGV4Y2x1c2l2ZSBs
b2NrIHRvIHByZXZlbnQgYWdhaW5zdCBuZXcNCj5wYWdlY2FjaGUgcGFnZXMgYmVpbmcgYWRkZWQu
DQoNCkV4YWN0bHkuIFNvIGRvZXMgdGhpcy4NCg0KPj4gPlRoZSBuaWNlIHRoaW5nIGlzIHRoYW4g
aW4gNC43LXJjIGlfbXV0ZXggaGFzIGJlZW4gcmVwbGFjZWQgd2l0aCBhDQo+PiA+cndfbXV0ZXgg
c28geW91IGNhbiBqdXN0IHVzZSB0aGF0IGluIHNoYXJlZCBtb2RlIGZvciBkaXJlY3QgSS9PDQo+
PiA+YXMtaXMgd2l0aG91dCBuZWVkaW5nIGFueSBuZXcgbG9jay4NCj4+IA0KPj4gV2Ugd291bGQg
ZW5kIHVwIHNlcmlhbGlzaW5nIHJlYWRzIGFuZCB3cml0ZXMsIHNpbmNlIHRoZSBsYXR0ZXIgZ3Jh
YiBhbg0KPj4gZXhjbHVzaXZlIGxvY2sgaW4gZ2VuZXJpY19maWxlX3dyaXRlKCkuIFdoeSBkbyB0
aGF0IGlmIHdlIGRvbj8/P3QgaGF2ZSB0bz8NCj4NCj5Mb29rcyBhdCB0aGUgWEZTIGNvZGUgLSBu
byBzZXJpYWxpemF0aW9uIGJldHdlZW4gZGlyZWN0IHJlYWRzIGFuZCB3cml0ZXMNCj5hcyBsb25n
IGFzIG5vIGJ1ZmZlcmVkIEkvTyBjYW1lIGluIGluYmV0d2Vlbi4NCj4NCj5BbmQgZG9uJ3QgdXNl
IGdlbmVyaWNfZmlsZV97cmVhZCx3cml0ZX1faXRlciBpZiB5b3Ugd2FudCB0byBkbyBkaXJlY3Qg
SS9PLA0KPnVuZm9ydHVuYXRlbHkgbG9ja2luZyBpbiBtbS9maWxlbWFwLmMgaXMgdG90YWxseSBz
Y3Jld2VkIGZvciBkaXJlY3QgSS9PLA0KPnRha2UgYSBsb29rIGF0IFhGUyB3aGljaCBpcyB3aGVy
ZSBkaXJlY3QgSS9PIGNhbWUgZnJvbSBhbmQgd2hlcmUgd2UgZ2V0DQo+dGhlIGxvY2tpbmcgcmln
aHQuDQoNCldlIGRvbuKAmXQgdXNlIGdlbmVyaWNfZmlsZV8qIGZvciBPX0RJUkVDVDsgd2Ugb25s
eSB1c2UgaXQgZm9yIGJ1ZmZlcmVkIEkvTy4NCg0KRGlzY2xhaW1lcg0KDQpUaGUgaW5mb3JtYXRp
b24gY29udGFpbmVkIGluIHRoaXMgY29tbXVuaWNhdGlvbiBmcm9tIHRoZSBzZW5kZXIgaXMgY29u
ZmlkZW50aWFsLiBJdCBpcyBpbnRlbmRlZCBzb2xlbHkgZm9yIHVzZSBieSB0aGUgcmVjaXBpZW50
IGFuZCBvdGhlcnMgYXV0aG9yaXplZCB0byByZWNlaXZlIGl0LiBJZiB5b3UgYXJlIG5vdCB0aGUg
cmVjaXBpZW50LCB5b3UgYXJlIGhlcmVieSBub3RpZmllZCB0aGF0IGFueSBkaXNjbG9zdXJlLCBj
b3B5aW5nLCBkaXN0cmlidXRpb24gb3IgdGFraW5nIGFjdGlvbiBpbiByZWxhdGlvbiBvZiB0aGUg
Y29udGVudHMgb2YgdGhpcyBpbmZvcm1hdGlvbiBpcyBzdHJpY3RseSBwcm9oaWJpdGVkIGFuZCBt
YXkgYmUgdW5sYXdmdWwuDQo=
--MCBoundary=_11606151052282941
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<HTML><body>On 6/15/16, 10:48, &quot;Christoph Hellwig&quot; &lt;hch@infrad=
ead.org&gt; wrote:<BR>
<BR>
&gt;On Wed, Jun 15, 2016 at 02:29:42PM +0000, Trond Myklebust wrote:<BR>
&gt;&gt; The locking is actually simpler than XFS.<BR>
&gt;<BR>
&gt;It looks way more complicated.  And totally undocumented.<BR>
&gt;<BR>
&gt;&gt; We have 2 I/O modes: buffered I/O and direct I/O. The write lock i=
s there to ensure safe transitions between those 2 modes, but once the mode=
 is set,<BR>
&gt;&gt; we _only_ use shared locks in order to allow parallelism.<BR>
&gt;<BR>
&gt;From reading the patch that's not what actually happens - I think you'r=
e<BR>
&gt;still taking i_rwsem exclusive for buffered writes, aren't you?<BR>
&gt;<BR>
&gt;Doing that is absolutely mandatory for Posix atomicy requirements, or<B=
R>
&gt;you'll break tons of of applications.<BR>
<BR>
Yes. We continue to let the VFS manage serialisation of writes.<BR>
<BR>
&gt;But XFS allows full parallelism for direct reads and writes as long<BR>
&gt;as there is no more pagecache to flush.  But if you have pages in<BR>
&gt;the pagecache you need the exclusive lock to prevent against new<BR>
&gt;pagecache pages being added.<BR>
<BR>
Exactly. So does this.<BR>
<BR>
&gt;&gt; &gt;The nice thing is than in 4.7-rc i_mutex has been replaced wit=
h a<BR>
&gt;&gt; &gt;rw_mutex so you can just use that in shared mode for direct I/=
O<BR>
&gt;&gt; &gt;as-is without needing any new lock.<BR>
&gt;&gt; <BR>
&gt;&gt; We would end up serialising reads and writes, since the latter gra=
b an<BR>
&gt;&gt; exclusive lock in generic_file_write(). Why do that if we don???t =
have to?<BR>
&gt;<BR>
&gt;Looks at the XFS code - no serialization between direct reads and write=
s<BR>
&gt;as long as no buffered I/O came in inbetween.<BR>
&gt;<BR>
&gt;And don't use generic_file_{read,write}_iter if you want to do direct I=
/O,<BR>
&gt;unfortunately locking in mm/filemap.c is totally screwed for direct I/O=
,<BR>
&gt;take a look at XFS which is where direct I/O came from and where we get=
<BR>
&gt;the locking right.<BR>
<BR>
We don=E2=80=99t use generic_file_* for O_DIRECT; we only use it for buffer=
ed I/O.<BR>
<br /><br /><p style=3D"font-family: Verdana; font-size:10pt; color:#666666=
;"><b>Disclaimer</b></p><p style=3D"font-family: Verdana; font-size:8pt; co=
lor:#666666;">The information contained in this communication from the send=
er is confidential. It is intended solely for use by the recipient and othe=
rs authorized to receive it. If you are not the recipient, you are hereby n=
otified that any disclosure, copying, distribution or taking action in rela=
tion of the contents of this information is strictly prohibited and may be =
unlawful.<br /></p></body></HTML>

--MCBoundary=_11606151052282941--


--===============6527841080106357650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6527841080106357650==--
