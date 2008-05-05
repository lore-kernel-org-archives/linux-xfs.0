Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 13:52:20 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m45Kq3nO028701
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 13:52:04 -0700
Message-ID: <481F7334.8000408@melbourne.sgi.com>
Date: Mon, 05 May 2008 13:51:00 -0700
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: Don't use d_alloc_anon for open_by_handle
References: <20080501070244.GH108924158@sgi.com> <1209693339-4861-1-git-send-email-xaiki@sgi.com> <20080502060654.GA23912@infradead.org> <ncczlr5b6pt.fsf@sgi.com> <20080505095316.GA23934@infradead.org> <20080505184424.GA25933@infradead.org>
In-Reply-To: <20080505184424.GA25933@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Niv Sardi <xaiki@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com, gnb@sgi.com

Christoph Hellwig wrote:
> On Mon, May 05, 2008 at 05:53:16AM -0400, Christoph Hellwig wrote:
>   
>> It shouldn't be slow.  You'd do the equivalent no_subtree check export
>> without parent fh, so what we do is call the fh_to_dentry method
>> and then call find_acceptable_alias to check if there's already an
>> dentry around and if yes use that one.  That latter part is what should
>> fix your problem.  If you want to be lazy you could just copy
>> find_acceptable_alias into the xfs code and call it directly and let me
>> clean up the mess later..
>>     
>
> Sorry, this was written before my cup of tea in the morning.
> find_acceptable_alias is of course a no-op in the no_subtree_check case,
> and thus it's identical to what we're currently doing in the handle
> code.  So any problem you see here will also be seen in an nfs
> environment with no_subtree_check, which is the sensible choise 
Agreed.
> and
> I think even the default these days.
I believe so.  We also use that as default on our shipping NAS servers
anyway.
>   So we'd better fix the lacking
> expiry in the core code. 
Mmm, sounds like fun.
>  Cc'ing Greg as he's been fighting this code
> quite a bit in the past.
>
>   
Thanks.  I'm on xfs-dev now so I've been lurking while you guys
discussed this :-)

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.
