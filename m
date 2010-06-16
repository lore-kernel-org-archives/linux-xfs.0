Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5GD4YK3130124 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 08:04:34 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DED373D0345
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 06:07:11 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	PCQutOoNy774Za69 for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 06:07:11 -0700 (PDT)
Received: by iwn33 with SMTP id 33so2864633iwn.26
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 06:07:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100616121142.GA22317@infradead.org>
References: <AANLkTilrwmh6n7yYkqyvy_y5-bgS-BEDept0WlLg5GE1@mail.gmail.com>
	<AANLkTikGFq8iv4S3QWp5ZCvXJsjuiP2tKweSl6QwHc6U@mail.gmail.com>
	<20100616121142.GA22317@infradead.org>
Date: Wed, 16 Jun 2010 09:07:10 -0400
Message-ID: <AANLkTimVtpQuRZpOJ4IGlFzRqWG6XaYGzvUnDuF06MyG@mail.gmail.com>
Subject: Re: [Security] XFS swapext ioctl minor security issues
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Content-Type: multipart/mixed; boundary=0016367d6dec5389d104892566fa
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Cc: security@kernel.org, Eugene Teo <eugeneteo@kernel.sg>, aelder@sgi.com

--0016367d6dec5389d104892566fa
Content-Type: text/plain; charset=ISO-8859-1

Sure thing.  This patch is against 2.6.34, but it appears that it can
apply to >= 2.6.25.  Let me know if you need a fix for < 2.6.25.

For those new to the conversation, this patch prevents user "foo" from
using the SWAPEXT ioctl to swap a write-only file owned by user "bar"
into a file owned by "foo" and subsequently reading it.  It does so by
checking that the file descriptors passed to the ioctl are also opened
for reading.  In addition, after swapping any suid/sgid bits should be
cleared.

-Dan

On Wed, Jun 16, 2010 at 8:11 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Dan, can you please send your fixes to the XFS list so that we can
> include them?
>
>

--0016367d6dec5389d104892566fa
Content-Type: text/x-patch; charset=US-ASCII; name="xfs-swapext-ioctl.patch"
Content-Disposition: attachment; filename="xfs-swapext-ioctl.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gai65p1a0

LS0tIGZzL3hmcy94ZnNfZGZyYWcuYy5vcmlnICAgICAyMDEwLTA2LTE1IDA5OjE2OjA1LjAwMDAw
MDAwMCAtMDQwMAorKysgZnMveGZzL3hmc19kZnJhZy5jICAyMDEwLTA2LTE1IDA5OjMwOjE3LjAw
MDAwMDAwMCAtMDQwMApAQCAtNjksNyArNjksOSBAQCB4ZnNfc3dhcGV4dCgKICAgICAgICAgICAg
ICAgIGdvdG8gb3V0OwogICAgICAgIH0KCi0gICAgICAgaWYgKCEoZmlsZS0+Zl9tb2RlICYgRk1P
REVfV1JJVEUpIHx8IChmaWxlLT5mX2ZsYWdzICYgT19BUFBFTkQpKSB7CisgICAgICAgaWYgKCEo
ZmlsZS0+Zl9tb2RlICYgRk1PREVfV1JJVEUpIHx8CisgICAgICAgICAgICEoZmlsZS0+Zl9tb2Rl
ICYgRk1PREVfUkVBRCkgfHwKKyAgICAgICAgICAgIChmaWxlLT5mX2ZsYWdzICYgT19BUFBFTkQp
KSB7CiAgICAgICAgICAgICAgICBlcnJvciA9IFhGU19FUlJPUihFQkFERik7CiAgICAgICAgICAg
ICAgICBnb3RvIG91dF9wdXRfZmlsZTsKICAgICAgICB9CkBAIC04MSw3ICs4Myw4IEBAIHhmc19z
d2FwZXh0KAogICAgICAgIH0KCiAgICAgICAgaWYgKCEodG1wX2ZpbGUtPmZfbW9kZSAmIEZNT0RF
X1dSSVRFKSB8fAotICAgICAgICAgICAodG1wX2ZpbGUtPmZfZmxhZ3MgJiBPX0FQUEVORCkpIHsK
KyAgICAgICAgICAgISh0bXBfZmlsZS0+Zl9tb2RlICYgRk1PREVfUkVBRCkgfHwKKyAgICAgICAg
ICAgICh0bXBfZmlsZS0+Zl9mbGFncyAmIE9fQVBQRU5EKSkgewogICAgICAgICAgICAgICAgZXJy
b3IgPSBYRlNfRVJST1IoRUJBREYpOwogICAgICAgICAgICAgICAgZ290byBvdXRfcHV0X3RtcF9m
aWxlOwogICAgICAgIH0KQEAgLTExMiw2ICsxMTUsMTEgQEAgeGZzX3N3YXBleHQoCgogICAgICAg
IGVycm9yID0geGZzX3N3YXBfZXh0ZW50cyhpcCwgdGlwLCBzeHApOwoKKyAgICAgICBpZighZXJy
b3IpIHsKKyAgICAgICAgICAgICAgIGZpbGVfcmVtb3ZlX3N1aWQodG1wX2ZpbGUpOworICAgICAg
ICAgICAgICAgZmlsZV9yZW1vdmVfc3VpZChmaWxlKTsKKyAgICAgICB9CisgCiAgb3V0X3B1dF90
bXBfZmlsZToKICAgICAgICBmcHV0KHRtcF9maWxlKTsKICBvdXRfcHV0X2ZpbGU6Cgo=
--0016367d6dec5389d104892566fa
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--0016367d6dec5389d104892566fa--
