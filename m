Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4B9B7F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 08:39:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C7C8AC006
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 06:39:22 -0700 (PDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
	[209.85.217.177]) by cuda.sgi.com with ESMTP id
	BKKDqDtFhKXy9zK6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 06:39:17 -0700 (PDT)
Received: by lbwr8 with SMTP id r8so20322337lbw.2
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 06:39:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151012040545.GC27164@dastard>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
	<20151012001033.GA27164@dastard>
	<CAHpGcMKeJHDegs2cYKaJdX4Tw43Jp30Nv_2WoSNZfBzGJKu=BQ@mail.gmail.com>
	<20151012040545.GC27164@dastard>
Date: Tue, 13 Oct 2015 15:39:15 +0200
Message-ID: <CAHc6FU7aNW3drN+Mj2PHyz0Tv8RHexSuUzWCPnCA7eCWY68pHQ@mail.gmail.com>
Subject: Re: [PATCH v10 24/46] xfs: Add richacl support
From: Andreas Gruenbacher <agruenba@redhat.com>
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
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API Mailing List <linux-api@vger.kernel.org>, =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

T24gTW9uLCBPY3QgMTIsIDIwMTUgYXQgNjowNSBBTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9t
b3JiaXQuY29tPiB3cm90ZToKPiBPbiBNb24sIE9jdCAxMiwgMjAxNSBhdCAwMzo1MToxNUFNICsw
MjAwLCBBbmRyZWFzIEdyw7xuYmFjaGVyIHdyb3RlOgo+PiAyMDE1LTEwLTEyIDI6MTAgR01UKzAy
OjAwIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT46Cj4+ID4gQWxzbywgSSByZWFs
bHkgZGlzbGlrZSB0aGUgQVBJIHdoZXJlIHBhc3NpbmcgYSBOVUxMIGFjbCBtZWFucyB0bwo+PiA+
ICJzZXQgdGhpcyBhY2wiIGFjdHVhbGx5IG1lYW5zICJyZW1vdmUgdGhlIGV4aXN0aW5nIEFDTCIu
IFdoeSBubwo+PiA+IC0+cmVtb3ZlX2FjbCBtZXRob2QgY2FsbGVkIGZyb20gdGhlIGdlbmVyaWMg
Y29kZT8KPj4KPj4gSXQncyBub3QgdW5jb21tb24sIGl0IHNhdmVzIGlub2RlIG9wZXJhdGlvbnMg
YW5kIHdpcmluZy11cCBjb2RlLgo+Cj4gSSBrbm93IGl0J3MgY29tbW9uLiBBbGwgaXQgZG9lcyBp
cyBwdXQgZXh0cmEgYnJhbmNoZXMgaW4gdGhlCj4gZmlsZXN5c3RlbSBjb2RlIHRvIGRvIHRoaXMs
IGJlY2F1c2UgcmVtb3ZlIGlzIGEgZGlmZmVyZW50IG9wZXJhdGlvbgo+IHRvIHNldC4gVGhlIEFQ
SSBzdWNrcywgYW5kIHdlJ3JlIG5vdCBsaW1pdGVkIG9uIGlub2RlIG9wZXJhdGlvbnMsCj4gYW5k
IHRoZSBvcGVyYXRvciBvdmVybG9hZGluZyBtYWtlcyB0aGUgZmlsZXN5c3RlbSBjb2RlIHVubmVj
ZXNzYXJpbHkKPiBjb21wbGV4IGFzIGl0IGhhcyB0byBkZXRlY3Qgd2hlbiB0byBicmFuY2ggb3V0
IG90IHJlbW92ZSBvciBub3QuLi4KCkkndmUgdHJpZWQgaXQgb3V0LiBUaGUgZmlsZXN5c3RlbSBj
b2RlIGNvdWxkIGJlIHNpbXBsaWZpZWQgKHNlZSB0aGUKcmljaGFjbC13aXAgWypdIGJyYW5jaCB1
bnRpbCB0aGUgbmV4dCBwb3N0aW5nKS4gQWRkaW5nIGEKcmVtb3ZlX3JpY2hhY2wgaW5vZGUgb3Bl
cmF0aW9uIG9uIHRvcCBvZiB0aGF0IHJlYWxseSBkb2Vzbid0IGhlbHAuCgpUaGFua3MsCkFuZHJl
YXMKClsqXSBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYWdy
dWVuL2xpbnV4LXJpY2hhY2wuZ2l0CnJpY2hhY2wtd2lwCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
