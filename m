Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7A8C429DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 13:39:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45DD930404E
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 11:39:16 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id yBl2PiKtM52aG9YZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 11:39:15 -0700 (PDT)
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 4 Jun 2013 12:39:14 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 446CA1FF0020
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 12:34:00 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r54Id0FC113974 for <xfs@oss.sgi.com>; Tue, 4 Jun 2013 12:39:02 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r54IceFk009532
	for <xfs@oss.sgi.com>; Tue, 4 Jun 2013 12:38:45 -0600
Subject: Re: Debunking myths about metadata CRC overhead
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130604025307.GB29466@dastard>
References: <20130603074452.GZ29466@dastard>
	<20130603111011.461d10b5@galadriel.home>
	<20130604025307.GB29466@dastard>
Date: Tue, 04 Jun 2013 13:38:29 -0500
Message-ID: <1370371109.3898.10.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

T24gVHVlLCAyMDEzLTA2LTA0IGF0IDEyOjUzICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
T24gTW9uLCBKdW4gMDMsIDIwMTMgYXQgMTE6MTA6MTFBTSArMDIwMCwgRW1tYW51ZWwgRmxvcmFj
IHdyb3RlOgo+ID4gTGUgTW9uLCAzIEp1biAyMDEzIDE3OjQ0OjUyICsxMDAwIHZvdXMgw6ljcml2
aWV6Ogo+ID4gCj4gPiA+IFRoZXJlIGhhcyBiZWVuIHNvbWUgYXNzZXJ0aW9ucyBtYWRlIHJlY2Vu
dGx5IHRoYXQgbWV0YWRhdGEgQ1JDcyBoYXZlCj4gPiA+IHRvbyBtdWNoIG92ZXJoZWFkIHRvIGFs
d2F5cyBiZSBlbmFibGVkLiAgU28gSSdsbCBydW4gc29tZSBxdWljawo+ID4gPiBiZW5jaG1hcmtz
IHRvIGRlbW9uc3RyYXRlIHRoZSAidG9vIG11Y2ggb3ZlcmhlYWQiIGFzc2VydGlvbnMgYXJlCj4g
PiA+IGNvbXBsZXRlbHkgdW5mb3VuZGVkLgo+ID4gCj4gPiBKdXN0IGEgcXVpY2sgcXVlc3Rpb246
IHdoYXQgaXMgdGhlIG1pbmltYWwga2VybmVsIHZlcnNpb24gYW5kIHhmc3Byb2dzCj4gPiB2ZXJz
aW9uIG5lZWRlZCB0byBydW4geGZzIHdpdGggbWV0YWRhdGEgQ1JDPyBJJ2QgaGFwcGlseSB0ZXN0
IGl0IG9uCj4gPiByZWFsIGhhcmR3YXJlLCBJIGhhdmUgYSBjb3VwbGUgb2Ygc3RvcmFnZSBzZXJ2
ZXJzIGluIHRlc3QgaW4gdGhlIDQwIHRvCj4gPiAxMDggVEIgcmFuZ2UuCj4gCj4gSWYgdGhlIG1h
aW50YWluZXJzIG1lcmdlIGFsbCB0aGUgcGF0Y2hlcyBJIHNlbmQgZm9yIHRoZSAzLjEwLXJjCj4g
c2VyaWVzLCB0aGVuIHRoZSAzLjEwIHJlbGVhc2Ugc2hvdWxkIGJlIHN0YWJsZSBlbm91Z2ggdG8g
dXNlIGZvcgo+IHRlc3Rpbmcgd2l0aCBkYXRhIHlvdSBkb24ndCBjYXJlIGlmIHlvdSBsb3NlLgo+
IAo+IEFzIGZvciB0aGUgdXNlcnNwYWNlIGNvZGUgLSB0aGF0IGlzIHN0aWxsIGp1c3QgYSBwYXRj
aHNldC4gSSBoYXZlbid0Cj4gaGFkIGFueSBmZWVkYmFjayBmcm9tIHRoZSBtYWludGFpbmVycyBh
Ym91dCBpdCBpbiB0aGUgcGFzdCBtb250aCwgc28KPiBJJ3ZlIGdvdCBubyBpZGVhIHdoYXQgdGhl
eSBhcmUgZG9pbmcgd2l0aCBpdC4gSSdsbCBwb3N0IG91dCBhIG5ldwo+IHZlcnNpb24gaW4gdGhl
IG5leHQgY291cGxlIG9mIGRheXMgLSBpdCdzIDUwLW9kZCBwYXRjaGVzIGJ5IG5vdywgc28KPiBp
dCdkIGJlIG5pY2UgdG8gaGF2ZSBpdCBpbiB0aGUgeGZzcHJvZ3MgZ2l0IHRyZWUgc28gcGVvcGxl
IGNvdWxkCj4ganVzdCBwdWxsIGl0IGFuZCBidWlsZCBpdCBmb3IgdGVzdGluZyBwdXJwb3NlcyBi
eSB0aGUgdGltZSB0aGF0IDMuMTAKPiByZWxlYXNlcy4uLi4KCkRhdmUsCgpJIHdhcyBvZiB0aGUg
aW1wcmVzc2lvbiB0aGF0IHRoZSB1c2VyIHNwYWNlIGNoYW5nZXMgd2lsbCBiZSByZWxlYXNlZApz
b21ldGltZSBsYXRlciAoaS5lIHdoZW4gQ1JDIGNvbWVzIG91dCBvZiBleHBlcmltZW50YWwpLiBJ
ZiB3ZSBtYWtlIHRoZQp1c2VyIHNwYWNlIGNoYW5nZXMgdG8gY3JlYXRlIFY1IGZpbGVzeXN0ZW0g
bm93LCBpdCB3aWxsIGJlIGFuIGFubm95YW5jZQpmb3IgcGVvcGxlIHRoYXQgY3JlYXRlZCBWNSBz
dXBlciBibG9ja3Mgd2l0aG91dCBteSBjaGFuZ2VzIChnZXR0aW5nIHJpZApvZiBPUVVPVEEuKiBm
bGFncykuIAoKQlRXLCBJIGFtIHdhaXRpbmcgZm9yIHlvdXIgcmVzcG9uc2UgdG8gZG8gYSBmaW5h
bCByZS1wb3N0IG9uIHRoZSBrZXJuZWwKY2hhbmdlcywgYWZ0ZXIgd2hpY2ggSSB3aWxsIHBvc3Qg
bXkgdXNlciBzcGFjZSBjaGFuZ2VzLgoKUmVnYXJkcywKCkNoYW5kcmEKPiAKPiBDaGVlcnMsCj4g
Cj4gRGF2ZQoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWls
bWFuL2xpc3RpbmZvL3hmcwo=
