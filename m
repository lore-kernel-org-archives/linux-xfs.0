Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 18:10:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3U19cFv017688
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 18:09:45 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85B5010A40A
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 18:10:21 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id fn1FGblkTlmXmSEE for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 18:10:21 -0700 (PDT)
Message-Id: <D8E7FEBEEB9649CF9E2FC389BC5F8C6B@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080428193123t-sato@mail.jp.nec.com> <20080428103719.GA16030@infradead.org> <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp> <20080428130358.GB2798@infradead.org>
In-Reply-To: <20080428130358.GB2798@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Wed, 30 Apr 2008 10:10:13 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

Hi,

>> bd_mount_sem can protect against only freezes and cannot protect against
>> unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
>> bd_mount_sem might occur incorrectly.
>
> Indeed.  The bit flag would fix that because unfreeze could then check
> for the bit beeing set first.  So that's probably the easiest way to go.

I think the bit flag is more efficient than the semaphore.
So I will consider whether it can be used for the freeze feature.

Cheers, Takashi
