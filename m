Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF4D67CA3
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 10:45:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C1C1F8F804B
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 08:45:46 -0700 (PDT)
Received: from us-smtp-delivery-194.mimecast.com
	(us-smtp-delivery-194.mimecast.com [63.128.21.194]) by
	cuda.sgi.com with ESMTP id U7O9pKTBIs7hRWq0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Jun 2016 08:45:43 -0700 (PDT)
From: Trond Myklebust <trondmy@primarydata.com>
Subject: Re: [PATCH 10/12] NFS: Do not serialise O_DIRECT reads and writes
Date: Wed, 15 Jun 2016 15:45:37 +0000
Message-ID: <E6003989-FB5F-4FE8-A161-C6E52E031091@primarydata.com>
References: <1465931115-30784-7-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-8-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-9-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-10-git-send-email-trond.myklebust@primarydata.com>
	<20160615071343.GC4318@infradead.org>
	<755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
	<20160615144801.GB18524@infradead.org>
	<C13D01C1-4B83-442A-A0EA-D7624BE8A782@primarydata.com>
	<20160615145638.GC5297@infradead.org>
	<02DCF6B5-AFDF-4E33-A8F2-DBFE67A87E91@primarydata.com>
	<20160615151422.GA28557@infradead.org>
In-Reply-To: <20160615151422.GA28557@infradead.org>
Content-Language: en-US
Content-ID: <AFAC6D8D2B571444BA4EB0009FCE3AEF@namprd11.prod.outlook.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8369244879148495218=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8369244879148495218==
Content-Language: en-US
Content-ID: <AFAC6D8D2B571444BA4EB0009FCE3AEF@namprd11.prod.outlook.com>
Content-Type: multipart/alternative;
	boundary="MCBoundary=_11606151145415551"

--MCBoundary=_11606151145415551
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

