Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o927iOvb165054 for <xfs@oss.sgi.com>; Sat, 2 Oct 2010 02:44:24 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C4F5BD454
	for <xfs@oss.sgi.com>; Sat,  2 Oct 2010 00:45:24 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id H1rNlp5gXOjCm9YM for
	<xfs@oss.sgi.com>; Sat, 02 Oct 2010 00:45:24 -0700 (PDT)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] [xfstests]: Don't depend on mkfs.xfs output in some tests
Date: Sat,  2 Oct 2010 09:45:19 +0200
Message-Id: <1286005519-16851-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1286005222-16423-1-git-send-email-arekm@maven.pl>
References: <1286005222-16423-1-git-send-email-arekm@maven.pl>
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

VGVzdHMgMTM2IGFuZCAyMDYgcmVseSBvbiBta2ZzLnhmcyBvdXRwdXQuCgoxMzYgdGVzdCB3YXMg
Y3VycmVudGx5IGJyb2tlbiB3aXRoIGhhcmRjb2RlZCBta2ZzLnhmcyBvdXRwdXQgKHRoYXQKY29u
dGFpbmVkIGZvciBleGFtcGxlIG1ldGEtZGF0YT0vZGV2L3NkYTgpLiBEcm9wIHRoYXQgcGFydCBm
cm9tIG91dHB1dC4KCklnbm9yZSBwcm9qaWQzMmJpdCBvdXRwdXQgZXhpc3RlbmNlIGZvciB0ZXN0
IDIwNi4KClNpZ25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJla21AbWF2ZW4u
cGw+Ci0tLQogMTM2ICAgICB8ICAgIDIgKy0KIDEzNi5vdXQgfCAgICA4IC0tLS0tLS0tCiAyMDYg
ICAgIHwgICAgMyArKy0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxMCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS8xMzYgYi8xMzYKaW5kZXggZDM5NDU5NC4uYWJjMjNlOSAx
MDA3NTUKLS0tIGEvMTM2CisrKyBiLzEzNgpAQCAtNTQsNyArNTQsNyBAQCBfc3VwcG9ydGVkX29z
IElSSVggTGludXgKIF9yZXF1aXJlX3NjcmF0Y2gKIAogZXhwb3J0IE1LRlNfT1BUSU9OUz0iLWkg
c2l6ZT01MTIsYXR0cj0yIgotX3NjcmF0Y2hfbWtmc194ZnMKK19zY3JhdGNoX21rZnNfeGZzID4g
L2Rldi9udWxsIDI+JjEKIF9zY3JhdGNoX21vdW50CiAKIGZpbGU9JFNDUkFUQ0hfTU5UL2ZpbGUK
ZGlmZiAtLWdpdCBhLzEzNi5vdXQgYi8xMzYub3V0CmluZGV4IDdhYTc2YWMuLjVjOTE1ZmEgMTAw
NjQ0Ci0tLSBhLzEzNi5vdXQKKysrIGIvMTM2Lm91dApAQCAtMSwxMiArMSw0IEBACiBRQSBvdXRw
dXQgY3JlYXRlZCBieSAxMzYKLW1ldGEtZGF0YT0vZGV2L3NkYTggICAgICAgICAgICAgIGlzaXpl
PTUxMiAgICBhZ2NvdW50PTgsIGFnc2l6ZT0zMTM3NiBibGtzCi0gICAgICAgICA9ICAgICAgICAg
ICAgICAgICAgICAgICBzZWN0c3o9NTEyICAgYXR0cj0yLCBwYXJlbnQ9MAotZGF0YSAgICAgPSAg
ICAgICAgICAgICAgICAgICAgICAgYnNpemU9NDA5NiAgIGJsb2Nrcz0yNTEwMDgsIGltYXhwY3Q9
MjUKLSAgICAgICAgID0gICAgICAgICAgICAgICAgICAgICAgIHN1bml0PTAgICAgICBzd2lkdGg9
MCBibGtzLCB1bndyaXR0ZW49MQotbmFtaW5nICAgPXZlcnNpb24gMiAgICAgICAgICAgICAgYnNp
emU9NDA5NiAgCi1sb2cgICAgICA9aW50ZXJuYWwgbG9nICAgICAgICAgICBic2l6ZT00MDk2ICAg
YmxvY2tzPTEyMDAsIHZlcnNpb249MQotICAgICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAg
c2VjdHN6PTUxMiAgIHN1bml0PTAgYmxrcwotcmVhbHRpbWUgPW5vbmUgICAgICAgICAgICAgICAg
ICAgZXh0c3o9NjU1MzYgIGJsb2Nrcz0wLCBydGV4dGVudHM9MAogaW51bT02NwogY29yZS5mb3Jt
YXQgPSAyIChleHRlbnRzKQogY29yZS5zaXplID0gMApkaWZmIC0tZ2l0IGEvMjA2IGIvMjA2Cmlu
ZGV4IDAzNGJiZjEuLmU4YmM5MjIgMTAwNzU1Ci0tLSBhLzIwNgorKysgYi8yMDYKQEAgLTc2LDcg
Kzc2LDggQEAgZGQgaWY9L2Rldi96ZXJvIG9mPSR0bXBmaWxlIGJzPTEgc2Vlaz0xOTk5ODYzMDE4
MDg2NCBjb3VudD0xID4vZGV2L251bGwgMj4mMSBcCiBlY2hvICI9PT0gbWtmcy54ZnMgPT09Igog
bWtmcy54ZnMgLWYgLWJzaXplPTQwOTYgLWRhZ3NpemU9NzYyODg3MTliLHNpemU9MzkwNTk4MjQ1
NWIgLWxsYXp5LWNvdW50PTAgJHRtcGZpbGUgXAogCXwgc2VkIC1lICJzLF5tZXRhLWRhdGE9Lipp
c2l6ZSxtZXRhLWRhdGE9RklMRSAgICAgICAgICAgICAgICAgICBpc2l6ZSxnIiBcCi0JCS1lICJz
L1woXmxvZy4qYmxvY2tzPVwpXChbMC05XSosXCkvXDFYWFhYWCwvIgorCQktZSAicy9cKF5sb2cu
KmJsb2Nrcz1cKVwoWzAtOV0qLFwpL1wxWFhYWFgsLyIgXAorCQktZSAicy8sIHByb2ppZDMyYml0
PVswLTldLy8iCiAKIG1vdW50IC1vIGxvb3AgJHRtcGZpbGUgJHRtcGRpciB8fCBfZmFpbCAiISEh
IGZhaWxlZCB0byBsb29wYmFjayBtb3VudCIKIAotLSAKMS43LjMuMQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3Nz
LnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
