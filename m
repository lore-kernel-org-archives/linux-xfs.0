Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 18:11:02 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m691Awkn023535
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 18:10:58 -0700
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49F4F1894633
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 18:12:02 -0700 (PDT)
Received: from thunker.thunk.org (www.church-of-our-saviour.org [69.25.196.31]) by cuda.sgi.com with ESMTP id H9MydiP32djqWzZM for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 18:12:02 -0700 (PDT)
Date: Tue, 8 Jul 2008 21:09:22 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709010922.GE9957@mit.edu>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709005254.GQ11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, Jul 09, 2008 at 10:52:54AM +1000, Dave Chinner wrote:
> If you walk enough inodes while the filesystem is frozen, it
> theoretically could happen.  Typically a filesystem is only for a
> few seconds at a time so in the real world this has never, ever been
> a problem.

I had argued for the timeout (and so it's mostly my fault that
Takashi-San included it as a feature) mainly because I was (and still
amm) deeply paranoid about the competence of the application
programers who might use this feature.  I could see them screwing up
leaving it locked forever --- perhaps when their program core dumps or
when the user types ^C and they forgot to install a signal handler,
leaving the filesystem frozen forever.

In the meantime, user applications that try to create files on that
filesystem, or write to files already opened when the filesystem are
frozen will accumulate dirty pages in the page cache, until the system
finally falls over.

Think about some of the evil perpetrated by hal and the userspace
suspend-resume scripts (and how much complexity with random XML
fragments getting parsed by various dbus plugins), and tell me with a
straight face that you would trust these modern-day desktop
application writers with this interface.  Because they *will* find
some interesting way to (ab)use it.....

Also, I didn't think the extra code complexity to implements timeouts
was *that* bad --- it seemed fairly small for the functionality.

Best regards,

						- Ted
