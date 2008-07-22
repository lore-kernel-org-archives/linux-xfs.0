Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 23:05:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M65nBF026638
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 23:05:51 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] Export xfs_attr_set_int_trans
References: <1215675545-2707-5-git-send-email-xaiki@sgi.com>
	<1215754695-6958-1-git-send-email-xaiki@sgi.com>
	<20080722044337.GA10290@infradead.org>
Date: Tue, 22 Jul 2008 16:06:55 +1000
In-Reply-To: <20080722044337.GA10290@infradead.org> (Christoph Hellwig's
	message of "Tue, 22 Jul 2008 00:43:37 -0400")
Message-ID: <nccljzuh2ps.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> On Fri, Jul 11, 2008 at 03:38:14PM +1000, Niv Sardi wrote:
>> make xfs_attr_set_int_trans non static so we can use it outside of xfs_attr.c
>> (Needed to use it in vnodeops.c, for create+EA)
>
> Any reason this is not merged into the previous patch?

you =) you didn't like my attr_* function to be exported, so I splitted
the export out from now on. that's about it.

Cheers,
-- 
Niv Sardi
