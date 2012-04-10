Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AFuw8G178452 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 10:56:58 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	P5uuCyN1ULsnzK1Z (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 08:56:57 -0700 (PDT)
Received: by yenq2 with SMTP id q2so3443586yen.26
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 08:56:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F844474.3010005@gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20120405213740.GA22824@infradead.org>
	<CAAxjCExBcaB6J-u7ivZKWnKiF7oP10JRxzKzQNRuppHkTE2Tzw@mail.gmail.com>
	<201204072057.38286.Martin@lichtvoll.de>
	<CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
	<4F844474.3010005@gmail.com>
Date: Tue, 10 Apr 2012 17:56:57 +0200
Message-ID: <CAAxjCEySjXrpvJBEEA5fwMT6GkXxEogFM_=TXpdjWxL5UR_irQ@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

PiB0cnkgMTI4ayB0byA1MTJrIGZvciBzdHJpcGUgc2l6ZS4gwqBBbmQgdHJ5IHRvIGluY3JlYXNl
IHlvdXIgYWdjb3VudCBieQo+IChuZWFybHkpIGFuIG9yZGVyIG9mIG1hZ25pdHVkZS4KCldvdWxk
IHRoYXQgYmUgb2YgYW55IHJlYWwgdmFsdWUgdG8gYW55b25lIGhlcmUsIGV4Y2VwdCBmb3Igc2F0
aXNmeWluZwpjdXJpb3NpdHkgKHdoaWNoIEkgZmVlbCBhcyB3ZWxsIDspKT8gQmVjYXVzZSBmcmFu
a2x5LCBpdOKAmXMgYSBsb3Qgb2YKd29yaywgYW5kIEnigJltIHF1aXRlIHRocm91Z2ggd2l0aCB0
aGlzIHRlZGlvdXMga2luZCBvZiBhY3Rpdml0eeKApgoKTXkgY29uY2x1c2lvbiBpcyB0aGF0IGV2
ZXJ5dGhpbmcgc2hvdWxkIHdvcmsgd2VsbCBpZiB0aGUgbGV2ZWxzIGJlbG93CnRoZSBmaWxlIHN5
c3RlbSBiZWhhdmVkIHRoZSB3YXkgdGhleSBzaG91bGQgYW5kIGJyb3VnaHQgdGhlIHdyaXRlcwpp
bnRvIGEgc2FuZSBvcmRlci4gQXBwYXJlbnRseSwgYm90aCB0aGUgUkFJRCBjb250cm9sbGVyIGFz
IHdlbGwgYXMgdGhlCkxpbnV4IGJsb2NrIHNjaGVkdWxlciBmYWlsIHRvIGRvIHNvLiBEZXNwaXRl
IHRoZSBhbm5veWluZyBuYXR1cmUgb2YKdGhpcyBzdGF0ZSBvZiBhZmZhaXJzLCBJIGRvIGJlbGll
dmUgdGhhdCBmaWxlIHN5c3RlbXMgc2hvdWxkIGJlIGFibGUKdG8gY291bnQgb24gdGhlIGxvd2Vy
IGxldmVscyBvZiB0aGUgc3RhY2sgZm9yIHN1Y2ggbG93LWxldmVsIHdvcmsgYW5kCm5vdCB3b3Jr
IGFyb3VuZCB0aGVtLCBidXQgYXBwYXJlbnRseSwgdGhleSBhcmUgb2Z0ZW4gZmFpbGVkLiBQcm9i
YWJseQp0aGF04oCZcyBvbmUgb2YgdGhlIHJlYXNvbnMgd2h5IGFsbW9zdCBldmVyeSBmaWxlIHN5
c3RlbSBhY3F1aXJlcyBzb21lCnNvcnQgb2YgYmxvY2sgc2NoZWR1bGluZyBvdmVyIHRpbWUuIE1h
eWJlIHNvbWUgZGF5LCB0aGUgTGludXggSU8Kc2NoZWR1bGVyIHdpbGwgZG8gYSBiZXR0ZXIgam9i
LiBVbmZvcnR1bmF0ZWx5LCBieSB0aGVuLCB0aGlzIGVudGlyZQppc3N1ZSB3aWxsIGJlIGlycmVs
ZXZhbnQgYmVjYXVzZSBub2JvZHkgd2lsbCBiZSB1c2luZyByb3RhdGlvbmFsCnN0b3JhZ2UgYW55
bW9yZSwgYXQgbGVhc3Qgbm90IGZvciBldmVyeWRheSB3b3JrLgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
