Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727401AbeGSVSd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 17:18:33 -0400
Date: Thu, 19 Jul 2018 16:33:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/14] xfs: use internal dfops in cow blocks cancel
Message-ID: <20180719203346.GI29404@bfoster>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-10-bfoster@redhat.com>
 <20180719195748.GJ6558@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719195748.GJ6558@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 12:57:48PM -0700, Christoph Hellwig wrote:
> > +			ASSERT((*tpp)->t_dfops &&
> > +			       (*tpp)->t_firstblock == NULLFSBLOCK);
> 
> I'd make this two separate asserts so that we can see which one did
> caused it if it triggers.

Ok.

Brian
