Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:44:58 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N7itZl011948
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:44:56 -0700
Date: Wed, 23 Jul 2008 03:46:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Export xfs_attr_set_int_trans
Message-ID: <20080723074604.GB24031@infradead.org>
References: <1215675545-2707-5-git-send-email-xaiki@sgi.com> <1215754695-6958-1-git-send-email-xaiki@sgi.com> <20080722044337.GA10290@infradead.org> <nccljzuh2ps.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nccljzuh2ps.fsf@itchy.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 04:06:55PM +1000, Niv Sardi wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Fri, Jul 11, 2008 at 03:38:14PM +1000, Niv Sardi wrote:
> >> make xfs_attr_set_int_trans non static so we can use it outside of xfs_attr.c
> >> (Needed to use it in vnodeops.c, for create+EA)
> >
> > Any reason this is not merged into the previous patch?
> 
> you =) you didn't like my attr_* function to be exported, so I splitted
> the export out from now on. that's about it.

Heh, sorry.  The general rule is exporting it is fine if one of the
next patches uses it.  That wasn't obvious when you posted the first
patches, so I asked for it to be static for now.
