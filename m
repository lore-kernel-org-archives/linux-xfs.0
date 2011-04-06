Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36KCZjr052885 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 15:12:36 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 86AC4147CF3A
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 13:15:51 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with SMTP id TWShhjiKsCuE7qPi for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 13:15:51 -0700 (PDT)
Date: Wed, 6 Apr 2011 13:15:50 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] xfs: remove unused 'bdi' variable in xfs_buf_readahead()
Message-ID: <alpine.LNX.2.00.1104061311450.5855@pobox.suse.cz>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: base64
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>
Cc: linux-kernel@vger.kernel.org

R2V0cyByaWQgb2YgCgoJZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmM6IEluIGZ1bmN0aW9uIKF4
ZnNfYnVmX3JlYWRhaGVhZKI6Cglmcy94ZnMvbGludXgtMi42L3hmc19idWYuYzo2NjA6IHdhcm5p
bmc6IHVudXNlZCB2YXJpYWJsZSChYmRpogoKVGhlIHZhcmlhYmxlIGhhcyBiZWVuIHVudXNlZCBz
aW5jZSAwZTZlODQ3ZmZlICgieGZzOiBzdG9wIHVzaW5nIHRoZSBwYWdlIApjYWNoZSB0byBiYWNr
IHRoZSBidWZmZXIgY2FjaGUiKQoKU2lnbmVkLW9mZi1ieTogSmlyaSBLb3NpbmEgPGprb3NpbmFA
c3VzZS5jej4KLS0tCiBmcy94ZnMvbGludXgtMi42L3hmc19idWYuYyB8ICAgIDIgLS0KIDEgZmls
ZXMgY2hhbmdlZCwgMCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL3hmcy9saW51eC0yLjYveGZzX2J1Zi5jIGIvZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmMK
aW5kZXggNTk2YmIyYy4uZDkxNzE0NiAxMDA2NDQKLS0tIGEvZnMveGZzL2xpbnV4LTIuNi94ZnNf
YnVmLmMKKysrIGIvZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmMKQEAgLTY1Nyw4ICs2NTcsNiBA
QCB4ZnNfYnVmX3JlYWRhaGVhZCgKIAl4ZnNfb2ZmX3QJCWlvZmYsCiAJc2l6ZV90CQkJaXNpemUp
CiB7Ci0Jc3RydWN0IGJhY2tpbmdfZGV2X2luZm8gKmJkaTsKLQogCWlmIChiZGlfcmVhZF9jb25n
ZXN0ZWQodGFyZ2V0LT5idF9iZGkpKQogCQlyZXR1cm47CiAKLS0gCjEuNy4zLjEKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
