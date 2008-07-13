Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jul 2008 10:15:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6DHEnmW024112
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 10:14:51 -0700
Received: from g5t0006.atlanta.hp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AEA5E07265
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 10:15:56 -0700 (PDT)
Received: from g5t0006.atlanta.hp.com (g5t0006.atlanta.hp.com [15.192.0.43]) by cuda.sgi.com with ESMTP id MQwly8eCaNX1AwIa for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 10:15:56 -0700 (PDT)
Message-ID: <487A383F.50600@hp.com>
Date: Sun, 13 Jul 2008 13:15:43 -0400
From: jim owens <jowens@hp.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com> <20080713120602.GC7517@elf.ucw.cz>
In-Reply-To: <20080713120602.GC7517@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

Pavel Machek wrote:

>>This means ONLY SOME metadata (or no metadata) is flushed and
>>then all metadata updates are stopped.  User/kernel writes
>>to already allocated file pages WILL go to a frozen disk.
> 
> That's the difference here. They do write file data, and thus avoid
> mmap()-writes problem.
> 
> ...and they _still_ provide auto-thaw.
> 								Pavel

One of the hardest things to make people understand is that
stopping file data writes in the filesystem during a freeze
is not just dangerous, it is also __worthless__ unless you
have a complete "user environment freeze" mechanism.

In a real 24/7 environment, the DB and application stack
may be poorly glued together stuff from multiple vendors.

And unless each independent component has a freeze and they
can all be coordinated, the data in the pipeline is never
stable enough to say "if you stop all writes to disk and
take a snapshot, this is the same as an orderly shutdown,
backup, restore, and startup".

If you need to stop applications before a freeze, there
is no reason to implement "stop writing file data to disk".

The only real way to make it work (and what the smart apps
do) is to have application "checkpoint" commands so they
can roll-back to a stable point from the snapshot while
allowing new user activity to proceed.

People who don't have checkpoints or some other way to
make their environment stable with a transitioning snapshot
must stop all user activity before snapshotting and have
maintenance windows defined to do that.

jim
