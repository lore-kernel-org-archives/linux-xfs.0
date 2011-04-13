Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3DKW5hu211749 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 15:32:05 -0500
Subject: Re: [PATCH] xfs: don't look forever in xfs_inode_ag_walk during
	async inode flushes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302157685-3966-1-git-send-email-david@fromorbit.com>
References: <1302157685-3966-1-git-send-email-david@fromorbit.com>
Date: Wed, 13 Apr 2011 15:33:33 -0500
Message-ID: <1302726813.2023.126.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

T24gVGh1LCAyMDExLTA0LTA3IGF0IDE2OjI4ICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IFdoZW4gdGhlIHVu
ZGVybHlpbmcgaW5vZGUgYnVmZmVyIGlzIGxvY2tlZCBhbmQgeGZzX3N5bmNfaW5vZGVfYXR0cigp
Cj4gaXMgZG9pbmcgYSBub24tYmxvY2tpbmcgZmx1c2gsIHhmc19pZmx1c2goKSBjYW4gcmV0dXJu
IEVBR0FJTi4gV2hlbgo+IHRoaXMgaGFwcGVu0ZUsIGNsZWFyIHRoZSBlcnJvciByYXRoZXIgdGhh
biByZXR1cm5pbmcgaXQgdG8KPiB4ZnNfaW5vZGVfYWdfd2FsaygpLCBhcyByZXR1cm5pbmcgRUFH
QUlOIHdpbGwgcmVzdWx0IGluIHRoZSBBRyB3YWxrCj4gZGVsYXlpbmcgZm9yIGEgc2hvcnQgd2hp
bGUgYW5kIHRyeWluZyBhZ2Fpbi4gVGhpcyBjYW4gcmVzdWx0IGluCj4gYmFja2dyb3VuZCB3YWxr
cyBnZXR0aW5nIHN0dWNrIG9uIHRoZSBvbmUgQUcgdW50aWwgaW5vZGUgYnVmZmVyIGlzCj4gdW5s
b2NrZWQgYnkgc29tZSBvdGhlciBtZWFucy4KPiAKPiBUaGlzIGJlaGF2aW91ciB3YXMgbm90aWNl
ZCB3aGVuIGFuYWx5c2luZyBldmVudCB0cmFjZXMgZm9sbG93ZWQgYnkKPiBjb2RlIGluc3BlY3Rp
b24gYW5kIHZlcmlmaWNhdGlvbiBvZiB0aGUgZml4IHZpYSBmdXJ0aGVyIHRyYWNlcy4KPiAKPiBT
aWduZWQtb2ZmLWJ5OiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+CgpMb29rcyBn
b29kLgoKUmV2aWV3ZWQtYnk6IEFsZXggRWxkZXIgPGFlbGRlckBzZ2kuY29tPgoKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
