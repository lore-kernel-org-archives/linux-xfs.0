Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JEJcpn102707 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:19:39 -0500
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id h6C1E5pDscRJRllW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 07:19:37 -0700 (PDT)
Date: Tue, 19 Jun 2012 10:19:33 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120619141933.GC10637@thunk.org>
References: <4FDF9EBE.2030809@shiftmail.org>
	<alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, xfs@oss.sgi.com, Spelic <spelic@shiftmail.org>

T24gVHVlLCBKdW4gMTksIDIwMTIgYXQgMDQ6MDk6NDhQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IAo+IFdpdGggdGhpbiBwcm92aXNpb25pbmcgeW91J2xsIGdldCB0b3RhbGx5IGRp
ZmZlcmVudCBmaWxlIHN5c3RlbQo+IGxheW91dCB0aGFuIG9uIGZ1bGx5IHByb3Zpc2lvbmVkIGRp
c2sgYXMgeW91IHB1c2ggbW9yZSBhbmQgbW9yZQo+IHdyaXRlcyB0byB5b3VyIGRyaXZlLiBUaGlz
IHVuZm9ydHVuYXRlbHkgaGFzIGdyZWF0IGltcGFjdCBvbgo+IHBlcmZvcm1hbmNlIHNpbmNlIGZp
bGUgc3lzdGVtcyB1c3VhbGx5IGhhdmUgYSBsb3Qgb2Ygb3B0aW1pemF0aW9uIG9uCj4gd2hlcmUg
dG8gcHV0IGRhdGEvbWV0YWRhdGEgb24gdGhlIGRyaXZlIGFuZCBob3cgdG8gcmVhZCB0aGVtLgo+
IEhvd2V2ZXIgaW4gY2FzZSBvZiB0aGlubHkgcHJvdmlzaW9uZWQgc3RvcmFnZSB0aG9zZSBvcHRp
bWl6YXRpb24KPiB3b3VsZCBub3QgaGVscC4gQW5kIHllcywgeW91IGp1c3QgaGF2ZSB0byBleHBl
Y3QgbG93ZXIgcGVyZm9ybWFuY2UKPiB3aXRoIGRtLXRoaW4gZnJvbSB0aGUgZmlsZSBzeXN0ZW0g
b24gdG9wIG9mIGl0LiBJdCBpcyBub3QgYW5kIGl0Cj4gd2lsbCBuZXZlciBiZSBpZGVhbCBzb2x1
dGlvbiBmb3Igd29ya2xvYWRzIHdoZXJlIHlvdSBleHBlY3QgdGhlIGJlc3QKPiBwZXJmb3JtYW5j
ZS4KCk9uZSBvZiB0aGUgdGhpbmdzIHdoaWNoIHdvdWxkIGJlIG5pY2UgdG8gYmUgYWJsZSB0byBl
YXNpbHkgc2V0IHVwIGlzIGEKY29uZmlndXJhdGlvbiB3aGVyZSB3ZSBnZXQgdGhlIGJlbmVmaXRz
IG9mIHRoaW4gcHJvdmlzaW9uaW5nIHdpdGgKcmVzcGVjdCB0byBzbmFwc2hvc3QsIGJ1dCB3aGVy
ZSB0aGUgdW5kZXJseWluZyBibG9jayBkZXZpY2UgdXNlZCBieQp0aGUgZmlsZSBzeXN0ZW0gaXMg
Y29udGlndW91cy4gIFRoYXQgaXMsIGl0IHdvdWxkIGJlIHJlYWxseSB1c2VmdWwgdG8KKm5vdCog
dXNlIHRoaW4gcHJvdmlzaW9uaW5nIGZvciB0aGUgdW5kZXJseWluZyBmaWxlIHN5c3RlbSwgYnV0
IHRvIHVzZQp0aGluIHByb3Zpc2lvbmVkIHNuYXBzaG90cy4gIFRoYXQgd2F5IHdlIG9ubHkgcGF5
IHRoZSB0aGlucApwZXJmb3JtYW5jZSBwZW5hbHR5IGZvciB0aGUgc25hcHNob3RzLCBhbmQgbm90
IGZvciBub3JtYWwgZmlsZSBzeXN0ZW0Kb3BlcmF0aW9ucy4gIFRoaXMgaXMgc29tZXRoaW5nIHRo
YXQgd291bGQgYmUgdmVyeSB1c2VmdWwgYm90aCBmb3IgZXh0NAphbmQgeGZzLgoKSSB0YWxrZWQg
dG8gQWxhc2RhaXIgYWJvdXQgdGhpcyBhIGZldyBtb250aHMgYWdvIGF0IHRoZSBDb2xsYWIgU3Vt
bWl0LAphbmQgSSB0aGluayBpdCdzIGRvYWJsZSB0b2RheSwgYnV0IGl0IHdhcyBzb21ld2hhdCBj
b21wbGljYWVkIHRvIHNldAp1cC4gIEkgZG9uJ3QgcmVjYWxsIHRoZSBkZXRhaWxzIG5vdywgYnV0
IHBlcmhhcHMgc29tZW9uZSB3aG8ncyBtb3JlCmZhbWlsaWFyIGRldmljZSBtYXBwZXIgY291bGQg
b3V0bGluZSB0aGUgZGV0YWlscywgYW5kIHBlcmhhcHMgd2UgY2FuCmVpdGhlciBzaW1wbGlmeSBp
dCBvciBhYnN0cmFjdCBpdCBhd2F5IGluIGEgY29udmVuaWVudCBmcm9udC1lbmQKc2NyaXB0PwoK
CQkJCQkJLSBUZWQKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
