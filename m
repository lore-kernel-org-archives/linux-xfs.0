Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3C737CBE
	for <xfs@oss.sgi.com>; Sat,  8 Aug 2015 14:31:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A021304043
	for <xfs@oss.sgi.com>; Sat,  8 Aug 2015 12:31:03 -0700 (PDT)
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	mXXD2WkNfAz9oH2Z (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Aug 2015 12:31:01 -0700 (PDT)
Received: by ioii16 with SMTP id i16so138827003ioi.0
	for <xfs@oss.sgi.com>; Sat, 08 Aug 2015 12:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8996.1439052115@jrobl>
References: <20150807234150.GA11735@www.outflux.net>
	<8996.1439052115@jrobl>
Date: Sat, 8 Aug 2015 12:31:00 -0700
Message-ID: <CAGXu5jL5d5fQoE4GuVeC09ib5A5gOj+JyJ3ny99YEFpNVJxi9Q@mail.gmail.com>
Subject: Re: [PATCH] fs: create and use seq_show_option for escaping
From: Kees Cook <keescook@chromium.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Firo Yang <firogm@gmail.com>, David Howells <dhowells@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jiri Slaby <jslaby@suse.cz>, Christoph Hellwig <hch@lst.de>, "Yan, Zheng" <zyan@redhat.com>, Paul Moore <paul@paul-moore.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Ilya Dryomov <idryomov@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serge@hallyn.com>, Mark Fasheh <mfasheh@suse.com>, Jeff Dike <jdike@addtoit.com>, Jan Kara <jack@suse.com>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, Bob Peterson <rpeterso@redhat.com>, Joel Becker <jlbec@evilplan.org>, James Morris <james.l.morris@oracle.com>, Eric Paris <eparis@parisplace.org>, Steven Whitehouse <swhiteho@redhat.com>, Fabian Frederick <fabf@skynet.be>, Theodore Ts'o <tytso@mit.edu>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Al Viro <viro@zeniv.linux.org.uk>

On Sat, Aug 8, 2015 at 9:41 AM, J. R. Okajima <hooanon05g@gmail.com> wrote:
>
> Kees Cook:
>> This fixes the problem by adding new seq_show_option and seq_show_option_n
>> helpers, and updating the vulnerable show_option handlers to use them as
>> needed. Some, like SELinux, need to be open coded due to unusual existing
>> escape mechanisms.
>
> How about other ctrl chars such as CR or FF?
> I am using the similar function for many years, and it might be more
> generic because it supports all cntrl chars other than "\t\n\\" (see
> below).
>
> Many of other ctrl chars may not be necessary. But some people uses
> non-ASCII chars for their pathnames which may contain ESC or other
> chars. Any crazy chars can corrupt the output of /proc/mount and
> others. So it might be better to consider all ctrl chars.

While that's generally true, it's the consumers of mounts and
mountinfo that we need to worry about, and for those, it's only the
delimiters that we need to be concerned about (space, tab, newline,
and escapes).

However, since these consumers are expecting to deal with escapes, we
could, at any time, add new classes of characters to be escaped.

For this change, though, I wanted to keep it minimal for easiest backporting.

-Kees

-- 
Kees Cook
Chrome OS Security

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
