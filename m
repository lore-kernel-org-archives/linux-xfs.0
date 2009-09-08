Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n88BfJxV065934 for <xfs@oss.sgi.com>; Tue, 8 Sep 2009 06:41:34 -0500
Received: from IX-MTA-02.mxsweep.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1707E16046FA
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2009 04:41:49 -0700 (PDT)
Received: from IX-MTA-02.mxsweep.com (mail161.emailantidote.com
	[89.167.219.161]) by cuda.sgi.com with ESMTP id
	8YQ610rTLFLyHETf for <xfs@oss.sgi.com>;
	Tue, 08 Sep 2009 04:41:49 -0700 (PDT)
Message-ID: <4AA6402D.8040209@draigBrady.com>
Date: Tue, 8 Sep 2009 12:29:49 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: fsetxattr() fails on a writable descriptor?
References: <1251987642.3855.36.camel@dhcp-lab-219.englab.brq.redhat.com>	
	<4AA1A3E6.2020606@draigBrady.com> <87k50den1e.fsf@meyering.net>	
	<1252309787.3852.8.camel@dhcp-lab-219.englab.brq.redhat.com>	
	<4AA4C950.3080303@draigBrady.com>
	<1252318482.3852.18.camel@dhcp-lab-219.englab.brq.redhat.com>
In-Reply-To: <1252318482.3852.18.camel@dhcp-lab-219.englab.brq.redhat.com>
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
Cc: CoreutilsBugs <bug-coreutils@gnu.org>

ZnNldHhhdHRyKCkgaXMgZmFpbGluZyBmb3IgbWUgd2hlbiB0aGUgcGVybWlzc2lvbnMgYXJlIHJl
YWRvbmx5CmJ1dCB0aGUgZGVzY3JpcHRvciBpcyB3cml0YWJsZSBhcyBkZW1vbnN0cmF0ZWQgYnkg
dGhlIHByb2dyYW0gYmVsb3cuCkkndmUgdHJpZWQgdGhpcyBvbiBleHQzIGFuZCBleHQ0IHdpdGgg
bGliYXR0ci0yLjQuNDMtMy5mYzExLmk1ODYKYW5kIGxpbnV4LTIuNi4zMC41LTQzLmZjMTEuaTU4
NgoKSXMgdGhpcyBleHBlY3RlZD8KCmNoZWVycywKUMOhZHJhaWcuCgojaW5jbHVkZSA8c3lzL3R5
cGVzLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUg
PGF0dHIvbGliYXR0ci5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoK
aW50IG1haW4odm9pZCkKewogICAgaW50IHdmZDsKICAgIGlmICgod2ZkPW9wZW4oIndyaXRhYmxl
IiwgT19DUkVBVHxPX1dST05MWXxPX0VYQ0wsIFNfSVJVU1IpKSA9PSAtMSkKICAgICAgICBmcHJp
bnRmKHN0ZGVyciwgIm9wZW4oJ3dyaXRhYmxlJykgZXJyb3IgWyVtXVxuIik7CiAgICBpZiAod3Jp
dGUod2ZkLCAiZGF0YSIsIDEpID09IC0xKQogICAgICAgIGZwcmludGYoc3RkZXJyLCAid3JpdGUo
KSBlcnJvciBbJW1dXG4iKTsKICAgIGlmIChmc2V0eGF0dHIod2ZkLCAidXNlci50ZXN0IiwgInRl
c3QiLCA0LCAwKSA9PSAtMSkKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgImZzZXR4YXR0cigpIGVy
cm9yIFslbV1cbiIpOwp9CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
