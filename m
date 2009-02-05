Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n158hGwW204776 for <xfs@oss.sgi.com>; Thu, 5 Feb 2009 02:43:17 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 341F1EC506
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 00:42:37 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	CqDz3eOYBB1Sb7l0 for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2009 00:42:37 -0800 (PST)
Date: Thu, 5 Feb 2009 19:37:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090205083700.GO24173@disturbed>
References: <498376CF.8020806@renderforce.de> <200902040952.45440@zmi.at>
	<20090204122241.GL24173@disturbed> <200902041624.32354@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902041624.32354@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

T24gV2VkLCBGZWIgMDQsIDIwMDkgYXQgMDQ6MjQ6MjdQTSArMDEwMCwgTWljaGFlbCBNb25uZXJp
ZSB3cm90ZToKPiAoY29tcHJlc3NpbmcgMiBhbnN3ZXJzIGhlcmUpCj4gCj4gT24gTWl0dHdvY2gg
MDQgRmVicnVhciAyMDA5IERhdmUgQ2hpbm5lciB3cm90ZToKPiA+ID4gV2l0aCBhIHNpbmdsZSBo
YXJkIGRpc2sgYW5kIGJhcnJpZXJzIHR1cm5lZCBvbiAob249ZGVmYXVsdCksIGEKPiA+ID4gcG93
ZXJmYWlsICJvbmx5IiBsb29zZXMgZGF0YSBpbiB0aGUgY2FjaGUgYnV0IGF0IGxlYXN0IGRvZXMg
bm90Cj4gPiA+IGRlc3Ryb3kgdGhlIGZpbGVzeXN0ZW0uCj4gPgo+ID4gSSdkIGRyb3AgdGhpcyBw
YXJhZ3JhcGggLSBwb3dlcmZhaWwgY2FuIGRlc3Ryb3kgZmlsZXN5c3RlbXMgZXZlbiBvbgo+ID4g
YSBzaW5nbGUgZGlzayAoZS5nLiByb290IGRpcmVjdG9yeSBnZXRzIGNvcnJ1cHRlZCkuCj4gCj4g
SXNuJ3QgdGhhdCB3aGF0IGJhcnJpZXJzIGFyZSBmb3I/IElmIEkgdW5kZXJzdGFuZCBjb3JyZWN0
bHksIGJhcnJpZXJzIAo+IGhlbHAgYWdhaW5zdCBkZXN0cm95aW5nIHRoZSBmaWxlc3lzLCBleGNl
cHQgcm9vdCBkaXI/IEJ1dCB0aGF0IHNob3VsZCAKPiAiZWFzaWx5IiBiZSBmaXhhYmxlIHdpdGgg
eGZzX3JlcGFpciBvciBzbz8KClNlZSwgSSBkaWRuJ3QgdW5kZXJzdGFuZCB3aGF0IHlvdSB3ZXJl
IHRyeWluZyB0byBzYXkuIDspCgpXaGF0IEkgbWlzc2VkIHdhcyB0aGUgImJhcnJpZXJzIHR1cm5l
ZCBvbiIgLSBJIHdhcyByZWZlcnJpbmcKKGNvbnRleHQgbm90IHF1b3RlZCkgdG8gdGhlIGZhY3Qg
dGhhdCBSQUlENSBpcyBub3QgdW7RlnF1ZSBpbiBpdCdzCmFiaWxpdHkgdG8gdHJhc2ggdGhlIGZp
bGVzeXN0ZW0gb24gcG93ZXJmYWlsLiBZb3UgYXJlIHJpZ2h0LApiYXJyaWVycyBvbiBhIHNpbmds
ZSBkaXNrIHNob3VsZCBwcmV2ZW50IGZpbGVzeXN0ZW0gY29ycnVwdGlvbgphbmQgd2lsbCBwcmV2
ZW50IGxvc3Mgb2Ygc3luY2hyb25vdXNseSB3cml0dGVuIGRhdGEuIG9ubHkKYXN5bmNocm9ub3Vz
bHkgd3JpdHRlbiBkYXRhIHdpbGwgZ2V0IGxvc3QgKGp1c3QgbGlrZSBhbGwgdGhlCnN0dWZmIHNp
dHRpbmcgaW4gUkFNKS4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJv
bW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
