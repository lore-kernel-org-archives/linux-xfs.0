Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 07:12:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69ECO8C018009
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 07:12:25 -0700
Received: from g1t0026.austin.hp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74C28189F0D4
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 07:13:30 -0700 (PDT)
Received: from g1t0026.austin.hp.com (g1t0026.austin.hp.com [15.216.28.33]) by cuda.sgi.com with ESMTP id 6Rx0OgoKQBhIWye2 for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 07:13:30 -0700 (PDT)
Message-ID: <4874C77F.7070602@hp.com>
Date: Wed, 09 Jul 2008 10:13:19 -0400
From: jim owens <jowens@hp.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com>
In-Reply-To: <4874C3E8.20804@hp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

Oops..

 > WHY A TIMEOUT - need a way for operator to abort the
 > freeze

instead of "abort" I should have said "limit" because
it is really proactive control (so they will not get
called in the middle of the night by pissed users).

I forgot to make it clear that TIMEOUT is the same as AUTO-THAW
in logging errors so the adnin knows they have a bad snapshot and
can do it again.

I also forgot to say that our customers all say they can deal
with retrying a snapshot, but not with unknown bad snapshots
and most definitely not with killing their 24/7 operations!

jim
