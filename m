Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n11LSC7c206546 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 15:28:12 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A2A6D647B
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2009 13:27:31 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id k5lk0DVceeDIAwEs for
	<xfs@oss.sgi.com>; Sun, 01 Feb 2009 13:27:31 -0800 (PST)
From: =?utf-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] build: Explict libtool tag. Preserve CFLAGS/CPPFLAGS.
Date: Sun,  1 Feb 2009 22:27:30 +0100
Message-Id: <1233523650-203120-1-git-send-email-arekm@maven.pl>
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

VXNlIGV4cGxpY3QgbGlidG9vbCBDQyB0YWcgKHNvbWV0aW1lcyBsaWJ0b29sIGNhbid0IGRlY2lk
ZSB3aGF0IHRhZyBpcwpjb3JyZWN0IG9uZSBpZiBvbWl0ZWQpLgoKUHJlc2VydmUgQ0ZMQUdTL0NQ
UEZMQUdTIHRvIGFsbG93OgpDUFBGTEFHUz0iLUkkSE9NRS9oZXJlLWlzLXhmc3Byb2dzLWluc3Rh
bGxlZC9pbmNsdWRlIiBcCkxERkxBR1M9Ii1MJEhPTUUvaGVyZS1pcy14ZnNwcm9ncy1pbnN0YWxs
ZWQvbGliIiBcCi4vY29uZmlndXJlICAuLi4KClNpZ25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWb
a2lld2ljeiA8YXJla21AbWF2ZW4ucGw+Ci0tLQogaW5jbHVkZS9idWlsZGRlZnMuaW4gfCAgICA0
ICsrKy0KIGluY2x1ZGUvYnVpbGRtYWNyb3MgIHwgICAgNCArKy0tCiAyIGZpbGVzIGNoYW5nZWQs
IDUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2J1
aWxkZGVmcy5pbiBiL2luY2x1ZGUvYnVpbGRkZWZzLmluCmluZGV4IGQ4NTVjODkuLjYzNmY2MzIg
MTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYnVpbGRkZWZzLmluCisrKyBiL2luY2x1ZGUvYnVpbGRkZWZz
LmluCkBAIC0xMSw2ICsxMSw4IEBAIERFQlVHID0gQGRlYnVnX2J1aWxkQAogT1BUSU1JWkVSID0g
QG9wdF9idWlsZEAKIE1BTExPQ0xJQiA9IEBtYWxsb2NfbGliQAogTE9BREVSRkxBR1MgPSBATERG
TEFHU0AKK0NGTEFHUyA9IEBDRkxBR1NACitDUFBGTEFHUyA9IEBDUFBGTEFHU0AKIAogTElCWEZT
ID0gQGxpYnhmc0AKIExJQkFDTCA9IEBsaWJhY2xACkBAIC03NSw3ICs3Nyw3IEBAIGlmZXEgKCQo
UEtHX1BMQVRGT1JNKSxmcmVlYnNkKQogREVQRU5ERkxBR1MgPSAtRF9fRnJlZUJTRF9fCiBlbmRp
ZgogCi1HQ0ZMQUdTID0gJChPUFRJTUlaRVIpICQoREVCVUcpIFwKK0dDRkxBR1MgPSAkKE9QVElN
SVpFUikgJChERUJVRykgJChDUFBGTEFHUykgXAogCS1JJChUT1BESVIpL2luY2x1ZGUgLURWRVJT
SU9OPVwiJChQS0dfVkVSU0lPTilcIgogCiAjIEdsb2JhbCwgUGxhdGZvcm0sIExvY2FsIENGTEFH
UwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9idWlsZG1hY3JvcyBiL2luY2x1ZGUvYnVpbGRtYWNyb3MK
aW5kZXggODAxYmNiNi4uMjc2ZDJjOCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9idWlsZG1hY3Jvcwor
KysgYi9pbmNsdWRlL2J1aWxkbWFjcm9zCkBAIC00MSwxMCArNDEsMTAgQEAgTElCTkFNRSA9ICQo
YmFzZW5hbWUgJChMVExJQlJBUlkpKQogTFRPQkpFQ1RTID0gJChPQkpFQ1RTOi5vPS5sbykKIExU
VkVSU0lPTiA9ICQoTFRfQ1VSUkVOVCk6JChMVF9SRVZJU0lPTik6JChMVF9BR0UpCiAKLUxUTElO
SyA9ICQoTElCVE9PTCkgLS1tb2RlPWxpbmsgJChDQykKK0xUTElOSyA9ICQoTElCVE9PTCkgLS10
YWc9Q0MgLS1tb2RlPWxpbmsgJChDQykKIExURVhFQyA9ICQoTElCVE9PTCkgLS1tb2RlPWV4ZWN1
dGUKIExUSU5TVEFMTCA9ICQoTElCVE9PTCkgLS1tb2RlPWluc3RhbGwgJChJTlNUQUxMKQotTFRD
T01QSUxFID0gJChMSUJUT09MKSAtLW1vZGU9Y29tcGlsZSAkKENDRikKK0xUQ09NUElMRSA9ICQo
TElCVE9PTCkgLS10YWc9Q0MgLS1tb2RlPWNvbXBpbGUgJChDQ0YpCiAKIGlmZXEgKCQoRU5BQkxF
X1NIQVJFRCkseWVzKQogTFRMREZMQUdTICs9IC1ycGF0aCAkKFBLR19MSUJfRElSKQotLSAKMS42
LjEuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