DQoNCk9uIDYvMTUvMTYsIDExOjE0LCAiQ2hyaXN0b3BoIEhlbGx3aWciIDxoY2hAaW5mcmFkZWFk
Lm9yZz4gd3JvdGU6DQoNCj5PbiBXZWQsIEp1biAxNSwgMjAxNiBhdCAwMzowOToyM1BNICswMDAw
LCBUcm9uZCBNeWtsZWJ1c3Qgd3JvdGU6DQo+PiBBcyBJIHNhaWQgZWFybGllciwgdGhlIHByb2Js
ZW0gd2l0aCB0aGF0IGlzIHlvdSBlbmQgdXAgYXJ0aWZpY2lhbGx5IHNlcmlhbGlzaW5nIGJ1ZmZl
cmVkIHJlYWRzIGFuZCBidWZmZXJlZCB3cml0ZXMuDQo+DQo+SWYgeW91IGFjdHVhbGx5IHdhbnQg
dG8gYmUgUG9zaXggY29tcGlhbnQgeW91IG5lZWQgdG8gc2VyaWFsaXplIGJ1ZmZlcmVkDQo+cmVh
ZHMgYWdhaW5zdCBidWZmZXJlcmQgd3JpdGVzIC0gaXQncyBqdXN0IHRoYXQgbW9zdCBMaW51eCBm
aWxlIHN5c3RlbXMNCj5oYXBwZW4gdG8gZ2V0IHRoaXMgd3JvbmcuDQo+DQo+PiA/Pz8gVGhlIHJl
YWRzIG9ubHkgbmVlZCBhIHNoYXJlZCBsb2NrIGluIG9yZGVyIHRvIHByb3RlY3QgdGhlIEkvTyBt
b2RlIGZyb20gZmxpcHBpbmcgdG8gT19ESVJFQ1QgKGFuZCByZWx5aW5nIG9uIHBhZ2UgbG9ja3Mg
dG8gcHJvdGVjdCBhZ2FpbnN0IGJ1ZmZlcmVkIHdyaXRlcykuDQo+DQo+V2hpY2ggc3RyaWN0bHkg
c3BlYWtpbmcgaXMgbm90IGVub3VnaCwgYWx0aG91Z2ggYXMgc2FpZCBhYm92ZSBtb3N0DQo+TGlu
dXggZmlsZXN5c3RlbXMgZ2V0IHRoaXMgd3JvbmcuICBJZiB5b3UgaW5kZWVkIHdhbnQgdG8ga2Vl
cCB0aGF0DQo+KGluY29ycmVjdCkgYmVoYXZpb3IgeW91IG5lZWQgYW5vdGhlciBsb2NrLiAgSXQn
cyBkZWZpbnRpdmVseSBub3QNCj4ic2ltcGxlciIsIHRob3VnaC4NCj4NCg0KU2VyaWFsaXNhdGlv
biBpcyBub3QgbWFuZGF0b3J5IGluIFBPU0lYOg0KDQpodHRwOi8vcHVicy5vcGVuZ3JvdXAub3Jn
L29ubGluZXB1YnMvOTY5OTkxOTc5OS9mdW5jdGlvbnMvd3JpdGUuaHRtbA0KDQrigJxXcml0ZXMg
Y2FuIGJlIHNlcmlhbGl6ZWQgd2l0aCByZXNwZWN0IHRvIG90aGVyIHJlYWRzIGFuZCB3cml0ZXMu
IElmIGEgcmVhZCgpIG9mIGZpbGUgZGF0YSBjYW4gYmUgcHJvdmVuIChieSBhbnkgbWVhbnMpIHRv
IG9jY3VyIGFmdGVyIGEgd3JpdGUoKSBvZiB0aGUgZGF0YSwgaXQgbXVzdCByZWZsZWN0IHRoYXQg
d3JpdGUoKSwgZXZlbiBpZiB0aGUgY2FsbHMgYXJlIG1hZGUgYnkgZGlmZmVyZW50IHByb2Nlc3Nl
cy4gQSBzaW1pbGFyIHJlcXVpcmVtZW50IGFwcGxpZXMgdG8gbXVsdGlwbGUgd3JpdGUgb3BlcmF0
aW9ucyB0byB0aGUgc2FtZSBmaWxlIHBvc2l0aW9uLiBUaGlzIGlzIG5lZWRlZCB0byBndWFyYW50
ZWUgdGhlIHByb3BhZ2F0aW9uIG9mIGRhdGEgZnJvbSB3cml0ZSgpIGNhbGxzIHRvIHN1YnNlcXVl
bnQgcmVhZCgpIGNhbGxzLiBUaGlzIHJlcXVpcmVtZW50IGlzIHBhcnRpY3VsYXJseSBzaWduaWZp
Y2FudCBmb3IgbmV0d29ya2VkIGZpbGUgc3lzdGVtcywgd2hlcmUgc29tZSBjYWNoaW5nIHNjaGVt
ZXMgdmlvbGF0ZSB0aGVzZSBzZW1hbnRpY3Mu4oCdDQoNCkRpc2NsYWltZXINCg0KVGhlIGluZm9y
bWF0aW9uIGNvbnRhaW5lZCBpbiB0aGlzIGNvbW11bmljYXRpb24gZnJvbSB0aGUgc2VuZGVyIGlz
IGNvbmZpZGVudGlhbC4gSXQgaXMgaW50ZW5kZWQgc29sZWx5IGZvciB1c2UgYnkgdGhlIHJlY2lw
aWVudCBhbmQgb3RoZXJzIGF1dGhvcml6ZWQgdG8gcmVjZWl2ZSBpdC4gSWYgeW91IGFyZSBub3Qg
dGhlIHJlY2lwaWVudCwgeW91IGFyZSBoZXJlYnkgbm90aWZpZWQgdGhhdCBhbnkgZGlzY2xvc3Vy
ZSwgY29weWluZywgZGlzdHJpYnV0aW9uIG9yIHRha2luZyBhY3Rpb24gaW4gcmVsYXRpb24gb2Yg
dGhlIGNvbnRlbnRzIG9mIHRoaXMgaW5mb3JtYXRpb24gaXMgc3RyaWN0bHkgcHJvaGliaXRlZCBh
bmQgbWF5IGJlIHVubGF3ZnVsLg0K
--MCBoundary=_11606151145415551
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<HTML><body><BR>
<BR>
On 6/15/16, 11:14, &quot;Christoph Hellwig&quot; &lt;hch@infradead.org&gt; =
wrote:<BR>
<BR>
&gt;On Wed, Jun 15, 2016 at 03:09:23PM +0000, Trond Myklebust wrote:<BR>
&gt;&gt; As I said earlier, the problem with that is you end up artificiall=
y serialising buffered reads and buffered writes.<BR>
&gt;<BR>
&gt;If you actually want to be Posix compiant you need to serialize buffere=
d<BR>
&gt;reads against buffererd writes - it's just that most Linux file systems=
<BR>
&gt;happen to get this wrong.<BR>
&gt;<BR>
&gt;&gt; ??? The reads only need a shared lock in order to protect the I/O =
mode from flipping to O_DIRECT (and relying on page locks to protect agains=
t buffered writes).<BR>
&gt;<BR>
&gt;Which strictly speaking is not enough, although as said above most<BR>
&gt;Linux filesystems get this wrong.  If you indeed want to keep that<BR>
&gt;(incorrect) behavior you need another lock.  It's defintively not<BR>
&gt;&quot;simpler&quot;, though.<BR>
&gt;<BR>
<BR>
Serialisation is not mandatory in POSIX:<BR>
<BR>
<a href=3D"http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.=
html" target=3D"_blank">http://pubs.opengroup.org/onlinepubs/9699919799/fun=
ctions/write.html</a><BR>
<BR>
=E2=80=9CWrites can be serialized with respect to other reads and writes. I=
f a read() of file data can be proven (by any means) to occur after a write=
() of the data, it must reflect that write(), even if the calls are made by=
 different processes. A similar requirement applies to multiple write opera=
tions to the same file position. This is needed to guarantee the propagatio=
n of data from write() calls to subsequent read() calls. This requirement i=
s particularly significant for networked file systems, where some caching s=
chemes violate these semantics.=E2=80=9D<BR>
<br /><br /><p style=3D"font-family: Verdana; font-size:10pt; color:#666666=
;"><b>Disclaimer</b></p><p style=3D"font-family: Verdana; font-size:8pt; co=
lor:#666666;">The information contained in this communication from the send=
er is confidential. It is intended solely for use by the recipient and othe=
rs authorized to receive it. If you are not the recipient, you are hereby n=
otified that any disclosure, copying, distribution or taking action in rela=
tion of the contents of this information is strictly prohibited and may be =
unlawful.<br /></p></body></HTML>

--MCBoundary=_11606151145415551--


--===============8369244879148495218==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8369244879148495218==--
