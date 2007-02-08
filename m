Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 18:34:30 -0800 (PST)
Received: from smtp105.mail.mud.yahoo.com (smtp105.mail.mud.yahoo.com [209.191.85.215])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l182YIm7006552
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 18:34:19 -0800
Message-ID: <45CA8C18.9020104@yahoo.com.au>
Date: Thu, 08 Feb 2007 13:34:00 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Subject: Re: [PATCH 1 of 2] Implement generic block_page_mkwrite() functionality
References: <20070207124922.GK44411608@melbourne.sgi.com> <Pine.LNX.4.64.0702071256530.25060@blonde.wat.veritas.com> <20070207144415.GN44411608@melbourne.sgi.com> <20070207155245.GB11967@think.oraclecorp.com>
In-Reply-To: <20070207155245.GB11967@think.oraclecorp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Mason <chris.mason@oracle.com>
Cc: David Chinner <dgc@sgi.com>, Hugh Dickins <hugh@veritas.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

Chris Mason wrote:
> On Thu, Feb 08, 2007 at 01:44:15AM +1100, David Chinner wrote:

>>So, do I need to grab the i_mutex here? Is that safe to do that in
>>the middle of a page fault? If we do race with a truncate and the
>>page is now beyond EOF, what am I supposed to return?
> 
> 
> Should it check to make sure the page is still in the address space
> after locking it?

Yes. If the page was truncated/invalidated, then you can just return
and the pagefault handler should notice that it has been removed from
the page tables.

-- 
SUSE Labs, Novell Inc.

Send instant messages to your online friends http://au.messenger.yahoo.com 
