Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32E277F4E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 09:40:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F13F8F8049
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 07:40:49 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Zw2CXXP9yBkU8AC4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 07:40:48 -0700 (PDT)
Date: Tue, 20 May 2014 16:40:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] [Bug 48651] [TRIVIAl]'xfs_uuid_table' allocated
	in xfs_uuid_mount() is never freed
Message-ID: <20140520144046.GA17616@lst.de>
References: <bug-48651-470@https.bugzilla.kernel.org/>
	<bug-48651-470-8kNPGrGVTO@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bug-48651-470-8kNPGrGVTO@https.bugzilla.kernel.org/>
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
To: nickkrause@sympatico.ca, sandeen@redhat.com
Cc: xfs@oss.sgi.com

T24gVHVlLCBNYXkgMjAsIDIwMTQgYXQgMDQ6MDE6MjBBTSArMDAwMCwgYnVnemlsbGEtZGFlbW9u
QGJ1Z3ppbGxhLmtlcm5lbC5vcmcgd3JvdGU6Cj4gaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3Jn
L3Nob3dfYnVnLmNnaT9pZD00ODY1MQo+IC0tLSBDb21tZW50ICMyIGZyb20gRXJpYyBTYW5kZWVu
IDxzYW5kZWVuQHJlZGhhdC5jb20+IC0tLQo+IEZyZWVpbmcgaXQgd2hlbiB0aGUgbW9kdWxlIGlz
IHVubG9hZGVkIHNob3VsZCBiZSBzdWZmaWNpZW50Lgo+IAo+IEluIG5vcm1hbCB1c2UsIHVubW91
bnRpbmcgYSBmaWxlc3lzdGVtIGNyZWF0ZXMgYSBob2xlIGluIHRoZSB0YWJsZSwgd2hpY2ggdGhl
Cj4gbmV4dCBtb3VudCBjYW4gZmlsbC4KPiAKPiBJZiB5b3UgbW91bnQgYSBsb3Qgb2YgdW5pcXVl
IFVVSUQgZmlsZXN5c3RlbXMgd2l0aG91dCB1bm1vdW50aW5nIGFueSBpbgo+IGJldHdlZW4sIHRo
ZSB0YWJsZSB3aWxsIGdyb3cgYWNjb3JkaW5nbHksIGFuZCB1bm1vdW50aW5nIHdvbid0IHNocmlu
ayBpdCAtIGkuZS4KPiB0aGUgdGFibGUgb25seSBncm93cyBhcyB0aGUgbnVtYmVyIG9mIGNvbmN1
cnJlbnRseSBtb3VudGVkIGZpbGVzeXN0ZW0gZ3Jvd3MsCj4gYnV0IHRoYXQgZG9lc24ndCBzZWVt
IGxpa2UgYSBwYXJ0aWN1bGFybHkgY3JpdGljYWwgcHJvYmxlbSB0byBmaXguCgpJZiBhbnlvbmXu
gIByZWFsbHkgY2FyZXMgYWJvdXQgdGhpcyBoZSBvciBzaGUgc2hvdWxkIGp1c3Qga2lsbCB0aGUg
dXVpZAp0YWJsZSBlbnRpcmVseS4gIFdlIGNhbiBzaW1wbGUgd2FsayBhIGxpc3Qgb2YgbW91bnRl
ZCB4ZnMgZmlsZXN5c3RlbXMKYW5kIGNoZWNrIHRoZWlyIHV1aWRzLiAgVGhlIFZGUyBldmVuIGtl
ZXBzIGEgbGlzdCBhbHJlYWR5LCB3aGljaCB3ZQpwcm9iYWJseSBjb3VsZCB1c2UgaWYgd2UgYXJl
IGNhcmVmdWwuCgpCb251cyBwb2ludHMgZm9yIGltcGxlbWVudGluZyB0aGlzIGluIGEgd2F5IHNv
IHRoYXQgb3RoZXIgZmlsZXN5c3RlbXMKY291bGQgc2hhcmUgdGhlIGNvZGUuCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
