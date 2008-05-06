Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 18:38:20 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m461bxFw018725
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 18:38:03 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: Don't use d_alloc_anon for open_by_handle
References: <20080501070244.GH108924158@sgi.com>
	<1209693339-4861-1-git-send-email-xaiki@sgi.com>
	<20080502060654.GA23912@infradead.org> <ncczlr5b6pt.fsf@sgi.com>
	<20080505095316.GA23934@infradead.org>
	<20080505184424.GA25933@infradead.org>
Date: Tue, 06 May 2008 11:38:37 +1000
In-Reply-To: <20080505184424.GA25933@infradead.org> (Christoph Hellwig's
	message of "Mon, 5 May 2008 14:44:24 -0400")
Message-ID: <nccve1sb49u.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com, gnb@sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, May 05, 2008 at 05:53:16AM -0400, Christoph Hellwig wrote:
>> It shouldn't be slow.  You'd do the equivalent no_subtree check
>> export without parent fh, so what we do is call the fh_to_dentry
>> method and then call find_acceptable_alias to check if there's
>> already an dentry around and if yes use that one.  That latter part
>> is what should fix your problem.  If you want to be lazy you could
>> just copy find_acceptable_alias into the xfs code and call it
>> directly and let me clean up the mess later..
>
> Sorry, this was written before my cup of tea in the morning.
> find_acceptable_alias is of course a no-op in the no_subtree_check
> case, and thus it's identical to what we're currently doing in the
> handle code.  So any problem you see here will also be seen in an nfs
> environment with no_subtree_check, which is the sensible choise and I
> think even the default these days.  So we'd better fix the lacking
> expiry in the core code.  Cc'ing Greg as he's been fighting this code
> quite a bit in the past.

So I've looked at find_acceptable_alias, and all it does is going
through the dentries associated with the inode associated with the
dentry we give it, testing if it's 'acceptable' with a function we
provide. In this very case *any* dentry is acceptable, so we'd just
provide a NO-OP there. So if I do as you suggest and call
xfs_fh_to_dentry, which would give me a dentry using d_alloc_anon, which
already tries to do the same thing with d_find_alias (just lacking the
'acceptable' check)… So we're back to the exact same situation as
now.

The argument is that we should then fix the core code… which should also
fix the issue in the way it is NOW… may I ask: ¿ what's the point in
moving things around ?

Further more, the only critic you gave to the proposed solution is 'even
more buggy than d_alloc_anon', from anyone else than you that would have
been a plain useless troll, but I belive you have your reasons to have
this position, can you please explain ?

The situation being now, that users of the xfs libhandle interface will
have dentries and inodes hanging in space and time for ever until OOM.

Cheers,
-- 
Niv Sardi
