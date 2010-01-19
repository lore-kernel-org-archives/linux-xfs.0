Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0WQon141642 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:32:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 991151C5C7B5
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:33:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	XfNfcz1ZGShhxcPm for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:33:24 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11448792-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:03:22 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX225-0003EJ-Ni
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:33:21 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX21v-0003Xo-1t
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:33:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfsprogs: Do not remove configure information on clean
Date: Tue, 19 Jan 2010 11:33:05 +1100
Message-Id: <1263861186-13589-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861186-13589-1-git-send-email-david@fromorbit.com>
References: <1263861186-13589-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

xYpvcm1hbCBwYWNrYWdpbmcgcHJhY3RpY2UgaXMgdG8gcmVtb3ZlIHRoZSBjb25maWd1cmUgc2Ny
aXB0cwpvbiBhICdtYWtlIGRpc3RjbGVhbicgc28gdGhhdCBhICdtYWtlIGNsZWFuJyBkb2Vzbid0
IHJlc3VsdCBpbgpoYXZpbmcgdG8gcmVydW4gdGhlIGNvbmZpZ3VyZSBzY3JpcHRzLiBDaGFuZ2Ug
dGhlIGNsZWFuIHRhcmdldHMKaW4gdGhlIHRvcCBsZXZlbCBtYWtlZmlsZSB0byBvbmx5IGNsZWFy
IGNvbmZpZ3VyZSBmaWxlcyBvbgphIGRpc3RjbGVhbi4KClNpZ25lZC1vZmYtYnk6IERhdmUgQ2hp
bm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4KLS0tCiBNYWtlZmlsZSB8ICAgIDQgKystLQogMSBm
aWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRleCAyZDM5NGU0Li5hNzYxNWNhIDEwMDY0NAotLS0g
YS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtMTUsNyArMTUsNyBAQCBTUkNUQVIgPSAkKFBL
R19OQU1FKS0kKFBLR19WRVJTSU9OKS50YXIuZ3oKIENPTkZJR1VSRSA9IGFjbG9jYWwubTQgY29u
ZmlndXJlIGNvbmZpZy5ndWVzcyBjb25maWcuc3ViIGluc3RhbGwtc2ggbHRtYWluLnNoCiBMU1JD
RklMRVMgPSBjb25maWd1cmUuaW4gcmVsZWFzZS5zaCBSRUFETUUgVkVSU0lPTiAkKENPTkZJR1VS
RSkKIAotTERJUlQgPSBjb25maWcubG9nIC5kZXAgY29uZmlnLnN0YXR1cyBjb25maWcuY2FjaGUg
Y29uZmRlZnMuaCBjb25mdGVzdCogXAorRElTVERJUlQgPSBjb25maWcubG9nIC5kZXAgY29uZmln
LnN0YXR1cyBjb25maWcuY2FjaGUgY29uZmRlZnMuaCBjb25mdGVzdCogXAogCWJ1aWx0IC5jZW5z
dXMgaW5zdGFsbC4qIGluc3RhbGwtZGV2LiogKi5neiBhdXRvbTR0ZS5jYWNoZS8qIGxpYnRvb2wg
XAogCWluY2x1ZGUvYnVpbGRkZWZzIGluY2x1ZGUvcGxhdGZvcm1fZGVmcy5oCiAKQEAgLTEwMSw3
ICsxMDEsNyBAQCBpbnN0YWxsLXFhOiBpbnN0YWxsICQoYWRkc3VmZml4IC1pbnN0YWxsLXFhLCQo
U1VCRElSUykpCiAJJChNQUtFKSAtQyAkKiBpbnN0YWxsLXFhCiAKIGRpc3RjbGVhbjogY2xlYW4K
LQlybSAtZiAkKExESVJUKQorCXJtIC1mICQoRElTVERJUlQpCiAKIHJlYWxjbGVhbjogZGlzdGNs
ZWFuCiAJcm0gLWYgJChDT05GSUdVUkUpCi0tIAoxLjYuNQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
