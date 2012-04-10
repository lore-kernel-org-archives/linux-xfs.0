Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AE2fdl154360 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 09:02:42 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	jR3U4xWt9EnsjgBA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 07:02:40 -0700 (PDT)
Received: by yenq2 with SMTP id q2so3326733yen.26
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 07:02:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201204072057.38286.Martin@lichtvoll.de>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20120405213740.GA22824@infradead.org>
	<CAAxjCExBcaB6J-u7ivZKWnKiF7oP10JRxzKzQNRuppHkTE2Tzw@mail.gmail.com>
	<201204072057.38286.Martin@lichtvoll.de>
Date: Tue, 10 Apr 2012 16:02:39 +0200
Message-ID: <CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

PiBBbmQgaXMgWEZTIGFsaWduZWQgdG8gdGhlIFJBSUQgNj8KPgo+IFdoYXQgZG9lcyB4ZnNfaW5m
byBkaXNwbGF5IG9uIGl0PwoKWWVzLCBpdOKAmXMgYWxpZ25lZC4KCm1ldGEtZGF0YT0vZGV2L21h
cHBlci92Z19kYXRhLWx2aG9tZSBpc2l6ZT0yNTYgICAgYWdjb3VudD00LAphZ3NpemU9NzMyMzM2
NTYgYmxrcwogICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBzZWN0c3o9NTEyICAgYXR0
cj0yCmRhdGEgICAgID0gICAgICAgICAgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9
MjkyOTM0NjI0LCBpbWF4cGN0PTUKICAgICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgc3Vu
aXQ9OCAgICAgIHN3aWR0aD0zMiBibGtzCm5hbWluZyAgID12ZXJzaW9uIDIgICAgICAgICAgICAg
IGJzaXplPTQwOTYgICBhc2NpaS1jaT0wCmxvZyAgICAgID1pbnRlcm5hbCAgICAgICAgICAgICAg
IGJzaXplPTQwOTYgICBibG9ja3M9MTQzMDQwLCB2ZXJzaW9uPTIKICAgICAgICAgPSAgICAgICAg
ICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIHN1bml0PTggYmxrcywgbGF6eS1jb3VudD0xCnJl
YWx0aW1lID1ub25lICAgICAgICAgICAgICAgICAgIGV4dHN6PTQwOTYgICBibG9ja3M9MCwgcnRl
eHRlbnRzPTAKCkkgY2hhbmdlZCB0aGUgc3RyaXBlIHNpemUgdG8gMzJrYiBpbiB0aGUgbWVhbnRp
bWUuIFRoaXMgd2F5LCBpdApwZXJmb3JtcyBzbGlnaHRseSBiZXR0ZXIuCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
