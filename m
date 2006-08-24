Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 03:39:44 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7OAdODW023233
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 03:39:24 -0700
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.7/8.13.4) with ESMTP id k7OAEE7Z000295
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 19:14:14 +0900 (JST)
Subject: Re: [PATCH 2/2] Fix i_state of inode is changed after the inode is freed [try #2]
In-reply-to: <20060824171653.C3003989@wobbly.melbourne.sgi.com>
Message-Id: <20060824191341m-saito@mail.aom.tnes.nec.co.jp>
References: <20060824171653.C3003989@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
From: Masayuki Saito <m-saito@tnes.nec.co.jp>
Date: Thu, 24 Aug 2006 19:13:41 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Hi, Nathan

>Which doesn't look correct due to your need_iput guard, but perhaps
>we should do this instead...

I think that your fix is simpler, so I agree it.


Masayuki
